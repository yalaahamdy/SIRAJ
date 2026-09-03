import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/personal_goal.dart';
import '../store/companion_user_data_store.dart';

/// Engine for creating, updating, pausing, and tracking user-defined goals (§14, §15).
class GoalEngine {
  final CompanionUserDataStore _store;

  const GoalEngine({required CompanionUserDataStore store}) : _store = store;

  Future<Result<List<PersonalGoal>, Failure>> getActiveGoals() async {
    final res = await _store.getGoals();
    if (res.isFailure) return Result.err(res.failureOrNull!);
    final goals = res.valueOrNull!.where((g) => g.status == GoalStatus.active).toList();
    return Result.ok(goals);
  }

  Future<Result<PersonalGoal, Failure>> addGoal(PersonalGoal goal) async {
    final res = await _store.getGoals();
    if (res.isFailure) return Result.err(res.failureOrNull!);
    final list = List<PersonalGoal>.from(res.valueOrNull!);

    // Check duplicate ID
    if (list.any((g) => g.goalId == goal.goalId)) {
      return Result.err(const ConfigFailure(message: 'Goal ID already exists'));
    }

    list.add(goal);
    final saveRes = await _store.saveGoals(list);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(goal);
  }

  Future<Result<PersonalGoal, Failure>> updateProgress(String goalId, double increment) async {
    final res = await _store.getGoals();
    if (res.isFailure) return Result.err(res.failureOrNull!);
    final list = List<PersonalGoal>.from(res.valueOrNull!);

    final idx = list.indexWhere((g) => g.goalId == goalId);
    if (idx == -1) {
      return Result.err(ContentNotFoundFailure(message: 'Goal not found: $goalId'));
    }

    final current = list[idx];
    final newProgress = (current.currentProgress + increment).clamp(0.0, current.target * 2);
    final isCompleted = newProgress >= current.target;

    final updated = current.copyWith(
      currentProgress: newProgress,
      status: isCompleted ? GoalStatus.completed : current.status,
    );

    list[idx] = updated;
    final saveRes = await _store.saveGoals(list);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(updated);
  }

  Future<Result<PersonalGoal, Failure>> setGoalStatus(String goalId, GoalStatus newStatus) async {
    final res = await _store.getGoals();
    if (res.isFailure) return Result.err(res.failureOrNull!);
    final list = List<PersonalGoal>.from(res.valueOrNull!);

    final idx = list.indexWhere((g) => g.goalId == goalId);
    if (idx == -1) {
      return Result.err(ContentNotFoundFailure(message: 'Goal not found: $goalId'));
    }

    final updated = list[idx].copyWith(status: newStatus);
    list[idx] = updated;
    final saveRes = await _store.saveGoals(list);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(updated);
  }

  Future<Result<void, Failure>> deleteGoal(String goalId) async {
    final res = await _store.getGoals();
    if (res.isFailure) return Result.err(res.failureOrNull!);
    final list = List<PersonalGoal>.from(res.valueOrNull!);

    list.removeWhere((g) => g.goalId == goalId);
    return _store.saveGoals(list);
  }
}
