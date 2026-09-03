import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/ayah.dart';
import '../domain/juz_info.dart';
import '../domain/mushaf_page.dart';
import '../domain/quran_bookmark.dart';
import '../domain/quran_reading_progress.dart';
import '../domain/surah.dart';
import '../search/quran_search_engine.dart';
import '../store/canonical_quran_store.dart';
import 'quran_user_data_service.dart';

/// Application Service managing Quran reading, page rendering, navigation, and bookmarks (§12, §13).
class QuranReaderService {
  final ReadOnlyCanonicalQuranStore _store;
  final QuranSearchEngine _searchEngine;
  final QuranUserDataService _userDataService;

  QuranReaderService({
    required ReadOnlyCanonicalQuranStore store,
    required QuranUserDataService userDataService,
    QuranSearchEngine? searchEngine,
  })  : _store = store,
        _userDataService = userDataService,
        _searchEngine = searchEngine ?? QuranSearchEngine(store: store);

  bool get isMounted => _store.isMounted;

  /// Retrieves the list of all 114 Surahs.
  Result<List<Surah>, Failure> getAllSurahs() => _store.getAllSurahs();

  /// Retrieves a specific Surah by number (1..114).
  Result<Surah, Failure> getSurah(int surahNumber) => _store.getSurah(surahNumber);

  /// Retrieves all Ayahs of a specific Surah in canonical order.
  Result<List<Ayah>, Failure> getSurahAyahs(int surahNumber) => _store.getSurahAyahs(surahNumber);

  /// Retrieves a specific Ayah by Surah number and Ayah number.
  Result<Ayah, Failure> getAyah(int surahNumber, int ayahNumber) => _store.getAyah(surahNumber, ayahNumber);

  /// Retrieves a specific Mushaf page (1..604) with its Ayahs and header info.
  Result<MushafPage, Failure> getPage(int pageNumber) => _store.getPage(pageNumber);

  /// Retrieves the list of all 30 Juzs.
  Result<List<JuzInfo>, Failure> getAllJuzs() => _store.getAllJuzs();

  /// Retrieves all Ayahs in a specific Juz (1..30).
  Result<List<Ayah>, Failure> getJuzAyahs(int juzNumber) => _store.getJuzAyahs(juzNumber);

  /// Executes normalized keyword search across the Quran, optionally filtered by Surah.
  Result<List<QuranSearchResult>, Failure> search(String query, {int? surahNumber, int limit = 50}) {
    return _searchEngine.search(query, surahNumber: surahNumber, limit: limit);
  }

  /// Updates the user's current reading position.
  Future<Result<QuranReadingProgress, Failure>> updateReadingPosition({
    required int surahNumber,
    required int ayahNumber,
    required int pageNumber,
    required String surahNameArabic,
  }) {
    return _userDataService.updateProgress(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      pageNumber: pageNumber,
      surahNameArabic: surahNameArabic,
    );
  }

  /// Retrieves the user's current reading progress.
  Future<Result<QuranReadingProgress, Failure>> getReadingProgress() {
    return _userDataService.getProgress();
  }

  /// Adds a bookmark for an Ayah.
  Future<Result<QuranBookmark, Failure>> addBookmark({
    required int surahNumber,
    required int ayahNumber,
    required int pageNumber,
    required String surahNameArabic,
    required String ayahSnippet,
    String? note,
  }) {
    return _userDataService.addBookmark(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      pageNumber: pageNumber,
      surahNameArabic: surahNameArabic,
      ayahSnippet: ayahSnippet,
      note: note,
    );
  }

  /// Retrieves all user bookmarks.
  Future<Result<List<QuranBookmark>, Failure>> getBookmarks() {
    return _userDataService.getBookmarks();
  }

  /// Deletes a bookmark by ID.
  Future<Result<bool, Failure>> deleteBookmark(String bookmarkId) {
    return _userDataService.deleteBookmark(bookmarkId);
  }
}
