import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('Quran Bookmarks & Tags Suite (§8, §15)', () {
    test('Can create, retrieve, and delete bookmarks deterministically', () async {
      final storage = MemoryStorageRegistry();

      final quranModule = QuranModule(storageRegistry: storage);
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      quranModule.mountPackage(package);

      // 1. Initial bookmarks list is empty
      final initialList = await quranModule.getBookmarks();
      expect(initialList.isSuccess, isTrue);
      expect(initialList.valueOrNull!, isEmpty);

      // 2. Add bookmark at Surah 2 (Al-Baqarah) Ayah 255 (Ayat al-Kursi)
      final addRes = await quranModule.addBookmark(
        surahNumber: 2,
        ayahNumber: 255,
        pageNumber: 42,
        surahNameArabic: 'البقرة',
        ayahSnippet: 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ',
        note: 'آية الكرسي',
      );
      expect(addRes.isSuccess, isTrue);
      final bookmark = addRes.valueOrNull!;
      expect(bookmark.surahNumber, equals(2));
      expect(bookmark.ayahNumber, equals(255));
      expect(bookmark.note, equals('آية الكرسي'));

      // 3. Retrieve list and verify
      final listRes = await quranModule.getBookmarks();
      expect(listRes.isSuccess, isTrue);
      expect(listRes.valueOrNull!.length, equals(1));
      expect(listRes.valueOrNull!.first.id, equals(bookmark.id));

      // 4. Delete bookmark
      final deleteRes = await quranModule.deleteBookmark(bookmark.id);
      expect(deleteRes.isSuccess, isTrue);

      // 5. Verify deletion
      final finalList = await quranModule.getBookmarks();
      expect(finalList.isSuccess, isTrue);
      expect(finalList.valueOrNull!, isEmpty);
    });
  });
}
