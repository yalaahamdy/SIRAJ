import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/knowledge_user_progress.dart';

/// Local-First isolated storage for user study progress, bookmarks, and private notes (§33, §36).
class KnowledgeUserDataStore {
  final StorageRegistry _storageRegistry;

  static const String _moduleNamespace = 'mod_knowledge';
  static const String _keyProgress = 'user_knowledge_progress';

  const KnowledgeUserDataStore({required StorageRegistry storageRegistry})
      : _storageRegistry = storageRegistry;

  Future<Result<KnowledgeUserProgress, Failure>> getProgress() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyProgress);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(KnowledgeUserProgress(updatedAt: DateTime.now().toUtc()));
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(KnowledgeUserProgress.fromMap(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to decode knowledge progress: $e'));
    }
  }

  Future<Result<void, Failure>> saveProgress(KnowledgeUserProgress progress) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final raw = jsonEncode(progress.toMap());
      return store.setString(_keyProgress, raw);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save knowledge progress: $e'));
    }
  }

  Future<Result<void, Failure>> markItemCompleted(String itemId) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedCompleted = Set<String>.from(cur.completedItemIds)..add(itemId);
    final updated = cur.copyWith(
      completedItemIds: updatedCompleted,
      lastReadItemId: itemId,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> toggleBookmark(String itemId) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedBookmarks = Set<String>.from(cur.bookmarkedItemIds);
    if (updatedBookmarks.contains(itemId)) {
      updatedBookmarks.remove(itemId);
    } else {
      updatedBookmarks.add(itemId);
    }

    final updated = cur.copyWith(
      bookmarkedItemIds: updatedBookmarks,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> saveUserNote(String itemId, String note) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedNotes = Map<String, String>.from(cur.userNotes);
    if (note.trim().isEmpty) {
      updatedNotes.remove(itemId);
    } else {
      updatedNotes[itemId] = note.trim();
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
      return Result.err(StorageFailure(message: 'Failed to reset knowledge user data: $e'));
    }
  }
}
