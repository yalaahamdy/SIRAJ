import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/seerah_user_progress.dart';

/// Local-First isolated storage for Seerah user reading history and personal notes (§33, §35).
class SeerahUserDataStore {
  final StorageRegistry _storageRegistry;

  static const String _moduleNamespace = 'mod_seerah';
  static const String _keyProgress = 'user_seerah_progress';

  const SeerahUserDataStore({required StorageRegistry storageRegistry})
      : _storageRegistry = storageRegistry;

  Future<Result<SeerahUserProgress, Failure>> getProgress() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyProgress);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(SeerahUserProgress(updatedAt: DateTime.now().toUtc()));
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(SeerahUserProgress.fromMap(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to decode seerah user progress: $e'));
    }
  }

  Future<Result<void, Failure>> saveProgress(SeerahUserProgress progress) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final raw = jsonEncode(progress.toMap());
      return store.setString(_keyProgress, raw);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save seerah user progress: $e'));
    }
  }

  Future<Result<void, Failure>> markEventViewed(String eventId) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedViewed = Set<String>.from(cur.viewedEventIds)..add(eventId);

    final updated = cur.copyWith(
      viewedEventIds: updatedViewed,
      lastViewedEventId: eventId,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> toggleBookmark(String eventId) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedBookmarks = Set<String>.from(cur.bookmarkedEventIds);
    if (updatedBookmarks.contains(eventId)) {
      updatedBookmarks.remove(eventId);
    } else {
      updatedBookmarks.add(eventId);
    }

    final updated = cur.copyWith(
      bookmarkedEventIds: updatedBookmarks,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> saveUserNote(String eventId, String note) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedNotes = Map<String, String>.from(cur.userNotes);
    if (note.trim().isEmpty) {
      updatedNotes.remove(eventId);
    } else {
      updatedNotes[eventId] = note.trim();
    }

    final updated = cur.copyWith(
      userNotes: updatedNotes,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.clear();
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to reset seerah user data: $e'));
    }
  }
}
