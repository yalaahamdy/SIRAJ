import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/location/location_models.dart';
import '../../../core/time/clock.dart';
import '../../prayer/domain/calculation_parameters.dart';
import '../../prayer/domain/prayer_type.dart';
import '../../prayer/prayer_module.dart';
import '../calendar/hijri_calendar_service.dart';
import '../domain/fasting_policy.dart';
import '../domain/fasting_schedule_day.dart';

/// Service for calculating daily fasting schedule, Suhoor, and Iftar timings (§10, §11, §12).
/// Consumes the existing [PrayerModule] without duplicating astronomical algorithms.
class FastingScheduleService {
  final PrayerModule _prayerModule;
  final HijriCalendarService _calendarService;
  final Clock _clock;

  FastingScheduleService({
    required PrayerModule prayerModule,
    HijriCalendarService? calendarService,
    Clock? clock,
  })  : _prayerModule = prayerModule,
        _calendarService = calendarService ?? HijriCalendarService(clock: clock),
        _clock = clock ?? const SystemClock();

  /// Computes the complete [FastingScheduleDay] for a specific [date] and [location].
  Future<Result<FastingScheduleDay, Failure>> getFastingSchedule({
    required DateTime date,
    required GeoCoordinates location,
    required CalculationParameters calculationParameters,
    FastingPolicy policy = FastingPolicy.standard,
    int calendarOffsetDays = 0,
    Duration? timezoneOffset,
  }) async {
    final scheduleRes = await _prayerModule.getSchedule(
      date: date,
      location: location,
      parameters: calculationParameters,
      timezoneOffset: timezoneOffset,
    );

    if (scheduleRes.isFailure) {
      return Result.err(scheduleRes.failureOrNull!);
    }

    final schedule = scheduleRes.valueOrNull!;
    final fajrTime = schedule.entries[PrayerType.fajr]!.time;
    final maghribTime = schedule.entries[PrayerType.maghrib]!.time;

    final suhoorImsakTime = fajrTime.subtract(Duration(minutes: policy.imsakBufferMinutes));
    final fastingDuration = maghribTime.difference(fajrTime);

    final hijriDate = _calendarService.getHijriDate(date, offsetDays: calendarOffsetDays);
    final isRamadan = hijriDate.isRamadan;
    final ramadanDayNumber = _calendarService.getRamadanDayNumber(date, offsetDays: calendarOffsetDays);

    final now = _clock.nowUtc();
    final isCurrentlyFasting = now.isAfter(fajrTime) && now.isBefore(maghribTime);

    String nextBoundaryLabel;
    DateTime nextBoundaryTime;
    Duration remaining;

    if (now.isBefore(suhoorImsakTime)) {
      nextBoundaryLabel = policy.imsakBufferMinutes > 0 ? 'وقت الإمساك' : 'أذان الفجر (بدء الصيام)';
      nextBoundaryTime = suhoorImsakTime;
      remaining = suhoorImsakTime.difference(now);
    } else if (now.isBefore(fajrTime)) {
      nextBoundaryLabel = 'أذان الفجر (بدء الصيام)';
      nextBoundaryTime = fajrTime;
      remaining = fajrTime.difference(now);
    } else if (now.isBefore(maghribTime)) {
      nextBoundaryLabel = 'أذان المغرب (موعد الإفطار)';
      nextBoundaryTime = maghribTime;
      remaining = maghribTime.difference(now);
    } else {
      // After Maghrib -> Next boundary is tomorrow's Suhoor/Fajr
      final tomorrow = date.add(const Duration(days: 1));
      final tomorrowScheduleRes = await _prayerModule.getSchedule(
        date: tomorrow,
        location: location,
        parameters: calculationParameters,
        timezoneOffset: timezoneOffset,
      );

      DateTime tomorrowFajr;
      if (tomorrowScheduleRes.isSuccess) {
        tomorrowFajr = tomorrowScheduleRes.valueOrNull!.entries[PrayerType.fajr]!.time;
      } else {
        tomorrowFajr = fajrTime.add(const Duration(days: 1));
      }

      final tomorrowSuhoor = tomorrowFajr.subtract(Duration(minutes: policy.imsakBufferMinutes));
      nextBoundaryLabel = policy.imsakBufferMinutes > 0 ? 'إمساك الغد' : 'فجر الغد (بدء الصيام)';
      nextBoundaryTime = tomorrowSuhoor;
      remaining = tomorrowSuhoor.difference(now);
    }

    return Result.ok(
      FastingScheduleDay(
        date: date,
        hijriDate: hijriDate,
        isRamadan: isRamadan,
        ramadanDayNumber: ramadanDayNumber,
        suhoorImsakTime: suhoorImsakTime,
        fastStartTime: fajrTime,
        fastEndTime: maghribTime,
        fastingDuration: fastingDuration,
        isCurrentlyFasting: isCurrentlyFasting,
        nextBoundaryLabel: nextBoundaryLabel,
        nextBoundaryTime: nextBoundaryTime,
        remainingToNextBoundary: remaining.isNegative ? Duration.zero : remaining,
      ),
    );
  }
}
