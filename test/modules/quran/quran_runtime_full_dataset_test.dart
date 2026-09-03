import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Quran Runtime Full Dataset Production Path Suite (§12, §15)', () {
    late QuranModule quranModule;

    setUp(() async {
      // Load strictly from the real packaged canonical asset file — NO test fixtures
      final package = await CanonicalQuranLoader.loadPackage();
      quranModule = QuranModule(storageRegistry: MemoryStorageRegistry());
      final mountRes = quranModule.store.mountPackage(package);
      expect(mountRes.isSuccess, isTrue, reason: 'Failed to mount canonical package');
    });

    test('Loads exactly 114 Surahs with unique numbers', () {
      final surahsRes = quranModule.getAllSurahs();
      expect(surahsRes.isSuccess, isTrue);
      final surahs = surahsRes.valueOrNull!;

      expect(surahs.length, equals(114));

      final seenNumbers = <int>{};
      for (final s in surahs) {
        expect(seenNumbers.contains(s.number), isFalse, reason: 'Duplicate surah number ${s.number}');
        seenNumbers.add(s.number);
      }
      expect(seenNumbers.length, equals(114));
    });

    test('Contains exactly 6,236 Ayahs across all Surahs with zero duplicates', () {
      int totalAyahs = 0;
      final seenKeys = <AyahKey>{};

      for (int s = 1; s <= 114; s++) {
        final ayahsRes = quranModule.getSurahAyahs(s);
        expect(ayahsRes.isSuccess, isTrue, reason: 'Surah $s failed to return ayahs');
        final ayahs = ayahsRes.valueOrNull!;
        expect(ayahs.isNotEmpty, isTrue, reason: 'Surah $s has empty content');

        final surahInfo = quranModule.getSurah(s).valueOrNull!;
        expect(ayahs.length, equals(surahInfo.ayahCount), reason: 'Ayah count mismatch in surah $s');

        for (final a in ayahs) {
          expect(seenKeys.contains(a.key), isFalse, reason: 'Duplicate AyahKey ${a.key}');
          seenKeys.add(a.key);
          totalAyahs++;
        }
      }

      expect(totalAyahs, equals(6236));
      expect(seenKeys.length, equals(6236));
    });

    test('Verifies existence and boundary Ayahs of key sample Surahs (1, 2, 18, 36, 55, 57, 67, 114)', () {
      final checkSurahs = [1, 2, 18, 36, 55, 57, 67, 114];

      for (final surahNum in checkSurahs) {
        final surahRes = quranModule.getSurah(surahNum);
        expect(surahRes.isSuccess, isTrue, reason: 'Surah $surahNum must exist');
        final surah = surahRes.valueOrNull!;

        final ayahsRes = quranModule.getSurahAyahs(surahNum);
        expect(ayahsRes.isSuccess, isTrue);
        final ayahs = ayahsRes.valueOrNull!;
        expect(ayahs.length, equals(surah.ayahCount));

        // First Ayah exists and matches
        final firstAyah = ayahs.first;
        expect(firstAyah.ayahNumber, equals(1));
        expect(firstAyah.textUthmani.isNotEmpty, isTrue);

        // Last Ayah exists and matches
        final lastAyah = ayahs.last;
        expect(lastAyah.ayahNumber, equals(surah.ayahCount));
        expect(lastAyah.textUthmani.isNotEmpty, isTrue);
      }
    });

    test('Late Quran search finds verses from Surah 50+ and Surah 114', () {
      // Search for a word known in Surah An-Nas (114): الوسواس
      final searchNas = quranModule.search('الوسواس');
      expect(searchNas.isSuccess, isTrue);
      final resultsNas = searchNas.valueOrNull!;
      expect(resultsNas.any((r) => r.ayah.surahNumber == 114), isTrue,
          reason: 'Word from Surah 114 must be indexed');

      // Search for a word known in Surah Al-Hadid (57): الحديد
      final searchHadid = quranModule.search('الحديد');
      expect(searchHadid.isSuccess, isTrue);
      final resultsHadid = searchHadid.valueOrNull!;
      expect(resultsHadid.any((r) => r.ayah.surahNumber == 57), isTrue,
          reason: 'Word from Surah 57 must be indexed');
    });
  });
}
