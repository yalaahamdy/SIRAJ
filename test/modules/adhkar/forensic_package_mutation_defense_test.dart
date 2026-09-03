import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/authenticity_grade.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_type.dart';
import 'package:siraj/modules/adhkar/store/adhkar_content_diff_engine.dart';
import 'package:siraj/modules/adhkar/store/canonical_adhkar_package.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('M4 Forensic Package Mutation Defense & Diff Engine Tests (§18, §19, §20)', () {
    const diffEngine = AdhkarContentDiffEngine();
    late ReadOnlyAdhkarStore store;
    late CanonicalAdhkarPackage validPkg;

    setUp(() {
      store = ReadOnlyAdhkarStore();
      validPkg = CanonicalAdhkarFixture.createValidTestPackage();
    });

    test('Diff Engine detects typeMutation and authenticityMutation as critical differences', () {
      final mutatedItems = List<DhikrItem>.from(validPkg.items);

      // Mutate type and authenticity
      mutatedItems[0] = DhikrItem(
        id: mutatedItems[0].id,
        type: DhikrType.generalDua, // Type mutation
        textArabic: mutatedItems[0].textArabic,
        sourceTitle: mutatedItems[0].sourceTitle,
        sourceAuthor: mutatedItems[0].sourceAuthor,
        reference: mutatedItems[0].reference,
        authenticityGrade: AuthenticityGrade.acceptedWithNote, // Authenticity mutation
        attribution: mutatedItems[0].attribution,
        occasion: mutatedItems[0].occasion,
        repetition: mutatedItems[0].repetition,
        benefit: mutatedItems[0].benefit,
        integrityHash: mutatedItems[0].integrityHash,
      );

      final newPkg = CanonicalAdhkarPackage(
        packageId: 'pkg_adhkar_diff_test',
        version: '1.1.0',
        schemaVersion: 1,
        title: validPkg.title,
        items: mutatedItems,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: DateTime.utc(2026, 9, 1),
      );

      final diffReport = diffEngine.comparePackages(oldPackage: validPkg, newPackage: newPkg);
      expect(diffReport.hasDifferences, isTrue);
      expect(diffReport.hasCriticalDifferences, isTrue);

      final diffTypes = diffReport.entries.map((e) => e.diffType).toSet();
      expect(diffTypes.contains(AdhkarDiffType.typeMutation), isTrue);
      expect(diffTypes.contains(AdhkarDiffType.authenticityMutation), isTrue);
    });

    test('Update Security: Corrupted update is rejected and Last Known Good remains active', () {
      // 1. Mount initial valid package
      store.mountPackage(validPkg);
      expect(store.isMounted, isTrue);
      expect(store.activePackage?.packageId, equals(validPkg.packageId));

      // 2. Corrupt aggregate hash in update package
      final badUpdatePkg = CanonicalAdhkarPackage(
        packageId: 'pkg_adhkar_bad_update',
        version: '2.0.0',
        schemaVersion: 1,
        title: 'تحديث تالف',
        items: validPkg.items,
        contentHash: 'sha256:0000000000000000000000000000000000000000000000000000000000000000', // Bad hash
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: DateTime.utc(2026, 9, 1),
      );

      final updateRes = store.mountPackage(badUpdatePkg);
      expect(updateRes.isFailure, isTrue);

      // Verify original package is still mounted and serving requests
      expect(store.activePackage?.packageId, equals(validPkg.packageId));
      expect(store.getAllItems().valueOrNull?.length, equals(validPkg.items.length));
    });
  });
}
