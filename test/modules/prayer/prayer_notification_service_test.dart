import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/events/app_events.dart';
import 'package:siraj/core/events/event_bus.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/services/prayer_notification_service.dart';
import 'package:siraj/modules/prayer/services/prayer_schedule_service.dart';

void main() {
  group('L2 Prayer Notification Service Tests (§17)', () {
    late EventBus bus;
    late TestClock clock;
    late PrayerScheduleService scheduleService;
    late PrayerNotificationService notificationService;

    const location = GeoCoordinates(latitude: 24.7136, longitude: 46.6753);

    setUp(() {
      bus = EventBus(sync: true);
      clock = TestClock(DateTime(2026, 8, 31, 10, 0)); // 10:00 AM local
      scheduleService = PrayerScheduleService(clock: clock, eventBus: bus);
      notificationService = PrayerNotificationService(clock: clock, eventBus: bus);
    });

    tearDown(() async {
      await bus.dispose();
    });

    test('Schedules only upcoming prayers and skips already passed ones', () {
      final scheduleRes = scheduleService.getSchedule(
        date: DateTime(2026, 8, 31),
        location: location,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );
      final schedule = scheduleRes.valueOrNull!;

      // At 10:00 AM, Fajr (around 4:30 AM) has passed; Dhuhr, Asr, Maghrib, Isha are upcoming
      final res = notificationService.scheduleDailyPrayers(
        schedule: schedule,
        now: DateTime(2026, 8, 31, 10, 0),
      );

      expect(res.isSuccess, isTrue);
      final schedules = notificationService.activeSchedules;

      expect(schedules.length, equals(4)); // Dhuhr, Asr, Maghrib, Isha
      expect(schedules.any((s) => s.prayerType == PrayerType.fajr), isFalse);
      expect(schedules.any((s) => s.prayerType == PrayerType.dhuhr), isTrue);
      expect(schedules.any((s) => s.prayerType == PrayerType.asr), isTrue);
      expect(schedules.any((s) => s.prayerType == PrayerType.maghrib), isTrue);
      expect(schedules.any((s) => s.prayerType == PrayerType.isha), isTrue);
    });

    test('cancelAll clears active scheduled notifications', () {
      final scheduleRes = scheduleService.getSchedule(
        date: DateTime(2026, 8, 31),
        location: location,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );
      final schedule = scheduleRes.valueOrNull!;

      notificationService.scheduleDailyPrayers(
        schedule: schedule,
        now: DateTime(2026, 8, 31, 4, 0),
      );
      expect(notificationService.activeSchedules.isNotEmpty, isTrue);

      notificationService.cancelAll();
      expect(notificationService.activeSchedules.isEmpty, isTrue);
    });

    test('triggerPrayerEntered publishes PrayerTimeEnteredEvent via EventBus', () {
      final enteredEvents = <PrayerTimeEnteredEvent>[];
      bus.on<PrayerTimeEnteredEvent>().listen(enteredEvents.add);

      final enteredTime = DateTime(2026, 8, 31, 12, 15);
      notificationService.triggerPrayerEntered(PrayerType.dhuhr, enteredTime);

      expect(enteredEvents.length, equals(1));
      expect(enteredEvents.first.prayerName, equals('dhuhr'));
      expect(enteredEvents.first.time, equals(enteredTime));
    });
  });
}
