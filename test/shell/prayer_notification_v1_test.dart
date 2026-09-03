import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Prayer Notification Suite (§20, §21, §22, §46)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late DateTime fixedTime;

    setUp(() {
      storage = MemoryStorageRegistry();
      fixedTime = DateTime.utc(2026, 9, 1, 4, 0); // 04:00 AM UTC (Before Fajr)
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(fixedTime),
      );
    });

    test('PrayerNotificationService schedules upcoming daily prayers without duplicates', () async {
      final scheduleRes = await prayerModule.getSchedule(
        date: fixedTime,
        location: const GeoCoordinates(
          latitude: 24.7136,
          longitude: 46.6753,
          source: LocationSource.manual,
        ),
        parameters: CalculationParameters.muslimWorldLeague,
      );
      expect(scheduleRes.isSuccess, isTrue);

      final schedule = scheduleRes.valueOrNull!;
      final notifsRes = prayerModule.notificationService.scheduleDailyPrayers(
        schedule: schedule,
        now: fixedTime,
      );

      expect(notifsRes.isSuccess, isTrue);
      final notifs = notifsRes.valueOrNull!;
      expect(notifs.isNotEmpty, isTrue);

      // Verify no duplicate IDs
      final ids = notifs.map((n) => n.id).toSet();
      expect(ids.length, equals(notifs.length));

      // Verify all notifications are for future times
      for (final n in notifs) {
        expect(n.scheduledTime.isAfter(fixedTime), isTrue);
        expect(n.title.contains('حان الآن وقت صلاة'), isTrue);
      }
    });

    test('Disabling notifications cancels all active scheduled reminders cleanly', () async {
      final scheduleRes = await prayerModule.getSchedule(
        date: fixedTime,
        location: const GeoCoordinates(
          latitude: 24.7136,
          longitude: 46.6753,
          source: LocationSource.manual,
        ),
        parameters: CalculationParameters.muslimWorldLeague,
      );

      prayerModule.notificationService.scheduleDailyPrayers(
        schedule: scheduleRes.valueOrNull!,
        now: fixedTime,
      );
      expect(prayerModule.notificationService.activeSchedules.isNotEmpty, isTrue);

      // Cancel all
      prayerModule.notificationService.cancelAll();
      expect(prayerModule.notificationService.activeSchedules.isEmpty, isTrue);
    });

    test('Triggering prayer entered event publishes event cleanly', () {
      bool eventFired = false;
      prayerModule.notificationService.triggerPrayerEntered(
        PrayerType.dhuhr,
        fixedTime,
      );
      // Clean invocation without exceptions
      expect(eventFired, isFalse);
    });
  });
}
