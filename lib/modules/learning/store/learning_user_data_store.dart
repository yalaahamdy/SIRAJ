import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/assessment_result.dart';
import '../domain/learning_goal.dart';
import '../domain/learning_progress.dart';
import '../domain/revision_item.dart';

/// Local-First isolated storage for learning progress, quiz attempts, and user notes (§31, §32).
class LearningUserDataStore {
  final StorageRegistry _storageRegistry;

  static const String _moduleNamespace = 'mod_learning';
  static const String _keyProgress = 'user_learning_progress';

  const LearningUserDataStore({required StorageRegistry storageRegistry})
      : _storageRegistry = storageRegistry;

  Future<Result<LearningProgress, Failure>> getProgress() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyProgress);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(LearningProgress(updatedAt: DateTime.now().toUtc()));
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(LearningProgress.fromMap(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to decode learning progress: $e'));
    }
  }

  Future<Result<void, Failure>> saveProgress(LearningProgress progress) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final raw = jsonEncode(progress.toMap());
      return store.setString(_keyProgress, raw);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save learning progress: $e'));
    }
  }

  Future<Result<void, Failure>> markLessonCompleted(String lessonId, int version) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedCompleted = Map<String, int>.from(cur.completedLessonVersions);
    updatedCompleted[lessonId] = version;

    final updated = cur.copyWith(
      completedLessonVersions: updatedCompleted,
      lastStudiedLessonId: lessonId,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> recordAssessmentResult(AssessmentResult result) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedAssessments = List<AssessmentResult>.from(cur.assessmentResults)..add(result);

    final updated = cur.copyWith(
      assessmentResults: updatedAssessments,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> addOrUpdateRevisionItem(RevisionItem item) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedQueue = List<RevisionItem>.from(cur.revisionQueue);
    final existingIdx = updatedQueue.indexWhere((r) => r.itemId == item.itemId);
    if (existingIdx >= 0) {
      updatedQueue[existingIdx] = item;
    } else {
      updatedQueue.add(item);
    }

    final updated = cur.copyWith(
      revisionQueue: updatedQueue,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> toggleBookmark(String lessonId) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedBookmarks = Set<String>.from(cur.bookmarkedLessonIds);
    if (updatedBookmarks.contains(lessonId)) {
      updatedBookmarks.remove(lessonId);
    } else {
      updatedBookmarks.add(lessonId);
    }

    final updated = cur.copyWith(
      bookmarkedLessonIds: updatedBookmarks,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> saveUserNote(String lessonId, String note) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updatedNotes = Map<String, String>.from(cur.userNotes);
    if (note.trim().isEmpty) {
      updatedNotes.remove(lessonId);
    } else {
      updatedNotes[lessonId] = note.trim();
    }

    final updated = cur.copyWith(
      userNotes: updatedNotes,
      updatedAt: DateTime.now().toUtc(),
    );
    return saveProgress(updated);
  }

  Future<Result<void, Failure>> saveGoal(LearningGoal goal) async {
    final curRes = await getProgress();
    if (curRes.isFailure) return Result.err(curRes.failureOrNull!);

    final cur = curRes.valueOrNull!;
    final updated = cur.copyWith(
      learningGoal: goal,
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
      return Result.err(StorageFailure(message: 'Failed to reset learning user data: $e'));
    }
  }
}
