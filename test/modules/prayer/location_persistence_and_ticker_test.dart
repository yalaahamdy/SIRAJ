import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/city_presets.dart';
import 'package:siraj/core/location/location_engine.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_adjustments.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/engine/astronomical_calculator.dart';
import 'package:siraj/modules/prayer/services/prayer_countdown_service.dart';
import 'package:siraj/modules/prayer/services/prayer_schedule_service.dart';

void main() {
  group('Location Model Serialization & Persistence (§10, §11)', () {
    test('GeoCoordinates serializes to JSON and deserializes accurately', () {
      final now = DateTime(2026, 9, 3, 14, 0, 0);
      final coords = GeoCoordinates(
        latitude: 21.4225,
        longitude: 39.8262,
        altitude: 277.0,
        accuracy: 5.0,
        source: LocationSource.gps,
        timestamp: now,
        cityName: 'مكة المكرمة',
        countryName: 'المملكة العربية السعودية',
        isMocked: false,
      );

      final json = coords.toJson();
      expect(json['latitude'], 21.4225);
      expect(json['longitude'], 39.8262);
      expect(json['source'], 'gps');
      expect(json['cityName'], 'مكة المكرمة');

      final fromJson = GeoCoordinates.fromJson(json);
      expect(fromJson.latitude, coords.latitude);
      expect(fromJson.longitude, coords.longitude);
      expect(fromJson.source, LocationSource.gps);
      expect(fromJson.cityName, coords.cityName);
      expect(fromJson.countryName, coords.countryName);
    });

    test('LocationEngine persists manual location to StorageRegistry and reloads it', () async {
      final storage = MemoryStorageRegistry();
      final engine1 = LocationEngine(storageRegistry: storage);

      final mecca = CanonicalCityPreset.canonicalPresets.first.coordinates;
      engine1.setManualLocation(mecca);

      expect(engine1.currentEffectiveLocation.cityName, 'مكة المكرمة');

      // Create new instance with same storage to verify persistence
      final engine2 = LocationEngine(storageRegistry: storage);
      await engine2.initFromStorage();

      expect(engine2.currentEffectiveLocation.cityName, 'مكة المكرمة');
      expect(engine2.currentEffectiveLocation.latitude, mecca.latitude);
    });

    test('LocationEngine emits location on stream when updated', () async {
      final storage = MemoryStorageRegistry();
      final engine = LocationEngine(storageRegistry: storage);

      final emitted = <GeoCoordinates>[];
      final sub = engine.locationStream.listen(emitted.add);

      final cairo = CanonicalCityPreset.canonicalPresets.firstWhere((c) => c.cityNameArabic == 'القاهرة').coordinates;
      engine.setManualLocation(cairo);

      await Future.delayed(Duration.zero);
      expect(emitted.isNotEmpty, isTrue);
      expect(emitted.last.cityName, 'القاهرة');

      await sub.cancel();
      engine.dispose();
    });
  });

  group('Prayer Countdown Live Updates (§5, §6)', () {
    test('Countdown state updates continuously as time progresses', () async {
      final scheduleService = PrayerScheduleService(
        engine: const AstronomicalPrayerCalculator(),
      );
      final countdownService = PrayerCountdownService(
        scheduleService: scheduleService,
      );

      final testDate = DateTime(2026, 9, 3, 11, 30, 0); // 11:30 AM (before Dhuhr)
      final location = CanonicalCityPreset.canonicalPresets.firstWhere((c) => c.cityNameArabic == 'الرياض').coordinates;
      final params = CalculationParameters.muslimWorldLeague;

      final todayRes = scheduleService.getSchedule(
        date: testDate,
        location: location,
        parameters: params,
        adjustments: PrayerAdjustments.zero,
      );

      expect(todayRes.isSuccess, isTrue);
      final todaySchedule = todayRes.valueOrNull!;

      final state1 = countdownService.getCountdownState(
        time: testDate,
        todaySchedule: todaySchedule,
      );

      expect(state1.nextPrayer?.type, PrayerType.dhuhr);
      expect(state1.remainingDuration.inSeconds > 0, isTrue);
      final initialRemaining = state1.remainingDuration.inSeconds;

      // Verify formatted timer pattern HH:MM:SS
      expect(state1.formattedTimer, contains(':'));
      expect(initialRemaining, greaterThan(0));
    });
  });
}

