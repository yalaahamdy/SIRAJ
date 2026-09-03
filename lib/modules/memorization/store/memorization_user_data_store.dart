import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../../../core/time/clock.dart';
import '../domain/memorization_item.dart';
import '../domain/memorization_plan.dart';
import '../domain/review_result.dart';
import '../domain/review_session.dart';

/// Local-First persistence engine for user memorization data strictly in `mod_memorization` (§26, §27).
class MemorizationUserDataStore {
  final KeyValueStore _store;
  final Clock _clock;

  static const int currentSchemaVersion = 1;

  static const String _keySchemaVersion = 'schema_version';
  static const String _keyPlan = 'memorization_plan';
  static const String _keyItems = 'memorization_items';
  static const String _keyHistory = 'review_history';
  static const String _keyActiveSession = 'active_session';
  static const String _keyLastCompletedDate = 'last_completed_session_date';
  static const String _keyStreakCount = 'consistency_streak_count';

  MemorizationUserDataStore({
    required StorageRegistry storageRegistry,
    Clock? clock,
  })  : _store = storageRegistry.getStoreForModule('mod_memorization'),
        _clock = clock ?? const SystemClock();

  /// Initializes storage and executes schema migrations if necessary.
  Future<Result<bool, Failure>> initialize() async {
    final verRes = await _store.getInt(_keySchemaVersion);
    if (verRes.isFailure) return Result.err(verRes.failureOrNull!);

    final existingVersion = verRes.valueOrNull ?? 0;
    if (existingVersion == 0) {
      await _store.setInt(_keySchemaVersion, currentSchemaVersion);
    } else if (existingVersion < currentSchemaVersion) {
      // Future schema migration logic can be hooked here
      await _store.setInt(_keySchemaVersion, currentSchemaVersion);
    }

    return Result.ok(true);
  }

  /// Saves or updates the memorization plan.
  Future<Result<bool, Failure>> savePlan(MemorizationPlan plan) async {
    final jsonStr = jsonEncode(plan.toMap());
    final res = await _store.setString(_keyPlan, jsonStr);
    if (res.isFailure) return Result.err(res.failureOrNull!);
    return Result.ok(true);
  }

  /// Retrieves the active memorization plan, or null if none created.
  Future<Result<MemorizationPlan?, Failure>> getPlan() async {
    final res = await _store.getString(_keyPlan);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final raw = res.valueOrNull;
    if (raw == null) return Result.ok(null);

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(MemorizationPlan.fromMap(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Corrupted memorization plan', cause: e));
    }
  }

  /// Saves or replaces all memorization items.
  Future<Result<bool, Failure>> saveItems(List<MemorizationItem> items) async {
    final listMaps = items.map((i) => i.toMap()).toList();
    final jsonStr = jsonEncode(listMaps);
    final res = await _store.setString(_keyItems, jsonStr);
    if (res.isFailure) return Result.err(res.failureOrNull!);
    return Result.ok(true);
  }

  /// Retrieves all memorization items.
  Future<Result<List<MemorizationItem>, Failure>> getItems() async {
    final res = await _store.getString(_keyItems);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final raw = res.valueOrNull;
    if (raw == null) return Result.ok(const []);

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final items = list.map((e) => MemorizationItem.fromMap(e as Map<String, dynamic>)).toList();
      return Result.ok(List.unmodifiable(items));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Corrupted memorization items', cause: e));
    }
  }

  /// Appends review results to the historical ledger.
  Future<Result<bool, Failure>> appendReviewResults(List<ReviewResult> newResults) async {
    final existingRes = await getReviewHistory();
    if (existingRes.isFailure) return Result.err(existingRes.failureOrNull!);

    final list = List<ReviewResult>.from(existingRes.valueOrNull ?? []);
    list.addAll(newResults);

    final jsonStr = jsonEncode(list.map((r) => r.toMap()).toList());
    final res = await _store.setString(_keyHistory, jsonStr);
    if (res.isFailure) return Result.err(res.failureOrNull!);
    return Result.ok(true);
  }

  /// Retrieves the historical ledger of all reviews.
  Future<Result<List<ReviewResult>, Failure>> getReviewHistory() async {
    final res = await _store.getString(_keyHistory);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final raw = res.valueOrNull;
    if (raw == null) return Result.ok(const []);

    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final history = list.map((e) => ReviewResult.fromMap(e as Map<String, dynamic>)).toList();
      return Result.ok(List.unmodifiable(history));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Corrupted review history', cause: e));
    }
  }

  /// Saves the active/paused session.
  Future<Result<bool, Failure>> saveActiveSession(ReviewSession? session) async {
    if (session == null) {
      final res = await _store.remove(_keyActiveSession);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(true);
    }
    final jsonStr = jsonEncode(session.toMap());
    final res = await _store.setString(_keyActiveSession, jsonStr);
    if (res.isFailure) return Result.err(res.failureOrNull!);
    return Result.ok(true);
  }

  /// Retrieves the active/paused session, if any.
  Future<Result<ReviewSession?, Failure>> getActiveSession() async {
    final res = await _store.getString(_keyActiveSession);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final raw = res.valueOrNull;
    if (raw == null) return Result.ok(null);

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(ReviewSession.fromMap(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Corrupted active session', cause: e));
    }
  }

  /// Records session completion and updates consistency streak.
  Future<Result<int, Failure>> recordSessionCompleted() async {
    final now = _clock.nowUtc();
    final todayMidnight = DateTime.utc(now.year, now.month, now.day);

    final lastDateRes = await _store.getString(_keyLastCompletedDate);
    final streakRes = await _store.getInt(_keyStreakCount);

    var currentStreak = streakRes.valueOrNull ?? 0;
    final lastDateStr = lastDateRes.valueOrNull;

    if (lastDateStr == null) {
      currentStreak = 1;
    } else {
      final lastDate = DateTime.parse(lastDateStr);
      final lastMidnight = DateTime.utc(lastDate.year, lastDate.month, lastDate.day);
      final diffDays = todayMidnight.difference(lastMidnight).inDays;

      if (diffDays == 1) {
        currentStreak += 1;
      } else if (diffDays > 1) {
        currentStreak = 1; // Reset streak gracefully without guilt mechanics
      }
    }

    await _store.setString(_keyLastCompletedDate, todayMidnight.toIso8601String());
    await _store.setInt(_keyStreakCount, currentStreak);

    return Result.ok(currentStreak);
  }

  /// Retrieves the current consistency streak.
  Future<Result<int, Failure>> getConsistencyStreak() async {
    final res = await _store.getInt(_keyStreakCount);
    if (res.isFailure) return Result.err(res.failureOrNull!);
    return Result.ok(res.valueOrNull ?? 0);
  }

  /// Executes a safe reset of all user memorization data (§27).
  Future<Result<bool, Failure>> resetAllData() async {
    final r1 = await _store.remove(_keyItems);
    final r2 = await _store.remove(_keyHistory);
    final r3 = await _store.remove(_keyActiveSession);
    final r4 = await _store.remove(_keyLastCompletedDate);
    final r5 = await _store.remove(_keyStreakCount);

    if (r1.isFailure || r2.isFailure || r3.isFailure || r4.isFailure || r5.isFailure) {
      return Result.err(const StorageFailure(message: 'Failed to reset all memorization data'));
    }
    return Result.ok(true);
  }
}
