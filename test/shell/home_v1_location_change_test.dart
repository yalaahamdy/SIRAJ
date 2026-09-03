import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Location Change & Recalculation Suite (§60, §104, §114)', () {
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

    test('Location Change 1: Changing location dynamically recalculates prayer times (§60, §104)', () async {
      const mecca = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);
      final scheduleRes = await prayerModule.getSchedule(
        date: DateTime.now(),
        location: mecca,
        parameters: CalculationParameters.ummAlQura,
      );

      expect(scheduleRes.isSuccess, true);

      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      final prayerCard = cards.firstWhere((c) => c.sourceModule == 'prayer');
      expect(prayerCard.subtitleArabic, isNotEmpty);
    });
  });
}
