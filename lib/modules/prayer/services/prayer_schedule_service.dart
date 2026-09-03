import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/location/location_models.dart';
import '../../../core/time/clock.dart';
import '../domain/calculation_parameters.dart';
import '../domain/prayer_adjustments.dart';
import '../domain/prayer_schedule.dart';
import '../domain/prayer_time_entry.dart';
import '../domain/prayer_type.dart';
import '../engine/astronomical_calculator.dart';
import '../engine/prayer_calculation_engine.dart';

/// Service managing daily prayer schedules, next/current prayer resolution, and day boundaries (§11, §12).
class PrayerScheduleService {
  final PrayerCalculationEngine _engine;
  final Clock _clock;
  final EventBus? _eventBus;

  PrayerScheduleService({
    PrayerCalculationEngine? engine,
    Clock? clock,
    EventBus? eventBus,
  })  : _engine = engine ?? const AstronomicalPrayerCalculator(),
        _clock = clock ?? const SystemClock(),
        _eventBus = eventBus;

  /// Generates the daily prayer schedule for a given date and location.
  Result<PrayerSchedule, Failure> getSchedule({
    required DateTime date,
    required GeoCoordinates location,
    required CalculationParameters parameters,
    Duration? timezoneOffset,
    PrayerAdjustments adjustments = PrayerAdjustments.zero,
  }) {
    final result = _engine.calculateSchedule(
      date: date,
      location: location,
      parameters: parameters,
      timezoneOffset: timezoneOffset,
      adjustments: adjustments,
    );

    if (result.isSuccess) {
      _eventBus?.publish(
        PrayerTimeUpdatedEvent(
          date: date,
          calculationMethod: parameters.methodProfileName,
        ),
      );
    }

    return result;
  }

  /// Determines the next upcoming prayer or solar transition (§12).
  /// Accurately handles before Fajr, between prayers, after Isha, and day rollover into tomorrow's Fajr.
  PrayerTimeEntry? getNextPrayer({
    DateTime? currentTime,
    required PrayerSchedule todaySchedule,
    PrayerSchedule? tomorrowSchedule,
  }) {
    final now = currentTime ?? _clock.nowLocal();

    // Check all today's transitions chronologically
    final transitions = todaySchedule.dailyScheduleList;
    for (final entry in transitions) {
      if (entry.time.isAfter(now)) {
        return entry;
      }
    }

    // If all today's transitions have passed (e.g. after Isha), next is tomorrow's Fajr
    if (tomorrowSchedule != null) {
      return tomorrowSchedule.fajr;
    }

    // Fallback: calculate tomorrow's schedule directly via engine for exact seasonal/DST accuracy
    final tomorrowDate = todaySchedule.date.isUtc
        ? DateTime.utc(
            todaySchedule.date.year,
            todaySchedule.date.month,
            todaySchedule.date.day + 1,
          )
        : DateTime(
            todaySchedule.date.year,
            todaySchedule.date.month,
            todaySchedule.date.day + 1,
          );
    final calculatedTomorrow = _engine.calculateSchedule(
      date: tomorrowDate,
      location: todaySchedule.location,
      parameters: CalculationParameters(
        methodProfileName: todaySchedule.disclosure.methodName,
        fajrAngle: todaySchedule.disclosure.fajrAngle,
        ishaAngle: todaySchedule.disclosure.ishaAngle,
        ishaIntervalMinutes: todaySchedule.disclosure.ishaIntervalMinutes,
        asrJuristicMethod: todaySchedule.disclosure.asrMethod,
        highLatitudeRule: todaySchedule.disclosure.highLatitudeRule,
        sourceReference: todaySchedule.disclosure.sourceReference,
      ),
      timezoneOffset: todaySchedule.disclosure.timezoneOffset,
      adjustments: todaySchedule.disclosure.adjustments,
    );

    if (calculatedTomorrow.isSuccess && calculatedTomorrow.valueOrNull?.fajr != null) {
      return calculatedTomorrow.valueOrNull!.fajr;
    }

    if (todaySchedule.fajr != null) {
      final f = todaySchedule.fajr!;
      return PrayerTimeEntry(
        type: PrayerType.fajr,
        time: f.time.add(const Duration(days: 1)),
        originalTime: f.originalTime.add(const Duration(days: 1)),
        adjustmentMinutes: f.adjustmentMinutes,
      );
    }

    return null;
  }

  /// Determines the currently active prayer period.
  PrayerTimeEntry? getCurrentPrayer({
    DateTime? currentTime,
    required PrayerSchedule todaySchedule,
    PrayerSchedule? yesterdaySchedule,
  }) {
    final now = currentTime ?? _clock.nowLocal();
    final transitions = todaySchedule.dailyScheduleList;

    // If before today's Fajr, current prayer is yesterday's Isha
    if (transitions.isNotEmpty && now.isBefore(transitions.first.time)) {
      if (yesterdaySchedule != null && yesterdaySchedule.isha != null) {
        return yesterdaySchedule.isha;
      }
      if (todaySchedule.isha != null) {
        final i = todaySchedule.isha!;
        return PrayerTimeEntry(
          type: PrayerType.isha,
          time: i.time.subtract(const Duration(days: 1)),
          originalTime: i.originalTime.subtract(const Duration(days: 1)),
          adjustmentMinutes: i.adjustmentMinutes,
        );
      }
    }

    // Find the latest transition that has already started
    PrayerTimeEntry? current;
    for (final entry in transitions) {
      if (entry.time.isBefore(now) || entry.time.isAtSameMomentAs(now)) {
        current = entry;
      } else {
        break;
      }
    }

    return current;
  }

  /// Calculates remaining duration until the next prayer.
  Duration getRemainingTimeToNextPrayer({
    DateTime? currentTime,
    required PrayerSchedule todaySchedule,
    PrayerSchedule? tomorrowSchedule,
  }) {
    final now = currentTime ?? _clock.nowLocal();
    final next = getNextPrayer(
      currentTime: now,
      todaySchedule: todaySchedule,
      tomorrowSchedule: tomorrowSchedule,
    );

    if (next == null) return Duration.zero;
    final diff = next.time.difference(now);
    return diff.isNegative ? Duration.zero : diff;
  }
}
