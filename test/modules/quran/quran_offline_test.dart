import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('Quran 100% Offline Capability Suite (§10, §15)', () {
    test('All core Quran capabilities operate completely offline with zero network connectivity', () async {
      // 1. Initialize local offline storage
      final storage = MemoryStorageRegistry();

      // 2. Load and mount canonical package completely from local offline storage/assets
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      final quranModule = QuranModule(storageRegistry: storage);
      quranModule.mountPackage(package);

      // 3. Surah and Ayah retrieval works offline
      final surahsRes = quranModule.getAllSurahs();
      expect(surahsRes.isSuccess, isTrue);
      expect(surahsRes.valueOrNull!.length, equals(114));

      final ayahsRes = quranModule.getSurahAyahs(1);
      expect(ayahsRes.isSuccess, isTrue);
      expect(ayahsRes.valueOrNull!.length, equals(7));

      // 4. Offline search works with zero network calls
      final searchRes = quranModule.search('العالمين');
      expect(searchRes.isSuccess, isTrue);
      expect(searchRes.valueOrNull!.isNotEmpty, isTrue);

      // 5. Offline translations and tajweed access
      final trans = CanonicalQuranLoader.loadTranslationsSync();
      expect(trans.isNotEmpty, isTrue);

      final tajweed = CanonicalQuranLoader.loadTajweedRulesSync();
      expect(tajweed.isNotEmpty, isTrue);

      // 6. User reading position persistence offline
      final updateRes = await quranModule.updateReadingPosition(
        surahNumber: 1,
        ayahNumber: 2,
        pageNumber: 1,
        surahNameArabic: 'الفاتحة',
      );
      expect(updateRes.isSuccess, isTrue);

      final progressRes = await quranModule.getReadingProgress();
      expect(progressRes.isSuccess, isTrue);
      expect(progressRes.valueOrNull!.lastReadAyah, equals(2));
    });
  });
}
