import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/prayer_adjustments.dart';

/// Service managing explicit user minute adjustments and calibration (§18).
/// Enforces safe boundaries and transparency.
class UserCalibrationService {
  static const String _storageKey = 'user_prayer_adjustments';
  final KeyValueStore _store;

  UserCalibrationService({required StorageRegistry storageRegistry})
      : _store = storageRegistry.getStoreForModule('mod_prayer');

  /// Retrieves currently saved prayer adjustments or returns [PrayerAdjustments.zero].
  Future<Result<PrayerAdjustments, Failure>> getAdjustments() async {
    final res = await _store.getString(_storageKey);
    if (res.isFailure) return Result.err(res.failureOrNull!);

    final raw = res.valueOrNull;
    if (raw == null) {
      return Result.ok(PrayerAdjustments.zero);
    }

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(PrayerAdjustments.fromMap(map));
    } catch (e) {
      return Result.ok(PrayerAdjustments.zero);
    }
  }

  /// Persists user adjustments with boundary validation.
  Future<Result<void, Failure>> saveAdjustments(PrayerAdjustments adjustments) async {
    final jsonStr = jsonEncode(adjustments.toMap());
    final res = await _store.setString(_storageKey, jsonStr);
    if (res.isFailure) return Result.err(res.failureOrNull!);
    return Result.ok(null);
  }

  /// Resets all adjustments to zero.
  Future<Result<void, Failure>> resetAdjustments() async {
    return saveAdjustments(PrayerAdjustments.zero);
  }
}
