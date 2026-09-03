import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/fasting/domain/fasting_policy.dart';
import 'package:siraj/modules/fasting/services/fasting_schedule_service.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('L2 FastingScheduleService Prayer Integration Tests (§10, §11, §12)', () {
    late MemoryStorageRegistry registry;
    late PrayerModule prayerModule;
    late FastingScheduleService fastingScheduleService;
    final fixedNow = DateTime.utc(2026, 8, 31, 12, 0, 0); // Noon
    final testClock = TestClock(fixedNow);
    const makkahLocation = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);

    setUp(() {
      registry = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: registry, clock: testClock);
      fastingScheduleService = FastingScheduleService(
        prayerModule: prayerModule,
        clock: testClock,
      );
    });

    test('Computes FastingScheduleDay accurately from Prayer Schedule (Fajr and Maghrib)', () async {
      final res = await fastingScheduleService.getFastingSchedule(
        date: fixedNow,
        location: makkahLocation,
        calculationParameters: CalculationParameters.ummAlQura,
      );

      expect(res.isSuccess, isTrue);
      final sched = res.valueOrNull!;

      expect(sched.fastStartTime.isBefore(sched.fastEndTime), isTrue);
      expect(sched.fastingDuration.inHours, greaterThan(11));
      expect(sched.fastingDuration.inHours, lessThan(16));
      expect(sched.isCurrentlyFasting, isTrue); // At noon (12:00) during fast window
      expect(sched.nextBoundaryLabel, equals('أذان المغرب (موعد الإفطار)'));
    });

    test('Precautionary Imsak policy applies buffer minutes to Suhoor time', () async {
      final standardRes = await fastingScheduleService.getFastingSchedule(
        date: fixedNow,
        location: makkahLocation,
        calculationParameters: CalculationParameters.ummAlQura,
        policy: FastingPolicy.standard, // 0m buffer
      );

      final imsakRes = await fastingScheduleService.getFastingSchedule(
        date: fixedNow,
        location: makkahLocation,
        calculationParameters: CalculationParameters.ummAlQura,
        policy: FastingPolicy.precautionaryImsak, // 10m buffer
      );

      final standard = standardRes.valueOrNull!;
      final imsak = imsakRes.valueOrNull!;

      expect(standard.suhoorImsakTime, equals(standard.fastStartTime));
      expect(
        imsak.suhoorImsakTime,
        equals(imsak.fastStartTime.subtract(const Duration(minutes: 10))),
      );
    });
  });
}
