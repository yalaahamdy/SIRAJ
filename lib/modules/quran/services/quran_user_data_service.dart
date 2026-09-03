import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../../../core/time/clock.dart';
import '../domain/quran_bookmark.dart';
import '../domain/quran_reading_progress.dart';

/// Local-First service managing user-specific Quran data (Bookmarks & Reading Progress) (§14, §27).
/// Persists data strictly in `mod_quran` namespace with zero cloud leakage.
class QuranUserDataService {
  final KeyValueStore _store;
  final Clock _clock;

  KeyValueStore get store => _store;

  QuranUserDataService({
    required StorageRegistry storageRegistry,
    Clock? clock,
  })  : _store = storageRegistry.getStoreForModule('mod_quran'),
        _clock = clock ?? const SystemClock();

  static const String _progressKey = 'user_reading_progress';
  static const String _bookmarksListKey = 'user_bookmarks_list';

  /// Saves or updates reading progress and last read position.
  Future<Result<QuranReadingProgress, Failure>> updateProgress({
    required int surahNumber,
    required int ayahNumber,
    required int pageNumber,
    required String surahNameArabic,
  }) async {
    final progress = QuranReadingProgress(
      lastReadSurah: surahNumber,
      lastReadAyah: ayahNumber,
      lastReadPage: pageNumber,
      surahNameArabic: surahNameArabic,
      updatedAtUtc: _clock.nowUtc(),
    );

    final jsonStr = jsonEncode(progress.toMap());
    final saveRes = await _store.setString(_progressKey, jsonStr);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);

    return Result.ok(progress);
  }

  /// Retrieves user reading progress. Returns default starting at Al-Fatihah if none saved.
  Future<Result<QuranReadingProgress, Failure>> getProgress() async {
    final getRes = await _store.getString(_progressKey);
    if (getRes.isFailure) return Result.err(getRes.failureOrNull!);

    final raw = getRes.valueOrNull;
    if (raw == null) {
      return Result.ok(
        QuranReadingProgress(
          lastReadSurah: 1,
          lastReadAyah: 1,
          lastReadPage: 1,
          surahNameArabic: 'الفاتحة',
          updatedAtUtc: _clock.nowUtc(),
        ),
      );
    }

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(QuranReadingProgress.fromMap(map));
    } catch (e) {
      return Result.err(
        StorageFailure(
          message: 'Corrupted Quran reading progress data',
          cause: e,
        ),
      );
    }
  }

  /// Adds a new bookmark for a specific Ayah.
  Future<Result<QuranBookmark, Failure>> addBookmark({
    required int surahNumber,
    required int ayahNumber,
    required int pageNumber,
    required String surahNameArabic,
    required String ayahSnippet,
    String? note,
  }) async {
    final now = _clock.nowUtc();
    final bookmark = QuranBookmark(
      id: 'bm_${surahNumber}_${ayahNumber}_${now.millisecondsSinceEpoch}',
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      pageNumber: pageNumber,
      surahNameArabic: surahNameArabic,
      ayahSnippet: ayahSnippet,
      note: note,
      createdAtUtc: now,
    );

    final currentBookmarksRes = await getBookmarks();
    final currentList = List<QuranBookmark>.from(currentBookmarksRes.valueOrNull ?? []);

    // Prevent duplicate bookmarks for the exact same Ayah
    currentList.removeWhere((b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber);
    currentList.insert(0, bookmark);

    final jsonStr = jsonEncode(currentList.map((b) => b.toMap()).toList());
    final saveRes = await _store.setString(_bookmarksListKey, jsonStr);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);

    return Result.ok(bookmark);
  }

  /// Retrieves all saved bookmarks ordered by creation date descending.
  Future<Result<List<QuranBookmark>, Failure>> getBookmarks() async {
    final getRes = await _store.getString(_bookmarksListKey);
    if (getRes.isFailure) return Result.err(getRes.failureOrNull!);

    final raw = getRes.valueOrNull;
    if (raw == null) return Result.ok(const []);

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final bookmarks = list.map((e) => QuranBookmark.fromMap(e as Map<String, dynamic>)).toList();
      return Result.ok(List.unmodifiable(bookmarks));
    } catch (e) {
      return Result.err(
        StorageFailure(
          message: 'Corrupted Quran bookmarks data',
          cause: e,
        ),
      );
    }
  }

  /// Deletes a bookmark by ID.
  Future<Result<bool, Failure>> deleteBookmark(String bookmarkId) async {
    final currentBookmarksRes = await getBookmarks();
    if (currentBookmarksRes.isFailure) return Result.err(currentBookmarksRes.failureOrNull!);

    final currentList = List<QuranBookmark>.from(currentBookmarksRes.valueOrNull!);
    currentList.removeWhere((b) => b.id == bookmarkId);

    final jsonStr = jsonEncode(currentList.map((b) => b.toMap()).toList());
    final saveRes = await _store.setString(_bookmarksListKey, jsonStr);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);

    return Result.ok(true);
  }
}
