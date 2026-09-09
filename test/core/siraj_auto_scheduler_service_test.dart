import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/notifications/siraj_auto_scheduler_service.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SirajAutoSchedulerService Tests — Proactive Rolling 14-Day Notification Engine', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
    });

    test('Schedules rolling 14 days of prayers, adhkar, and wird successfully', () async {
      final total = await SirajAutoSchedulerService.instance.scheduleRolling14Days(
        prayerModule: prayerModule,
        location: const GeoCoordinates(latitude: 30.0444, longitude: 31.2357, cityName: 'القاهرة'),
        parameters: CalculationParameters.egyptian,
        daysCount: 14,
      );

      expect(total, greaterThan(50));
      expect(SirajAutoSchedulerService.instance.lastScheduledCount, equals(total));
      expect(SirajAutoSchedulerService.instance.lastScheduledTime, isNotNull);
    });

    test('ID schema uniqueness: Base constants are strictly non-overlapping', () {
      final bases = [
        SirajAutoSchedulerService.basePreAthan,
        SirajAutoSchedulerService.baseAthan,
        SirajAutoSchedulerService.baseIqama,
        SirajAutoSchedulerService.baseAdhkar,
        SirajAutoSchedulerService.baseQiyam,
        SirajAutoSchedulerService.baseDuha,
        SirajAutoSchedulerService.baseFriday,
        SirajAutoSchedulerService.baseQuranWird,
        SirajAutoSchedulerService.baseFastingSuhoor,
        SirajAutoSchedulerService.baseFastingIftar,
      ];

      // Verify all bases are unique
      expect(bases.toSet().length, equals(bases.length));

      // Verify each base allows 30 days without overlapping adjacent base
      for (int i = 0; i < bases.length - 1; i++) {
        final maxDayId = bases[i] + (30 * 100) + 99;
        expect(maxDayId, lessThan(bases[i + 1]));
      }
    });
  });
}
