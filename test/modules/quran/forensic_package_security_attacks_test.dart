import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/modules/quran/store/quran_content_diff_engine.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('M2 Forensic Package Security & Tamper Attack Simulations (§15, §16, §25)', () {
    late CanonicalQuranPackage validPackage;
    late ReadOnlyCanonicalQuranStore store;
    late QuranContentDiffEngine diffEngine;

    setUp(() {
      validPackage = CanonicalQuranFixture.createValidTestPackage();
      store = ReadOnlyCanonicalQuranStore();
      diffEngine = const QuranContentDiffEngine();
    });

    test('Attack 1: Duplicate AyahKey in package is detected and rejected with DUPLICATE_AYAH_KEY', () {
      final duplicateAyahs = List<Ayah>.from(validPackage.ayahs);
      // Append a duplicate of the first Ayah
      duplicateAyahs.add(validPackage.ayahs.first);

      final attackPackage = CanonicalQuranPackage(
        packageId: validPackage.packageId,
        version: validPackage.version,
        schemaVersion: validPackage.schemaVersion,
        edition: validPackage.edition,
        surahs: validPackage.surahs,
        ayahs: duplicateAyahs,
        juzs: validPackage.juzs,
        contentHash: validPackage.contentHash,
        signerIdentity: validPackage.signerIdentity,
        signature: validPackage.signature,
      );

      final verifyRes = attackPackage.verifyIntegrity();
      expect(verifyRes.isFailure, isTrue);
      expect(verifyRes.failureOrNull!.code, equals('DUPLICATE_AYAH_KEY'));

      final mountRes = store.mountPackage(attackPackage);
      expect(mountRes.isFailure, isTrue);
      expect(store.isMounted, isFalse);
    });

    test('Attack 2: Reordered verses detected by DiffEngine and rejected by Aggregate Hash', () {
      final reversedAyahs = List<Ayah>.from(validPackage.ayahs.reversed);

      final attackPackage = CanonicalQuranPackage(
        packageId: validPackage.packageId,
        version: validPackage.version,
        schemaVersion: validPackage.schemaVersion,
        edition: validPackage.edition,
        surahs: validPackage.surahs,
        ayahs: reversedAyahs,
        juzs: validPackage.juzs,
        contentHash: validPackage.contentHash, // Stale hash computed for authentic order
        signerIdentity: validPackage.signerIdentity,
        signature: validPackage.signature,
      );

      // Diff engine detects reordering
      final diff = diffEngine.comparePackages(
        oldPackage: validPackage,
        newPackage: attackPackage,
      );
      expect(diff.hasDifferences, isTrue);
      expect(diff.hasCriticalTextDifferences, isTrue);
      expect(diff.ayahDifferences.any((d) => d.changeType == 'REORDERED'), isTrue);

      // Mount rejected by aggregate content hash
      final mountRes = store.mountPackage(attackPackage);
      expect(mountRes.isFailure, isTrue);
      expect(mountRes.failureOrNull!.code, equals('PACKAGE_HASH_MISMATCH'));
    });

    test('Attack 3: Last Known Good Package is preserved when a bad update is attempted', () {
      // 1. Mount authentic valid package
      final initialMountRes = store.mountPackage(validPackage);
      expect(initialMountRes.isSuccess, isTrue);
      expect(store.isMounted, isTrue);
      expect(store.mountedPackageId, equals('pkg_quran_uthmani_test_v1'));

      // 2. Attempt to mount a corrupted update package
      final corruptedAyahs = List<Ayah>.from(validPackage.ayahs);
      final orig = corruptedAyahs[0];
      corruptedAyahs[0] = Ayah(
        key: orig.key,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمُ', // altered harakah
        textSimple: orig.textSimple,
        juzNumber: orig.juzNumber,
        hizbNumber: orig.hizbNumber,
        rubNumber: orig.rubNumber,
        pageNumber: orig.pageNumber,
        manzilNumber: orig.manzilNumber,
        hasSajdah: orig.hasSajdah,
        integrityHash: orig.integrityHash,
      );

      final badUpdatePackage = CanonicalQuranPackage(
        packageId: 'pkg_quran_corrupt_v2',
        version: '2.0.0',
        schemaVersion: 1,
        edition: validPackage.edition,
        surahs: validPackage.surahs,
        ayahs: corruptedAyahs,
        juzs: validPackage.juzs,
        contentHash: validPackage.contentHash,
        signerIdentity: validPackage.signerIdentity,
        signature: validPackage.signature,
      );

      final updateMountRes = store.mountPackage(badUpdatePackage);
      expect(updateMountRes.isFailure, isTrue);

      // 3. Verify that the previous Good Package remains mounted, intact, and accessible
      expect(store.isMounted, isTrue);
      expect(store.mountedPackageId, equals('pkg_quran_uthmani_test_v1'));
      final ayah1Res = store.getAyah(1, 1);
      expect(ayah1Res.isSuccess, isTrue);
      expect(ayah1Res.valueOrNull!.textUthmani, equals('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'));
    });

    test('Attack 4: Unsupported schema version (<1) rejected immediately', () {
      final invalidSchemaPkg = CanonicalQuranPackage(
        packageId: 'pkg_invalid_schema',
        version: '0.9.0',
        schemaVersion: 0, // invalid
        edition: validPackage.edition,
        surahs: validPackage.surahs,
        ayahs: validPackage.ayahs,
        juzs: validPackage.juzs,
        contentHash: validPackage.contentHash,
        signerIdentity: validPackage.signerIdentity,
        signature: validPackage.signature,
      );

      final mountRes = store.mountPackage(invalidSchemaPkg);
      expect(mountRes.isFailure, isTrue);
      expect(mountRes.failureOrNull!.code, equals('UNSUPPORTED_SCHEMA_VERSION'));
    });
  });
}
