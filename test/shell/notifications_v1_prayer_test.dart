import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/prayer/services/prayer_notification_service.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Prayer Notifications Suite (§5..§9, §96, §106)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
    });

    test('Prayer 1: Schedules upcoming prayer notifications with calm, non-judgmental wording (§6, §7)', () {
      final scheduleRes = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: const GeoCoordinates(latitude: 21.4225, longitude: 39.8262),
        parameters: CalculationParameters.ummAlQura,
      );
      expect(scheduleRes.isSuccess, true);

      final notifService = PrayerNotificationService(
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
      final listRes = notifService.scheduleDailyPrayers(
        schedule: scheduleRes.valueOrNull!,
        now: DateTime(2026, 9, 1, 4, 0),
      );

      expect(listRes.isSuccess, true);
      final items = listRes.valueOrNull!;
      expect(items.isNotEmpty, true);

      // Verify wording contains no shame or guilt
      for (final item in items) {
        expect(item.title.contains('حان الآن وقت صلاة'), true);
        expect(item.body.contains('فاتتك'), false);
        expect(item.body.contains('مقصر'), false);
      }
    });
  });
}
