import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_item.dart';
import 'package:siraj/modules/adhkar/store/canonical_adhkar_package.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('L2 Adhkar Package Cryptographic Integrity Tests (§26, §27)', () {
    test('Valid synthetic package passes all integrity and verification checks', () {
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      expect(package.verifyPackageIntegrity(), isTrue);
    });

    test('Rejects package if any individual Dhikr item hash is tampered', () {
      final validPkg = CanonicalAdhkarFixture.createValidTestPackage();
      final items = List<DhikrItem>.from(validPkg.items);

      final original = items[0];
      final tamperedItem = DhikrItem(
        id: original.id,
        type: original.type,
        textArabic: '${original.textArabic} [مُعدل]',
        sourceTitle: original.sourceTitle,
        sourceAuthor: original.sourceAuthor,
        reference: original.reference,
        authenticityGrade: original.authenticityGrade,
        attribution: original.attribution,
        occasion: original.occasion,
        repetition: original.repetition,
        benefit: original.benefit,
        integrityHash: original.integrityHash, // Out of sync!
      );
      items[0] = tamperedItem;

      final corruptedPkg = CanonicalAdhkarPackage(
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

      expect(corruptedPkg.verifyPackageIntegrity(), isFalse);
    });

    test('Rejects package with empty signature or signer identity', () {
      final validPkg = CanonicalAdhkarFixture.createValidTestPackage();

      final noSigPkg = CanonicalAdhkarPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        title: validPkg.title,
        items: validPkg.items,
        contentHash: validPkg.contentHash,
        signerIdentity: '',
        signature: '',
        publishedAt: validPkg.publishedAt,
      );

      expect(noSigPkg.verifyPackageIntegrity(), isFalse);
    });
  });
}
