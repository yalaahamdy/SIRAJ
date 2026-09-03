import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/companion_preferences.dart';
import '../domain/personal_goal.dart';
import '../domain/personal_habit.dart';

/// Local-First User Data Store isolated strictly in `mod_companion` namespace (§24, §25).
class CompanionUserDataStore {
  static const String namespace = 'mod_companion';
  static const String _keyPreferences = 'companion_preferences';
  static const String _keyGoals = 'companion_goals';
  static const String _keyHabits = 'companion_habits';

  final StorageRegistry _registry;

  const CompanionUserDataStore({required StorageRegistry registry})
      : _registry = registry;

  Future<Result<CompanionPreferences, Failure>> getPreferences() async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final res = await store.getString(_keyPreferences);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(const CompanionPreferences());
      }
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(CompanionPreferences.fromJson(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to load companion preferences: $e'));
    }
  }

  Future<Result<void, Failure>> savePreferences(CompanionPreferences prefs) async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final raw = jsonEncode(prefs.toJson());
      final res = await store.setString(_keyPreferences, raw);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save companion preferences: $e'));
    }
  }

  Future<Result<List<PersonalGoal>, Failure>> getGoals() async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final res = await store.getString(_keyGoals);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(const []);
      }
      final list = jsonDecode(raw) as List<dynamic>;
      final goals = list.map((e) => PersonalGoal.fromJson(e as Map<String, dynamic>)).toList();
      return Result.ok(goals);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to load companion goals: $e'));
    }
  }

  Future<Result<void, Failure>> saveGoals(List<PersonalGoal> goals) async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final raw = jsonEncode(goals.map((g) => g.toJson()).toList());
      final res = await store.setString(_keyGoals, raw);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save companion goals: $e'));
    }
  }

  Future<Result<List<PersonalHabit>, Failure>> getHabits() async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final res = await store.getString(_keyHabits);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(const []);
      }
      final list = jsonDecode(raw) as List<dynamic>;
      final habits = list.map((e) => PersonalHabit.fromJson(e as Map<String, dynamic>)).toList();
      return Result.ok(habits);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to load companion habits: $e'));
    }
  }

  Future<Result<void, Failure>> saveHabits(List<PersonalHabit> habits) async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final raw = jsonEncode(habits.map((h) => h.toJson()).toList());
      final res = await store.setString(_keyHabits, raw);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save companion habits: $e'));
    }
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    try {
      final store = _registry.getStoreForModule(namespace);
      final res = await store.clear();
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to clear companion storage: $e'));
    }
  }
}
