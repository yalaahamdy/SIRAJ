import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/city_presets.dart';
import 'package:siraj/core/location/location_engine.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/location/location_service.dart';

void main() {
  group('M49: SIRAJ v1.0 — Location Engine & Manual Fallback Suite (§10, §11, §39, §40)', () {
    test('LocationEngine: Initializes with default city and provides transparent coordinates', () {
      final engine = LocationEngine();
      final effective = engine.currentEffectiveLocation;

      expect(effective.latitude, equals(21.4225));
      expect(effective.longitude, equals(39.8262));
      expect(effective.source, equals(LocationSource.manual));
      expect(effective.cityName, contains('مكة'));
    });

    test('LocationEngine: Setting manual city updates effective location and report', () {
      final engine = LocationEngine();
      const riyadh = GeoCoordinates(
        latitude: 24.7136,
        longitude: 46.6753,
        source: LocationSource.manual,
        cityName: 'الرياض',
        countryName: 'المملكة العربية السعودية',
      );

      engine.setManualLocation(riyadh);
      expect(engine.currentEffectiveLocation.cityName, equals('الرياض'));
      expect(engine.lastReport, isNotNull);
      expect(engine.lastReport!.isAutomatic, isFalse);
      expect(engine.lastReport!.statusMessageArabic, contains('الرياض'));
    });

    test('CanonicalCityPreset: Provides 30+ authentic world cities and robust bilingual search', () {
      final presets = CanonicalCityPreset.canonicalPresets;
      expect(presets.length, greaterThanOrEqualTo(30));

      // Test Arabic search
      final makkahResults = CanonicalCityPreset.search('مكة');
      expect(makkahResults.isNotEmpty, isTrue);
      expect(makkahResults.first.cityNameArabic, contains('مكة'));

      // Test English search
      final londonResults = CanonicalCityPreset.search('London');
      expect(londonResults.isNotEmpty, isTrue);
      expect(londonResults.first.cityNameEnglish, equals('London'));

      // Test Country search
      final egyptResults = CanonicalCityPreset.search('مصر');
      expect(egyptResults.length, greaterThanOrEqualTo(2)); // Cairo, Alexandria

      // Empty search returns all presets
      expect(CanonicalCityPreset.search('').length, equals(presets.length));
    });

    test('ProductionLocationService: Safely wraps LocationEngine without crashes', () async {
      final engine = LocationEngine();
      final service = ProductionLocationService(engine: engine);

      final manualRes = await service.getManualLocation();
      expect(manualRes.isSuccess, isTrue);
      expect(manualRes.valueOrNull!.cityName, contains('مكة'));

      const cairo = GeoCoordinates(
        latitude: 30.0444,
        longitude: 31.2357,
        source: LocationSource.manual,
        cityName: 'القاهرة',
      );

      await service.setManualLocation(cairo);
      final updatedRes = await service.getCurrentLocation();
      expect(updatedRes.isSuccess, isTrue);
      expect(updatedRes.valueOrNull!.cityName, equals('القاهرة'));
    });
  });
}
