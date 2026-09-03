import '../../../core/time/clock.dart';
import '../domain/prayer_schedule.dart';
import '../domain/prayer_time_entry.dart';
import 'prayer_schedule_service.dart';

/// State snapshot of the prayer countdown.
class CountdownState {
  final PrayerTimeEntry? nextPrayer;
  final PrayerTimeEntry? currentPrayer;
  final Duration remainingDuration;
  final bool isExactPrayerMoment;

  const CountdownState({
    required this.nextPrayer,
    required this.currentPrayer,
    required this.remainingDuration,
    this.isExactPrayerMoment = false,
  });

  int get hours => remainingDuration.inHours;
  int get minutes => remainingDuration.inMinutes % 60;
  int get seconds => remainingDuration.inSeconds % 60;

  /// Formatted representation: "HH:MM:SS"
  String get formattedTimer =>
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

  /// Localized Arabic representation: "ساعات ودقائق وثواني"
  String get formattedArabic {
    if (hours > 0) {
      return '$hours س و $minutes د و $seconds ث';
    } else if (minutes > 0) {
      return '$minutes د و $seconds ث';
    } else {
      return '$seconds ثانية';
    }
  }
}

/// Service providing deterministic calculation and formatting for prayer countdowns (§13).
class PrayerCountdownService {
  final PrayerScheduleService _scheduleService;
  final Clock _clock;

  PrayerCountdownService({
    required PrayerScheduleService scheduleService,
    Clock? clock,
  })  : _scheduleService = scheduleService,
        _clock = clock ?? const SystemClock();

  /// Calculates the immediate countdown state for the current moment or specific [time].
  CountdownState getCountdownState({
    DateTime? time,
    required PrayerSchedule todaySchedule,
    PrayerSchedule? tomorrowSchedule,
  }) {
    final now = time ?? _clock.nowLocal();

    final next = _scheduleService.getNextPrayer(
      currentTime: now,
      todaySchedule: todaySchedule,
      tomorrowSchedule: tomorrowSchedule,
    );

    final current = _scheduleService.getCurrentPrayer(
      currentTime: now,
      todaySchedule: todaySchedule,
    );

    if (next == null) {
      return CountdownState(
        nextPrayer: null,
        currentPrayer: current,
        remainingDuration: Duration.zero,
      );
    }

    final diff = next.time.difference(now);
    final remaining = diff.isNegative ? Duration.zero : diff;
    final isExact = remaining.inSeconds == 0;

    return CountdownState(
      nextPrayer: next,
      currentPrayer: current,
      remainingDuration: remaining,
      isExactPrayerMoment: isExact,
    );
  }
}
