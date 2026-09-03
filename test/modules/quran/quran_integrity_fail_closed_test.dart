import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Quran Package Cryptographic Integrity & Fail-Closed Tests (§9, §28)', () {
    test('Single-character modification causes immediate verification failure and rejection', () {
      final validPkg = CanonicalQuranFixture.createValidTestPackage();
      final store = ReadOnlyCanonicalQuranStore();

      // Tamper with first Ayah of Al-Fatihah (e.g. single character change)
      final tamperedAyahs = List<Ayah>.from(validPkg.ayahs);
      final original = tamperedAyahs[0];

      tamperedAyahs[0] = Ayah(
        key: original.key,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمُ', // modified last damma instead of kasra
        textSimple: original.textSimple,
        juzNumber: original.juzNumber,
        hizbNumber: original.hizbNumber,
        rubNumber: original.rubNumber,
        pageNumber: original.pageNumber,
        manzilNumber: original.manzilNumber,
        hasSajdah: original.hasSajdah,
        integrityHash: original.integrityHash, // stale hash
      );

      final tamperedPkg = CanonicalQuranPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        edition: validPkg.edition,
        surahs: validPkg.surahs,
        ayahs: tamperedAyahs,
        juzs: validPkg.juzs,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: validPkg.signature,
      );

      // Mount attempt must fail closed
      final mountRes = store.mountPackage(tamperedPkg);

      expect(mountRes.isFailure, isTrue);
      expect(mountRes.failureOrNull!.code, anyOf(equals('AYAH_INTEGRITY_MISMATCH'), equals('PACKAGE_HASH_MISMATCH')));
      expect(store.isMounted, isFalse);
    });

    test('Rejects package with untrusted signer identity', () {
      final validPkg = CanonicalQuranFixture.createValidTestPackage();
      final store = ReadOnlyCanonicalQuranStore();

      final untrustedPkg = CanonicalQuranPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        edition: validPkg.edition,
        surahs: validPkg.surahs,
        ayahs: validPkg.ayahs,
        juzs: validPkg.juzs,
        contentHash: validPkg.contentHash,
        signerIdentity: 'UNKNOWN_ATTACKER_SIGNER_KEY',
        signature: validPkg.signature,
      );

      final mountRes = store.mountPackage(untrustedPkg);
      expect(mountRes.isFailure, isTrue);
      expect(mountRes.failureOrNull!.code, equals('UNTRUSTED_PACKAGE_SIGNER'));
      expect(store.isMounted, isFalse);
    });

    test('Rejects package with empty or invalid cryptographic signature', () {
      final validPkg = CanonicalQuranFixture.createValidTestPackage();
      final store = ReadOnlyCanonicalQuranStore();

      final unsignedPkg = CanonicalQuranPackage(
        packageId: validPkg.packageId,
        version: validPkg.version,
        schemaVersion: validPkg.schemaVersion,
        edition: validPkg.edition,
        surahs: validPkg.surahs,
        ayahs: validPkg.ayahs,
        juzs: validPkg.juzs,
        contentHash: validPkg.contentHash,
        signerIdentity: validPkg.signerIdentity,
        signature: '', // empty signature
      );

      final mountRes = store.mountPackage(unsignedPkg);
      expect(mountRes.isFailure, isTrue);
      expect(mountRes.failureOrNull!.code, equals('INVALID_PACKAGE_SIGNATURE'));
      expect(store.isMounted, isFalse);
    });
  });
}
