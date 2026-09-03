import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/quran/services/quran_reader_service.dart';
import 'package:siraj/modules/quran/services/quran_user_data_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Quran Reader Service Application Tests (§12, §13)', () {
    late ReadOnlyCanonicalQuranStore store;
    late QuranUserDataService userDataService;
    late QuranReaderService readerService;

    setUp(() {
      store = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      store.mountPackage(package);

      final storage = MemoryStorageRegistry();
      final clock = TestClock(DateTime.utc(2026, 8, 31, 12, 0));
      userDataService = QuranUserDataService(storageRegistry: storage, clock: clock);

      readerService = QuranReaderService(
        store: store,
        userDataService: userDataService,
      );
    });

    test('Provides full access to Surahs, Pages, and Ayahs', () {
      final surahsRes = readerService.getAllSurahs();
      expect(surahsRes.isSuccess, isTrue);
      expect(surahsRes.valueOrNull!.length, equals(114));

      final fatihahRes = readerService.getSurahAyahs(1);
      expect(fatihahRes.isSuccess, isTrue);
      expect(fatihahRes.valueOrNull!.length, equals(7));

      final page1Res = readerService.getPage(1);
      expect(page1Res.isSuccess, isTrue);
      expect(page1Res.valueOrNull!.pageNumber, equals(1));
    });

    test('Integrates user reading progress and bookmarks seamlessly', () async {
      final progressRes = await readerService.updateReadingPosition(
        surahNumber: 1,
        ayahNumber: 4,
        pageNumber: 1,
        surahNameArabic: 'الفاتحة',
      );
      expect(progressRes.isSuccess, isTrue);

      final currentProgRes = await readerService.getReadingProgress();
      expect(currentProgRes.isSuccess, isTrue);
      expect(currentProgRes.valueOrNull!.lastReadAyah, equals(4));

      // Bookmark
      final bmRes = await readerService.addBookmark(
        surahNumber: 1,
        ayahNumber: 4,
        pageNumber: 1,
        surahNameArabic: 'الفاتحة',
        ayahSnippet: 'مَٰلِكِ يَوْمِ ٱلدِّينِ',
      );
      expect(bmRes.isSuccess, isTrue);

      final allBms = await readerService.getBookmarks();
      expect(allBms.isSuccess, isTrue);
      expect(allBms.valueOrNull!.length, equals(1));
    });
  });
}
