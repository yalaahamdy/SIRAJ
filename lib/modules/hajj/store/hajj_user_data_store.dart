import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/hajj_user_progress.dart';
import '../domain/journey_type.dart';

/// Local-First User Data Store isolated in `mod_hajj` namespace (§37, §38).
class HajjUserDataStore {
  static const String namespace = 'mod_hajj';
  static const String _keyProgress = 'hajj_user_progress';

  final StorageRegistry _registry;

  const HajjUserDataStore({required StorageRegistry registry}) : _registry = registry;

  Future<Result<HajjUserProgress, Failure>> getProgress() async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final res = await store.getString(_keyProgress);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(const HajjUserProgress());
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(HajjUserProgress.fromJson(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to load hajj user progress: $e'));
    }
  }

  Future<Result<void, Failure>> saveProgress(HajjUserProgress progress) async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final raw = jsonEncode(progress.toJson());
      final res = await store.setString(_keyProgress, raw);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save hajj user progress: $e'));
    }
  }

  Future<Result<void, Failure>> setJourneyType(JourneyType type) async {
    final curRes = await getProgress();
    final cur = curRes.isSuccess ? curRes.valueOrNull! : const HajjUserProgress();
    return saveProgress(cur.copyWith(
      activeJourneyType: type,
      completedStepIds: const {},
      journeyState: JourneyState.preparing,
      startedAt: DateTime.now(),
    ));
  }

  Future<Result<void, Failure>> setJourneyState(JourneyState state) async {
    final curRes = await getProgress();
    final cur = curRes.isSuccess ? curRes.valueOrNull! : const HajjUserProgress();
    return saveProgress(cur.copyWith(
      journeyState: state,
      completedAt: state == JourneyState.completed ? DateTime.now() : cur.completedAt,
    ));
  }

  Future<Result<void, Failure>> markStepCompleted(String stepId) async {
    final curRes = await getProgress();
    final cur = curRes.isSuccess ? curRes.valueOrNull! : const HajjUserProgress();
    final updated = Set<String>.from(cur.completedStepIds)..add(stepId);
    return saveProgress(cur.copyWith(
      completedStepIds: updated,
      journeyState: JourneyState.inProgress,
    ));
  }

  Future<Result<void, Failure>> togglePreparationItem(String itemId) async {
    final curRes = await getProgress();
    final cur = curRes.isSuccess ? curRes.valueOrNull! : const HajjUserProgress();
    final updated = Set<String>.from(cur.checkedPreparationItemIds);
    if (updated.contains(itemId)) {
      updated.remove(itemId);
    } else {
      updated.add(itemId);
    }
    return saveProgress(cur.copyWith(checkedPreparationItemIds: updated));
  }

  Future<Result<void, Failure>> saveUserNote(String stepId, String note) async {
    final curRes = await getProgress();
    final cur = curRes.isSuccess ? curRes.valueOrNull! : const HajjUserProgress();
    final updated = Map<String, String>.from(cur.userNotes);
    if (note.trim().isEmpty) {
      updated.remove(stepId);
    } else {
      updated[stepId] = note.trim();
    }
    return saveProgress(cur.copyWith(userNotes: updated));
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final res = await store.clear();
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to reset hajj user data: $e'));
    }
  }
}
