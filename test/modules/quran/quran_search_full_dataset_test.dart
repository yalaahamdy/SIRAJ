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

  group('Quran Full Dataset Search Engine Suite (§9, §15)', () {
    test('Normalized text search finds matches across the full 6,236 Ayahs', () {
      final res = quranModule.search('الرحمن');
      expect(res.isSuccess, isTrue);
      final results = res.valueOrNull!;
      expect(results.isNotEmpty, isTrue);

      // Verify each result contains the search keyword
      for (final r in results) {
        expect(r.ayah.textSimple.contains('الرحمن'), isTrue);
      }
    });

    test('Diacritics invariance: Search with Tashkeel matches identical verses as plain text', () {
      final resPlain = quranModule.search('الجنة');
      final resVocalized = quranModule.search('الجَنَّةِ');

      expect(resPlain.isSuccess, isTrue);
      expect(resVocalized.isSuccess, isTrue);
      expect(resPlain.valueOrNull!.length, equals(resVocalized.valueOrNull!.length));
    });

    test('Surah filtering limits results strictly to the specified chapter', () {
      // Search 'الله' specifically in Surah 112 (Al-Ikhlas)
      final resSurah112 = quranModule.search('الله', surahNumber: 112);
      expect(resSurah112.isSuccess, isTrue);
      final results = resSurah112.valueOrNull!;

      expect(results.length, equals(2)); // Ayah 1: قل هو الله أحد, Ayah 2: الله الصمد
      for (final r in results) {
        expect(r.ayah.surahNumber, equals(112));
      }
    });

    test('Empty or whitespace queries return empty results without error', () {
      expect(quranModule.search('').valueOrNull!, isEmpty);
      expect(quranModule.search('   ').valueOrNull!, isEmpty);
    });

    test('Search results are sorted by relevance score descending', () {
      final res = quranModule.search('صراط');
      expect(res.isSuccess, isTrue);
      final results = res.valueOrNull!;
      expect(results.length, greaterThan(1));

      for (int i = 0; i < results.length - 1; i++) {
        expect(results[i].score, greaterThanOrEqualTo(results[i + 1].score));
      }
    });
  });
}
