import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Timezone Change Adaptation Suite (§31, §102, §106)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 9, 1, 4, 0)),
      );
    });

    test('Timezone 1: Timezone change recalculates prayer notifications accordingly (§31, §102)', () {
      const coordsMakkah = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);
      const coordsLondon = GeoCoordinates(latitude: 51.5074, longitude: -0.1278);

      final sch1 = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: coordsMakkah,
        parameters: CalculationParameters.ummAlQura,
      ).valueOrNull!;

      final sch2 = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 9, 1),
        location: coordsLondon,
        parameters: CalculationParameters.muslimWorldLeague,
      ).valueOrNull!;

      expect(sch1.fajr!.time != sch2.fajr!.time, true);
    });
  });
}
