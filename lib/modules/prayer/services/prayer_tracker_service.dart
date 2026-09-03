import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/storage/storage_contract.dart';
import '../../../core/time/clock.dart';
import '../domain/prayer_log_entry.dart';
import '../domain/prayer_tracking_status.dart';
import '../domain/prayer_type.dart';

/// Local-first, private prayer tracker service (§14, §15).
/// Persists records strictly in `mod_prayer` namespace with zero telemetry or cloud leakage.
class PrayerTrackerService {
  final KeyValueStore _store;
  final Clock _clock;
  final EventBus? _eventBus;

  PrayerTrackerService({
    required StorageRegistry storageRegistry,
    Clock? clock,
    EventBus? eventBus,
  })  : _store = storageRegistry.getStoreForModule('mod_prayer'),
        _clock = clock ?? const SystemClock(),
        _eventBus = eventBus;

  /// Records or updates a prayer tracking entry.
  Future<Result<PrayerLogEntry, Failure>> logPrayer({
    required DateTime date,
    required PrayerType prayerType,
    required PrayerTrackingStatus status,
    String? notes,
  }) async {
    final entry = PrayerLogEntry(
      date: DateTime(date.year, date.month, date.day),
      prayerType: prayerType,
      status: status,
      recordedAtUtc: _clock.nowUtc(),
      notes: notes,
    );

    final key = _makeKey(entry.date, prayerType);
    final jsonStr = jsonEncode(entry.toMap());

    final saveResult = await _store.setString(key, jsonStr);
    if (saveResult.isFailure) {
      return Result.err(saveResult.failureOrNull!);
    }

    _eventBus?.publish(
      PrayerLoggedEvent(
        prayerName: prayerType.name,
        date: entry.date,
        status: status.name,
      ),
    );

    return Result.ok(entry);
  }

  /// Retrieves the logged status for a specific prayer on a given date.
  Future<Result<PrayerLogEntry?, Failure>> getLogForPrayer({
    required DateTime date,
    required PrayerType prayerType,
  }) async {
    final key = _makeKey(date, prayerType);
    final getResult = await _store.getString(key);

    if (getResult.isFailure) {
      return Result.err(getResult.failureOrNull!);
    }

    final raw = getResult.valueOrNull;
    if (raw == null) {
      return Result.ok(null);
    }

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return Result.ok(PrayerLogEntry.fromMap(map));
    } catch (e) {
      return Result.err(
        StorageFailure(
          message: 'Corrupted prayer log entry for key $key',
          cause: e,
        ),
      );
    }
  }

  /// Retrieves all logged entries for a full day.
  Future<Result<Map<PrayerType, PrayerLogEntry>, Failure>> getLogsForDate(DateTime date) async {
    final map = <PrayerType, PrayerLogEntry>{};

    for (final type in [
      PrayerType.fajr,
      PrayerType.dhuhr,
      PrayerType.asr,
      PrayerType.maghrib,
      PrayerType.isha,
    ]) {
      final res = await getLogForPrayer(date: date, prayerType: type);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      if (res.valueOrNull != null) {
        map[type] = res.valueOrNull!;
      }
    }

    return Result.ok(map);
  }

  static String _makeKey(DateTime date, PrayerType type) {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return 'tracker_${dateStr}_${type.name}';
  }
}
