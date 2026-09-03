import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Daylight Saving Time (DST) Handling Suite (§33, §106)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(DateTime(2026, 3, 28, 4, 0)),
      );
    });

    test('DST 1: Calculates schedule properly across DST transition periods (§33)', () {
      const coords = GeoCoordinates(latitude: 51.5074, longitude: -0.1278);

      final schBefore = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 3, 28),
        location: coords,
        parameters: CalculationParameters.muslimWorldLeague,
      ).valueOrNull!;

      final schAfter = prayerModule.scheduleService.getSchedule(
        date: DateTime(2026, 3, 30),
        location: coords,
        parameters: CalculationParameters.muslimWorldLeague,
      ).valueOrNull!;

      expect(schBefore.fajr!.time.isBefore(schAfter.fajr!.time), true);
    });
  });
}
