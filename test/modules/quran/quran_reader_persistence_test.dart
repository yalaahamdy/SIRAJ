import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('Quran Reading Continuity & Persistence Suite (§7, §15)', () {
    test('Reading position updates and persists across storage sessions', () async {
      final storage = MemoryStorageRegistry();

      final quranModule1 = QuranModule(storageRegistry: storage);
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      quranModule1.mountPackage(package);

      // Initial progress should be null or default
      final initialRes = await quranModule1.getReadingProgress();
      expect(initialRes.isSuccess, isTrue);

      // Update position to Surah 18 (Al-Kahf), Ayah 10, Page 294
      final updateRes = await quranModule1.updateReadingPosition(
        surahNumber: 18,
        ayahNumber: 10,
        pageNumber: 294,
        surahNameArabic: 'الكهف',
      );
      expect(updateRes.isSuccess, isTrue);
      final savedProgress = updateRes.valueOrNull!;
      expect(savedProgress.lastReadSurah, equals(18));
      expect(savedProgress.lastReadAyah, equals(10));
      expect(savedProgress.lastReadPage, equals(294));
      expect(savedProgress.surahNameArabic, equals('الكهف'));

      // Simulate app restart with a fresh module instance using same storage
      final quranModule2 = QuranModule(storageRegistry: storage);
      quranModule2.mountPackage(package);

      final restoredRes = await quranModule2.getReadingProgress();
      expect(restoredRes.isSuccess, isTrue);
      final restored = restoredRes.valueOrNull!;
      expect(restored.lastReadSurah, equals(18));
      expect(restored.lastReadAyah, equals(10));
      expect(restored.lastReadPage, equals(294));
      expect(restored.surahNameArabic, equals('الكهف'));
    });
  });
}
