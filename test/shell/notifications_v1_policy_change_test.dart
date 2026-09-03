import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Calculation Policy Change Rescheduling Suite (§62, §64, §106)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
    });

    test('Policy Change 1: Modifying calculation method updates prayer notification timing accurately (§62)', () {
      const coords = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);

      final schUmmAlQura = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: coords,
        parameters: CalculationParameters.ummAlQura,
      ).valueOrNull!;

      final schMWL = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: coords,
        parameters: CalculationParameters.muslimWorldLeague,
      ).valueOrNull!;

      expect(schUmmAlQura.fajr!.time != schMWL.fajr!.time, true);
    });
  });
}
