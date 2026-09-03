import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';
import 'package:siraj/modules/quran/store/quran_content_diff_engine.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Quran Content Diff Engine Tests (§19)', () {
    const diffEngine = QuranContentDiffEngine();
    late CanonicalQuranPackage basePkg;

    setUp(() {
      basePkg = CanonicalQuranFixture.createValidTestPackage();
    });

    test('Identical packages report zero differences', () {
      final report = diffEngine.comparePackages(
        oldPackage: basePkg,
        newPackage: basePkg,
      );

      expect(report.hasDifferences, isFalse);
      expect(report.hasCriticalTextDifferences, isFalse);
      expect(report.ayahDifferences.isEmpty, isTrue);
    });

    test('Detects single-character text mutation as critical difference', () {
      final modifiedAyahs = List<Ayah>.from(basePkg.ayahs);
      final original = modifiedAyahs.first;

      modifiedAyahs[0] = Ayah(
        key: original.key,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمُ', // subtle harakah change
        textSimple: original.textSimple,
        juzNumber: original.juzNumber,
        hizbNumber: original.hizbNumber,
        rubNumber: original.rubNumber,
        pageNumber: original.pageNumber,
        manzilNumber: original.manzilNumber,
        hasSajdah: original.hasSajdah,
        integrityHash: original.integrityHash,
      );

      final modifiedPkg = CanonicalQuranPackage(
        packageId: basePkg.packageId,
        version: '1.0.1',
        schemaVersion: basePkg.schemaVersion,
        edition: basePkg.edition,
        surahs: basePkg.surahs,
        ayahs: modifiedAyahs,
        juzs: basePkg.juzs,
        contentHash: basePkg.contentHash,
        signerIdentity: basePkg.signerIdentity,
        signature: basePkg.signature,
      );

      final report = diffEngine.comparePackages(
        oldPackage: basePkg,
        newPackage: modifiedPkg,
      );

      expect(report.hasDifferences, isTrue);
      expect(report.hasCriticalTextDifferences, isTrue);
      expect(report.ayahDifferences.first.changeType, equals('TEXT_MUTATION'));
      expect(report.ayahDifferences.first.key.toString(), equals('1:1'));
    });

    test('Detects removed Ayah as critical difference', () {
      final truncatedAyahs = List<Ayah>.from(basePkg.ayahs)..removeLast();

      final truncatedPkg = CanonicalQuranPackage(
        packageId: basePkg.packageId,
        version: '1.0.1',
        schemaVersion: basePkg.schemaVersion,
        edition: basePkg.edition,
        surahs: basePkg.surahs,
        ayahs: truncatedAyahs,
        juzs: basePkg.juzs,
        contentHash: basePkg.contentHash,
        signerIdentity: basePkg.signerIdentity,
        signature: basePkg.signature,
      );

      final report = diffEngine.comparePackages(
        oldPackage: basePkg,
        newPackage: truncatedPkg,
      );

      expect(report.hasDifferences, isTrue);
      expect(report.hasCriticalTextDifferences, isTrue);
      expect(report.ayahDifferences.any((d) => d.changeType == 'REMOVED'), isTrue);
    });
  });
}
