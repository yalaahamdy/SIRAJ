import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranModule quranModule;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    quranModule = QuranModule(storageRegistry: MemoryStorageRegistry());
    quranModule.mountPackage(package);
  });

  group('M02 Quran Bookmark Integration Tests', () {
    test('Can add, retrieve, and remove bookmarks for canonical Ayahs', () async {
      final initialBookmarks = await quranModule.getBookmarks();
      expect(initialBookmarks.valueOrNull, isEmpty);

      // Add bookmark for Surah 2 Ayah 255 (Ayat Al-Kursi)
      final addRes = await quranModule.addBookmark(
        surahNumber: 2,
        ayahNumber: 255,
        pageNumber: 42,
        surahNameArabic: 'البقرة',
        ayahSnippet: 'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ',
      );
      expect(addRes.isSuccess, isTrue);

      final updatedBookmarks = await quranModule.getBookmarks();
      expect(updatedBookmarks.valueOrNull!.length, equals(1));
      final b = updatedBookmarks.valueOrNull!.first;
      expect(b.surahNumber, equals(2));
      expect(b.ayahNumber, equals(255));

      // Remove bookmark
      final deleteRes = await quranModule.deleteBookmark(b.id);
      expect(deleteRes.isSuccess, isTrue);

      final finalBookmarks = await quranModule.getBookmarks();
      expect(finalBookmarks.valueOrNull, isEmpty);
    });
  });
}
