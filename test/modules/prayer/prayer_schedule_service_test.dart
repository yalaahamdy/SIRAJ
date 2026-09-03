import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/events/app_events.dart';
import 'package:siraj/core/events/event_bus.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/services/prayer_schedule_service.dart';

void main() {
  group('L2 PrayerScheduleService Tests', () {
    late EventBus bus;
    late TestClock clock;
    late PrayerScheduleService service;

    const testLocation = GeoCoordinates(
      latitude: 24.7136,
      longitude: 46.6753,
      source: LocationSource.manual,
    );

    setUp(() {
      bus = EventBus(sync: true);
      clock = TestClock(DateTime.utc(2026, 8, 31, 12, 0, 0));
      service = PrayerScheduleService(clock: clock, eventBus: bus);
    });

    tearDown(() async {
      await bus.dispose();
    });

    test('Generates daily schedule and emits PrayerTimeUpdatedEvent', () {
      final events = <PrayerTimeUpdatedEvent>[];
      bus.on<PrayerTimeUpdatedEvent>().listen(events.add);

      final res = service.getSchedule(
        date: DateTime.utc(2026, 8, 31),
        location: testLocation,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );

      expect(res.isSuccess, isTrue);
      expect(events.length, equals(1));
      expect(events.first.calculationMethod, contains('Muslim World League'));
    });

    test('getNextPrayer correctly resolves transitions across the day', () {
      final scheduleRes = service.getSchedule(
        date: DateTime.utc(2026, 8, 31),
        location: testLocation,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );
      final schedule = scheduleRes.valueOrNull!;

      // 1. Before Fajr (e.g. 02:00 AM)
      final earlyMorning = DateTime(2026, 8, 31, 2, 0);
      var next = service.getNextPrayer(currentTime: earlyMorning, todaySchedule: schedule);
      expect(next?.type, equals(PrayerType.fajr));

      // 2. Between Dhuhr and Asr
      final dhuhrTime = schedule.dhuhr!.time;
      final midAfternoon = dhuhrTime.add(const Duration(minutes: 30));
      next = service.getNextPrayer(currentTime: midAfternoon, todaySchedule: schedule);
      expect(next?.type, equals(PrayerType.asr));

      // 3. After Isha (e.g. 23:30 PM) -> Day Rollover to next day's Fajr
      final lateNight = DateTime(2026, 8, 31, 23, 30);
      next = service.getNextPrayer(currentTime: lateNight, todaySchedule: schedule);
      expect(next?.type, equals(PrayerType.fajr));
      expect(next!.time.day, equals(1)); // 1st of September
    });

    test('getCurrentPrayer correctly resolves active prayer period', () {
      final scheduleRes = service.getSchedule(
        date: DateTime.utc(2026, 8, 31),
        location: testLocation,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );
      final schedule = scheduleRes.valueOrNull!;

      // 1. Just after Dhuhr starts
      final dhuhrPlus5 = schedule.dhuhr!.time.add(const Duration(minutes: 5));
      var current = service.getCurrentPrayer(currentTime: dhuhrPlus5, todaySchedule: schedule);
      expect(current?.type, equals(PrayerType.dhuhr));

      // 2. Just after Asr starts
      final asrPlus5 = schedule.asr!.time.add(const Duration(minutes: 5));
      current = service.getCurrentPrayer(currentTime: asrPlus5, todaySchedule: schedule);
      expect(current?.type, equals(PrayerType.asr));
    });
  });
}
