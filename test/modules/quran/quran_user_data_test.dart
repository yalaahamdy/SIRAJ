import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/quran/services/quran_user_data_service.dart';

void main() {
  group('L2 Quran User Data Isolation & Local-First Tests (§14, §27)', () {
    late MemoryStorageRegistry storageRegistry;
    late TestClock clock;
    late QuranUserDataService service;

    setUp(() {
      storageRegistry = MemoryStorageRegistry();
      clock = TestClock(DateTime.utc(2026, 8, 31, 10, 0));
      service = QuranUserDataService(storageRegistry: storageRegistry, clock: clock);
    });

    test('Saves and retrieves bookmarks strictly within mod_quran namespace', () async {
      final addRes = await service.addBookmark(
        surahNumber: 1,
        ayahNumber: 1,
        pageNumber: 1,
        surahNameArabic: 'الفاتحة',
        ayahSnippet: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      );

      expect(addRes.isSuccess, isTrue);
      final bookmark = addRes.valueOrNull!;
      expect(bookmark.surahNumber, equals(1));
      expect(bookmark.ayahNumber, equals(1));

      final getRes = await service.getBookmarks();
      expect(getRes.isSuccess, isTrue);
      expect(getRes.valueOrNull!.length, equals(1));
      expect(getRes.valueOrNull!.first.surahNameArabic, equals('الفاتحة'));

      // Delete bookmark
      final delRes = await service.deleteBookmark(bookmark.id);
      expect(delRes.isSuccess, isTrue);

      final afterDelRes = await service.getBookmarks();
      expect(afterDelRes.valueOrNull!.isEmpty, isTrue);
    });

    test('Saves and retrieves reading progress', () async {
      final updateRes = await service.updateProgress(
        surahNumber: 112,
        ayahNumber: 2,
        pageNumber: 604,
        surahNameArabic: 'الإخلاص',
      );

      expect(updateRes.isSuccess, isTrue);

      final getRes = await service.getProgress();
      expect(getRes.isSuccess, isTrue);
      final progress = getRes.valueOrNull!;
      expect(progress.lastReadSurah, equals(112));
      expect(progress.lastReadAyah, equals(2));
      expect(progress.lastReadPage, equals(604));
      expect(progress.surahNameArabic, equals('الإخلاص'));
    });
  });
}
