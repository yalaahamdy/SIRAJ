import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/repetition_provenance.dart';
import 'package:siraj/modules/adhkar/store/adhkar_content_diff_engine.dart';
import 'package:siraj/modules/adhkar/store/canonical_adhkar_package.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('L2 Adhkar Content Diff Engine Tests (§28)', () {
    const diffEngine = AdhkarContentDiffEngine();
    late CanonicalAdhkarPackage basePackage;

    setUp(() {
      basePackage = CanonicalAdhkarFixture.createValidTestPackage();
    });

    test('Identical packages report no differences', () {
      final report = diffEngine.comparePackages(oldPackage: basePackage, newPackage: basePackage);
      expect(report.hasDifferences, isFalse);
      expect(report.hasCriticalDifferences, isFalse);
      expect(report.entries, isEmpty);
    });

    test('Detects text mutation, provenance mutation, and repetition mutation with high fidelity', () {
      final mutatedItems = List<DhikrItem>.from(basePackage.items);

      // Mutate item 0 text & source
      mutatedItems[0] = DhikrItem(
        id: mutatedItems[0].id,
        type: mutatedItems[0].type,
        textArabic: '${mutatedItems[0].textArabic} وَبِكَ نَحْيَا',
        sourceTitle: 'سنن أبي داود', // modified source
        sourceAuthor: 'الإمام أبو داود',
        reference: 'رقم 5068',
        authenticityGrade: mutatedItems[0].authenticityGrade,
        attribution: mutatedItems[0].attribution,
        occasion: mutatedItems[0].occasion,
        repetition: const RepetitionProvenance(count: 3, isSourced: true, note: '3 مرات'), // modified rep
        benefit: mutatedItems[0].benefit,
        integrityHash: mutatedItems[0].integrityHash,
      );

      final newPackage = CanonicalAdhkarPackage(
        packageId: 'pkg_adhkar_mutated_v2',
        version: '2.0.0',
        schemaVersion: 1,
        title: basePackage.title,
        items: mutatedItems,
        contentHash: basePackage.contentHash,
        signerIdentity: basePackage.signerIdentity,
        signature: basePackage.signature,
        publishedAt: DateTime.utc(2026, 9, 1),
      );

      final report = diffEngine.comparePackages(oldPackage: basePackage, newPackage: newPackage);
      expect(report.hasDifferences, isTrue);
      expect(report.hasCriticalDifferences, isTrue);

      final diffTypes = report.entries.map((e) => e.diffType).toSet();
      expect(diffTypes.contains(AdhkarDiffType.textMutation), isTrue);
      expect(diffTypes.contains(AdhkarDiffType.provenanceMutation), isTrue);
      expect(diffTypes.contains(AdhkarDiffType.repetitionMutation), isTrue);
    });
  });
}
