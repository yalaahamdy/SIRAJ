import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/domain/repetition_provenance.dart';
import 'package:siraj/modules/adhkar/store/canonical_adhkar_package.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('M4 Adversarial Security & Cryptographic Attack Tests (§32, §43)', () {
    late ReadOnlyAdhkarStore store;
    late CanonicalAdhkarPackage validPkg;

    setUp(() {
      store = ReadOnlyAdhkarStore();
      validPkg = CanonicalAdhkarFixture.createValidTestPackage();
    });

    test('Attack 1: Single character or diacritic mutation in text causes instant Fail-Closed rejection', () {
      final items = List<DhikrItem>.from(validPkg.items);
      // Remove one vowel (Fatha) from text without updating hash
      final tamperedText = items[0].textArabic.replaceFirst('أَصْبَحْنَا', 'أَصْبَحنا');
      items[0] = DhikrItem(
        id: items[0].id,
        type: items[0].type,
        textArabic: tamperedText,
        sourceTitle: items[0].sourceTitle,
        sourceAuthor: items[0].sourceAuthor,
        reference: items[0].reference,
        authenticityGrade: items[0].authenticityGrade,
        attribution: items[0].attribution,
        occasion: items[0].occasion,
        repetition: items[0].repetition,
        benefit: items[0].benefit,
        integrityHash: items[0].integrityHash,
      );

      final attackPkg = CanonicalAdhkarPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        title: validPkg.title,
        items: items,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final mountRes = store.mountPackage(attackPkg);
      expect(mountRes.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });

    test('Attack 2: Tampering with Attribution or Hadith Reference causes instant Fail-Closed rejection', () {
      final items = List<DhikrItem>.from(validPkg.items);
      items[0] = DhikrItem(
        id: items[0].id,
        type: items[0].type,
        textArabic: items[0].textArabic,
        sourceTitle: items[0].sourceTitle,
        sourceAuthor: items[0].sourceAuthor,
        reference: 'كتاب الصلاة، رقم 9999', // forged reference
        authenticityGrade: items[0].authenticityGrade,
        attribution: items[0].attribution,
        occasion: items[0].occasion,
        repetition: items[0].repetition,
        benefit: items[0].benefit,
        integrityHash: items[0].integrityHash,
      );

      final attackPkg = CanonicalAdhkarPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        title: validPkg.title,
        items: items,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final mountRes = store.mountPackage(attackPkg);
      expect(mountRes.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });

    test('Attack 3: Altering repetition count from 1 to 100 without authorization is detected and rejected', () {
      final items = List<DhikrItem>.from(validPkg.items);
      items[0] = DhikrItem(
        id: items[0].id,
        type: items[0].type,
        textArabic: items[0].textArabic,
        sourceTitle: items[0].sourceTitle,
        sourceAuthor: items[0].sourceAuthor,
        reference: items[0].reference,
        authenticityGrade: items[0].authenticityGrade,
        attribution: items[0].attribution,
        occasion: items[0].occasion,
        repetition: const RepetitionProvenance(count: 100, isSourced: true), // altered repetition count
        benefit: items[0].benefit,
        integrityHash: items[0].integrityHash,
      );

      final attackPkg = CanonicalAdhkarPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        title: validPkg.title,
        items: items,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final mountRes = store.mountPackage(attackPkg);
      expect(mountRes.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });

    test('Attack 4: Duplicate Dhikr IDs within the same package cause immediate mounting rejection', () {
      final items = List<DhikrItem>.from(validPkg.items);
      // Duplicate item 0 ID on item 1
      final dupeItem = CanonicalAdhkarFixture.createItem(
        id: items[0].id, // Duplicate ID!
        textArabic: items[1].textArabic,
        sourceTitle: items[1].sourceTitle,
        sourceAuthor: items[1].sourceAuthor,
        reference: items[1].reference,
        authenticityGrade: items[1].authenticityGrade,
        attribution: items[1].attribution,
        occasion: items[1].occasion,
        repetition: items[1].repetition,
      );
      items[1] = dupeItem;

      final dupePkg = CanonicalAdhkarPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        title: validPkg.title,
        items: items,
        contentHash: CanonicalAdhkarPackage.computeAggregateHash(items),
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
        publishedAt: validPkg.publishedAt,
      );

      final mountRes = store.mountPackage(dupePkg);
      expect(mountRes.isFailure, isTrue);
      expect(mountRes.failureOrNull?.message.contains('Duplicate Dhikr ID'), isTrue);
    });
  });
}
