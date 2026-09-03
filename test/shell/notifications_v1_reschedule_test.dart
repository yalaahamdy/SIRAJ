import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/prayer/services/prayer_notification_service.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Rescheduling Without Duplication Suite (§24, §102, §106)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
    });

    test('Reschedule 1: Rescheduling prayer schedule clears old active schedules and creates updated set (§24)', () {
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
      final countFirst = notifService.activeSchedules.length;

      // Reschedule again
      notifService.scheduleDailyPrayers(
        schedule: scheduleRes.valueOrNull!,
        now: DateTime(2026, 9, 1, 4, 0),
      );
      final countSecond = notifService.activeSchedules.length;

      expect(countFirst, equals(countSecond));
    });
  });
}
