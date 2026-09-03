import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/city_presets.dart';
import 'package:siraj/core/location/location_engine.dart';
import 'package:siraj/core/location/location_models.dart';

void main() {
  group('M52: SIRAJ v1.0 — Location Engine & Offline City Presets Suite (§10, §11, §39)', () {
    late LocationEngine engine;

    setUp(() {
      engine = LocationEngine();
    });

    test('Initial state: Defaults to Makkah Al-Mukarramah if no custom location is configured', () {
      final loc = engine.currentEffectiveLocation;
      expect(loc.latitude, closeTo(21.4225, 0.001));
      expect(loc.longitude, closeTo(39.8262, 0.001));
      expect(loc.cityName, equals('مكة المكرمة'));
    });

    test('Manual Location: Sets and updates effective location with non-automatic source tag', () {
      const cairoCoords = GeoCoordinates(
        latitude: 30.0444,
        longitude: 31.2357,
        cityName: 'القاهرة',
        countryName: 'مصر',
        source: LocationSource.manual,
      );

      engine.setManualLocation(cairoCoords);

      final current = engine.currentEffectiveLocation;
      expect(current.latitude, equals(30.0444));
      expect(current.longitude, equals(31.2357));
      expect(current.cityName, equals('القاهرة'));
      expect(current.source, equals(LocationSource.manual));

      final report = engine.lastReport;
      expect(report, isNotNull);
      expect(report!.isAutomatic, isFalse);
      expect(report.statusMessageArabic.contains('القاهرة'), isTrue);
    });

    test('Offline City Presets: Curated dataset covers 40+ major Islamic and world cities', () {
      expect(CanonicalCityPreset.canonicalPresets.length, greaterThanOrEqualTo(40));

      for (final preset in CanonicalCityPreset.canonicalPresets) {
        expect(preset.cityNameArabic.isNotEmpty, isTrue);
        expect(preset.cityNameEnglish.isNotEmpty, isTrue);
        expect(preset.countryNameArabic.isNotEmpty, isTrue);
        expect(preset.coordinates.latitude, inInclusiveRange(-90.0, 90.0));
        expect(preset.coordinates.longitude, inInclusiveRange(-180.0, 180.0));
      }
    });

    test('City Search: Accurately finds presets in Arabic, English, and partial keywords', () {
      final riyadhSearch = CanonicalCityPreset.search('الرياض');
      expect(riyadhSearch.isNotEmpty, isTrue);
      expect(riyadhSearch.first.cityNameEnglish, equals('Riyadh'));

      final londonSearch = CanonicalCityPreset.search('London');
      expect(londonSearch.isNotEmpty, isTrue);
      expect(londonSearch.first.cityNameArabic, equals('لندن'));

      final cairoSearch = CanonicalCityPreset.search('cairo');
      expect(cairoSearch.isNotEmpty, isTrue);
      expect(cairoSearch.first.countryNameArabic.contains('مصر'), isTrue);

      final emptySearch = CanonicalCityPreset.search('');
      expect(emptySearch.length, equals(CanonicalCityPreset.canonicalPresets.length));
    });

    test('Coordinate Validation: Enforces spherical geographic bounds with assertion errors', () {
      expect(() => GeoCoordinates(latitude: 91.0, longitude: 0.0), throwsA(isA<AssertionError>()));
      expect(() => GeoCoordinates(latitude: 0.0, longitude: 181.0), throwsA(isA<AssertionError>()));
      expect(() => GeoCoordinates(latitude: -91.0, longitude: 0.0), throwsA(isA<AssertionError>()));
      expect(() => GeoCoordinates(latitude: 0.0, longitude: -181.0), throwsA(isA<AssertionError>()));
      const valid = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);
      expect(valid.latitude, equals(21.4225));
    });
  });
}
