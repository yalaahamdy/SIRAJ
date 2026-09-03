import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  late QuranModule quranModule;

  setUp(() {
    final storage = MemoryStorageRegistry();
    quranModule = QuranModule(storageRegistry: storage);
    final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
    quranModule.mountPackage(package);
  });

  group('Quran Navigation & Pagination Invariants Suite (§5, §6, §15)', () {
    test('Can navigate through all 114 Surahs sequentially from 1 to 114', () {
      final allSurahsRes = quranModule.getAllSurahs();
      expect(allSurahsRes.isSuccess, isTrue);
      final surahs = allSurahsRes.valueOrNull!;
      expect(surahs.length, equals(114));

      for (int i = 1; i <= 114; i++) {
        final sRes = quranModule.getSurah(i);
        expect(sRes.isSuccess, isTrue);
        expect(sRes.valueOrNull!.number, equals(i));

        final ayahsRes = quranModule.getSurahAyahs(i);
        expect(ayahsRes.isSuccess, isTrue);
        expect(ayahsRes.valueOrNull!.length, equals(sRes.valueOrNull!.ayahCount));
      }
    });

    test('Boundary limits: Surah 1 has no previous, Surah 114 has no next', () {
      final s0Res = quranModule.getSurah(0);
      expect(s0Res.isFailure, isTrue);

      final s115Res = quranModule.getSurah(115);
      expect(s115Res.isFailure, isTrue);
    });

    test('Juz Navigation spans 1 to 30 and retrieves correct ayahs', () {
      for (int j = 1; j <= 30; j++) {
        final jAyahsRes = quranModule.readerService.getJuzAyahs(j);
        expect(jAyahsRes.isSuccess, isTrue, reason: 'Failed for Juz $j');
        final ayahs = jAyahsRes.valueOrNull!;
        expect(ayahs.isNotEmpty, isTrue);
        for (final a in ayahs) {
          expect(a.juzNumber, equals(j));
        }
      }
    });

    test('Page Navigation retrieves valid Medina Mushaf pages (1..604)', () {
      // Test page 1 (Al-Fatihah)
      final page1Res = quranModule.getPage(1);
      expect(page1Res.isSuccess, isTrue);
      expect(page1Res.valueOrNull!.pageNumber, equals(1));
      expect(page1Res.valueOrNull!.ayahs.isNotEmpty, isTrue);

      // Test page 604 (Al-Ikhlas, Al-Falaq, An-Nas)
      final page604Res = quranModule.getPage(604);
      expect(page604Res.isSuccess, isTrue);
      expect(page604Res.valueOrNull!.pageNumber, equals(604));
      expect(page604Res.valueOrNull!.ayahs.isNotEmpty, isTrue);

      // Out of bounds pages
      expect(quranModule.getPage(0).isFailure, isTrue);
      expect(quranModule.getPage(605).isFailure, isTrue);
    });

    test('Jump to Ayah directly retrieves valid Ayah within a Surah', () {
      // Jump to Ayah 255 of Al-Baqarah (Ayat al-Kursi)
      final ayahRes = quranModule.readerService.getAyah(2, 255);
      expect(ayahRes.isSuccess, isTrue);
      final ayah = ayahRes.valueOrNull!;
      expect(ayah.surahNumber, equals(2));
      expect(ayah.ayahNumber, equals(255));
      expect(ayah.textUthmani.isNotEmpty, isTrue);
    });
  });
}
