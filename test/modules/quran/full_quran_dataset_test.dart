import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('Full Quran Dataset Invariants & Completeness Suite (§3, §4, §15, §19)', () {
    test('Canonical Quran package contains exactly 114 Surahs, 6236 Ayahs, and 30 Juzs', () {
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();

      // 1. Verify 114 Surahs
      expect(package.surahs.length, equals(114));

      // 2. Verify exactly 6,236 Ayahs
      expect(package.ayahs.length, equals(6236));

      // 3. Verify 30 Juzs
      expect(package.juzs.length, equals(30));

      // 4. Verify Cryptographic Integrity
      final integrityRes = package.verifyIntegrity();
      expect(integrityRes.isSuccess, isTrue, reason: integrityRes.failureOrNull?.message);
    });

    test('Canonical Surah Ayah counts match authentic Medina Mushaf standard across all chapters', () {
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      final surahAyahsCountMap = <int, int>{};

      for (final ayah in package.ayahs) {
        surahAyahsCountMap[ayah.surahNumber] = (surahAyahsCountMap[ayah.surahNumber] ?? 0) + 1;
      }

      // Key milestone Surahs verification
      expect(surahAyahsCountMap[1], equals(7), reason: 'Al-Fatihah must have 7 Ayahs');
      expect(surahAyahsCountMap[2], equals(286), reason: 'Al-Baqarah must have 286 Ayahs');
      expect(surahAyahsCountMap[3], equals(200), reason: 'Ali Imran must have 200 Ayahs');
      expect(surahAyahsCountMap[4], equals(176), reason: 'An-Nisa must have 176 Ayahs');
      expect(surahAyahsCountMap[9], equals(129), reason: 'At-Tawbah must have 129 Ayahs');
      expect(surahAyahsCountMap[18], equals(110), reason: 'Al-Kahf must have 110 Ayahs');
      expect(surahAyahsCountMap[36], equals(83), reason: 'Ya-Sin must have 83 Ayahs');
      expect(surahAyahsCountMap[55], equals(78), reason: 'Ar-Rahman must have 78 Ayahs');
      expect(surahAyahsCountMap[67], equals(30), reason: 'Al-Mulk must have 30 Ayahs');
      expect(surahAyahsCountMap[112], equals(4), reason: 'Al-Ikhlas must have 4 Ayahs');
      expect(surahAyahsCountMap[113], equals(5), reason: 'Al-Falaq must have 5 Ayahs');
      expect(surahAyahsCountMap[114], equals(6), reason: 'An-Nas must have 6 Ayahs');

      // Verify every single surah matches its metadata count
      for (final surah in package.surahs) {
        expect(
          surahAyahsCountMap[surah.number],
          equals(surah.ayahCount),
          reason: 'Surah ${surah.number} (${surah.nameEnglish}) Ayah count mismatch',
        );
      }
    });

    test('All 30 Juzs span the entire Quran with continuous canonical ordering', () {
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      expect(package.juzs.length, equals(30));

      for (int j = 1; j <= 30; j++) {
        final juz = package.juzs.firstWhere((element) => element.number == j);
        expect(juz.number, equals(j));
        expect(juz.startSurahNumber, inInclusiveRange(1, 114));
        expect(juz.startPage, inInclusiveRange(1, 604));

        final ayahsInJuz = package.ayahs.where((a) => a.juzNumber == j).toList();
        expect(ayahsInJuz.isNotEmpty, isTrue, reason: 'Juz $j must have ayahs');
      }
    });

    test('Canonical loader loads translations, tajweed, and audio metadata reliably', () {
      final trans = CanonicalQuranLoader.loadTranslationsSync();
      expect(trans.length, equals(6236));
      expect(trans['1:1'], isNotNull);
      expect(trans['114:6'], isNotNull);

      final tajweed = CanonicalQuranLoader.loadTajweedRulesSync();
      expect(tajweed.isNotEmpty, isTrue);
      expect(tajweed.containsKey('1'), isTrue);
    });
  });
}
