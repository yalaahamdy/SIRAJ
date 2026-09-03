import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/prayer/services/prayer_notification_service.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Notification Cancellation by ID Suite (§25, §74, §106)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
    });

    test('Cancellation 1: Cancelling notifications clears active schedules (§25, §74)', () {
      final scheduleRes = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: const GeoCoordinates(latitude: 21.4225, longitude: 39.8262),
        parameters: CalculationParameters.ummAlQura,
      );

      final notifService = PrayerNotificationService(
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );

      notifService.scheduleDailyPrayers(
        schedule: scheduleRes.valueOrNull!,
        now: DateTime(2026, 9, 1, 4, 0),
      );
      expect(notifService.activeSchedules.isNotEmpty, true);

      notifService.cancelAll();
      expect(notifService.activeSchedules.isEmpty, true);
    });
  });
}
