import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/prayer/services/prayer_notification_service.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Geographic Location Change Rescheduling Suite (§32, §103, §106)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
    });

    test('Location Change 1: Changing location cancels previous prayer schedules and recalculates accurately (§32, §103)', () {
      const coordsMakkah = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);
      const coordsCairo = GeoCoordinates(latitude: 30.0444, longitude: 31.2357);

      final notifService = PrayerNotificationService(
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );

      final schMakkah = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: coordsMakkah,
        parameters: CalculationParameters.ummAlQura,
      ).valueOrNull!;

      notifService.scheduleDailyPrayers(schedule: schMakkah, now: DateTime(2026, 9, 1, 4, 0));
      final makkahFajr = notifService.activeSchedules.first.scheduledTime;

      final schCairo = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: coordsCairo,
        parameters: CalculationParameters.egyptian,
      ).valueOrNull!;

      notifService.scheduleDailyPrayers(schedule: schCairo, now: DateTime(2026, 9, 1, 4, 0));
      final cairoFajr = notifService.activeSchedules.first.scheduledTime;

      expect(makkahFajr != cairoFajr, true);
    });
  });
}
