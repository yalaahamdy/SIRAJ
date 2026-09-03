import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_policy.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting Schedule Integration Suite (§7..§10, §95, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
    });

    test('Schedule 1: Standard policy aligns Suhoor/Imsak directly with Fajr', () async {
      const loc = GeoCoordinates(latitude: 21.4225, longitude: 39.8262); // Makkah
      final res = await fastingModule.getTodaySchedule(
        location: loc,
        calculationParameters: CalculationParameters.ummAlQura,
      );

      expect(res.isSuccess, isTrue);
      final schedule = res.valueOrNull!;
      expect(schedule.suhoorImsakTime, equals(schedule.fastStartTime));
      expect(schedule.fastEndTime.isAfter(schedule.fastStartTime), isTrue);
      expect(schedule.isRamadan, isNotNull);
    });

    test('Schedule 2: Precautionary Imsak policy applies configured minutes before Fajr', () async {
      await fastingModule.setActivePolicy(FastingPolicy.precautionaryImsak.policyId);

      const loc = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);
      final res = await fastingModule.getTodaySchedule(
        location: loc,
        calculationParameters: CalculationParameters.ummAlQura,
      );

      expect(res.isSuccess, isTrue);
      final schedule = res.valueOrNull!;
      expect(schedule.suhoorImsakTime.isBefore(schedule.fastStartTime), isTrue);
      expect(
        schedule.fastStartTime.difference(schedule.suhoorImsakTime).inMinutes,
        equals(FastingPolicy.precautionaryImsak.imsakBufferMinutes.abs()),
      );
    });
  });
}
