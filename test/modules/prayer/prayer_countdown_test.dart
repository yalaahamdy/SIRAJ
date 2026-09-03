import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/services/prayer_countdown_service.dart';
import 'package:siraj/modules/prayer/services/prayer_schedule_service.dart';

void main() {
  group('L2 PrayerCountdownService Tests (§13)', () {
    late TestClock clock;
    late PrayerScheduleService scheduleService;
    late PrayerCountdownService countdownService;

    const testLocation = GeoCoordinates(
      latitude: 24.7136,
      longitude: 46.6753,
      source: LocationSource.manual,
    );

    setUp(() {
      clock = TestClock(DateTime.utc(2026, 8, 31, 10, 0, 0));
      scheduleService = PrayerScheduleService(clock: clock);
      countdownService = PrayerCountdownService(
        scheduleService: scheduleService,
        clock: clock,
      );
    });

    test('Calculates accurate countdown duration and formatted timer', () {
      final scheduleRes = scheduleService.getSchedule(
        date: DateTime.utc(2026, 8, 31),
        location: testLocation,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );
      final schedule = scheduleRes.valueOrNull!;
      final asrTime = schedule.asr!.time;

      // 1 hour and 30 minutes before Asr
      final testTime = asrTime.subtract(const Duration(hours: 1, minutes: 30));
      clock.setTime(testTime);

      final state = countdownService.getCountdownState(
        todaySchedule: schedule,
      );

      expect(state.nextPrayer?.type, equals(PrayerType.asr));
      expect(state.remainingDuration.inMinutes, equals(90));
      expect(state.formattedTimer, equals('01:30:00'));
      expect(state.formattedArabic, contains('1 س و 30 د'));
      expect(state.isExactPrayerMoment, isFalse);
    });

    test('Transitions seamlessly across exact prayer boundary', () {
      final scheduleRes = scheduleService.getSchedule(
        date: DateTime.utc(2026, 8, 31),
        location: testLocation,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );
      final schedule = scheduleRes.valueOrNull!;
      final maghribTime = schedule.maghrib!.time;

      // 1 second before Maghrib
      clock.setTime(maghribTime.subtract(const Duration(seconds: 1)));
      var state = countdownService.getCountdownState(todaySchedule: schedule);
      expect(state.nextPrayer?.type, equals(PrayerType.maghrib));
      expect(state.remainingDuration.inSeconds, equals(1));

      // At exact moment of Maghrib, current becomes Maghrib and next advances to Isha
      clock.setTime(maghribTime);
      state = countdownService.getCountdownState(todaySchedule: schedule);
      expect(state.currentPrayer?.type, equals(PrayerType.maghrib));
      expect(state.nextPrayer?.type, equals(PrayerType.isha));
    });
  });
}
