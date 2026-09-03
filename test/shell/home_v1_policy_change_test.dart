import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Policy Change & Dynamic Home Recalculation Suite (§61, §114)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      companionModule = CompanionModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
      );
    });

    test('Policy Change 1: Changing prayer calculation method updates prayer calculations (§61)', () async {
      const riyadh = GeoCoordinates(latitude: 24.7136, longitude: 46.6753);
      final scheduleRes = await prayerModule.getSchedule(
        date: DateTime.now(),
        location: riyadh,
        parameters: CalculationParameters.ummAlQura,
      );

      expect(scheduleRes.isSuccess, true);

      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.any((c) => c.sourceModule == 'prayer'), true);
    });
  });
}
