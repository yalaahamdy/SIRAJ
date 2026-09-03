import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/fasting_day_record.dart';
import '../domain/fasting_record_snapshot.dart';
import '../domain/qada_plan.dart';

/// Local-First isolated storage repository for user's fasting data inside `mod_fasting` (§21, §22).
class FastingUserDataStore {
  final StorageRegistry _storageRegistry;

  static const String _moduleNamespace = 'mod_fasting';
  static const String _keyRecords = 'fasting_records';
  static const String _keyQadaPlan = 'qada_plan';
  static const String _keyPolicyId = 'selected_fasting_policy_id';
  static const String _keyCalendarOffset = 'calendar_offset_days';
  static const String _keySnapshots = 'fasting_snapshots';

  const FastingUserDataStore({required StorageRegistry storageRegistry})
      : _storageRegistry = storageRegistry;

  Future<Result<List<FastingDayRecord>, Failure>> getDayRecords() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyRecords);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) return Result.ok(const []);

      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => FastingDayRecord.fromMap(e as Map<String, dynamic>))
          .toList();
      return Result.ok(list);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to decode fasting records: $e'));
    }
  }

  Future<Result<void, Failure>> saveDayRecord(FastingDayRecord record) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final listRes = await getDayRecords();
      if (listRes.isFailure) return Result.err(listRes.failureOrNull!);

      final list = List<FastingDayRecord>.from(listRes.valueOrNull!);
      final dateKey = record.date.toIso8601String().substring(0, 10);
      list.removeWhere((r) => r.date.toIso8601String().substring(0, 10) == dateKey);
      list.add(record);

      final raw = jsonEncode(list.map((r) => r.toMap()).toList());
      return store.setString(_keyRecords, raw);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save fasting record: $e'));
    }
  }

  Future<Result<void, Failure>> deleteDayRecord(String recordId) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final listRes = await getDayRecords();
      if (listRes.isFailure) return Result.err(listRes.failureOrNull!);

      final list = List<FastingDayRecord>.from(listRes.valueOrNull!);
      list.removeWhere((r) => r.recordId == recordId);

      final raw = jsonEncode(list.map((r) => r.toMap()).toList());
      return store.setString(_keyRecords, raw);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to delete fasting record: $e'));
    }
  }

  Future<Result<FastingDayRecord?, Failure>> getDayRecordByDate(DateTime date) async {
    try {
      final listRes = await getDayRecords();
      if (listRes.isFailure) return Result.err(listRes.failureOrNull!);

      final dateKey = date.toIso8601String().substring(0, 10);
      final match = listRes.valueOrNull!.where(
        (r) => r.date.toIso8601String().substring(0, 10) == dateKey,
      );
      return Result.ok(match.isEmpty ? null : match.first);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to find fasting record: $e'));
    }
  }

  Future<Result<QadaPlan, Failure>> getQadaPlan() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyQadaPlan);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) {
        return Result.ok(QadaPlan(totalDays: 0, completedDays: 0, updatedAt: DateTime.now().toUtc()));
      }

      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(QadaPlan.fromMap(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to decode Qada plan: $e'));
    }
  }

  Future<Result<void, Failure>> saveQadaPlan(QadaPlan plan) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final raw = jsonEncode(plan.toMap());
      return store.setString(_keyQadaPlan, raw);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save Qada plan: $e'));
    }
  }

  Future<Result<String?, Failure>> getSelectedPolicyId() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      return store.getString(_keyPolicyId);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to get selected policy: $e'));
    }
  }

  Future<Result<void, Failure>> setSelectedPolicyId(String policyId) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      return store.setString(_keyPolicyId, policyId);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to set selected policy: $e'));
    }
  }

  Future<Result<int, Failure>> getCalendarOffsetDays() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getInt(_keyCalendarOffset);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(res.valueOrNull ?? 0);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to get calendar offset: $e'));
    }
  }

  Future<Result<void, Failure>> setCalendarOffsetDays(int offset) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      return store.setInt(_keyCalendarOffset, offset);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to set calendar offset: $e'));
    }
  }

  Future<Result<List<FastingRecordSnapshot>, Failure>> getSnapshots() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keySnapshots);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      final raw = res.valueOrNull;
      if (raw == null || raw.isEmpty) return Result.ok(const []);

      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => FastingRecordSnapshot.fromMap(e as Map<String, dynamic>))
          .toList();
      return Result.ok(list);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to decode snapshots: $e'));
    }
  }

  Future<Result<void, Failure>> saveSnapshot(FastingRecordSnapshot snapshot) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final listRes = await getSnapshots();
      if (listRes.isFailure) return Result.err(listRes.failureOrNull!);

      final list = List<FastingRecordSnapshot>.from(listRes.valueOrNull!);
      list.add(snapshot);

      final raw = jsonEncode(list.map((s) => s.toMap()).toList());
      return store.setString(_keySnapshots, raw);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save snapshot: $e'));
    }
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.clear();
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to reset fasting data: $e'));
    }
  }
}
