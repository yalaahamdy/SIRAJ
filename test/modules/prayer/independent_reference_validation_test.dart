import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/calculation_status.dart';
import 'package:siraj/modules/prayer/engine/astronomical_calculator.dart';

void main() {
  group('Independent Global Astronomical Reference Validation (§5, §7, §8, §30)', () {
    const calculator = AstronomicalPrayerCalculator();

    final testLocations = <String, Map<String, dynamic>>{
      'Cairo': {
        'coords': const GeoCoordinates(latitude: 30.0444, longitude: 31.2357),
        'tz': const Duration(hours: 3),
        'params': CalculationParameters.egyptian,
      },
      'Makkah': {
        'coords': const GeoCoordinates(latitude: 21.4225, longitude: 39.8262),
        'tz': const Duration(hours: 3),
        'params': CalculationParameters.ummAlQura,
      },
      'London': {
        'coords': const GeoCoordinates(latitude: 51.5074, longitude: -0.1278),
        'tz': const Duration(hours: 1),
        'params': CalculationParameters.muslimWorldLeague,
      },
      'New York': {
        'coords': const GeoCoordinates(latitude: 40.7128, longitude: -74.0060),
        'tz': const Duration(hours: -4),
        'params': CalculationParameters.isna,
      },
      'Pontianak (Equator)': {
        'coords': const GeoCoordinates(latitude: 0.0000, longitude: 109.3333),
        'tz': const Duration(hours: 7),
        'params': CalculationParameters.muslimWorldLeague,
      },
      'Sydney (Southern Hemisphere)': {
        'coords': const GeoCoordinates(latitude: -33.8688, longitude: 151.2093),
        'tz': const Duration(hours: 10),
        'params': CalculationParameters.muslimWorldLeague,
      },
      'Buenos Aires (Southern Hemisphere)': {
        'coords': const GeoCoordinates(latitude: -34.6037, longitude: -58.3816),
        'tz': const Duration(hours: -3),
        'params': CalculationParameters.muslimWorldLeague,
      },
    };

    test('All worldwide benchmark locations strictly satisfy chronological transition order', () {
      final date = DateTime.utc(2026, 8, 31);

      for (final entry in testLocations.entries) {
        final cityName = entry.key;
        final coords = entry.value['coords'] as GeoCoordinates;
        final tz = entry.value['tz'] as Duration;
        final params = entry.value['params'] as CalculationParameters;

        final res = calculator.calculateSchedule(
          date: date,
          location: coords,
          parameters: params,
          timezoneOffset: tz,
        );

        expect(res.isSuccess, isTrue, reason: 'Failed calculation for $cityName');
        final s = res.valueOrNull!;

        expect(
          s.status,
          anyOf(equals(CalculationStatus.normal), equals(CalculationStatus.highLatitudeRuleApplied)),
          reason: 'Abnormal status for $cityName: ${s.status}',
        );

        // Strict chronological order
        expect(s.fajr!.time.isBefore(s.sunrise!.time), isTrue, reason: 'Fajr not before Sunrise in $cityName');
        expect(s.sunrise!.time.isBefore(s.dhuhr!.time), isTrue, reason: 'Sunrise not before Dhuhr in $cityName');
        expect(s.dhuhr!.time.isBefore(s.asr!.time), isTrue, reason: 'Dhuhr not before Asr in $cityName');
        expect(s.asr!.time.isBefore(s.maghrib!.time), isTrue, reason: 'Asr not before Maghrib in $cityName');
        expect(s.maghrib!.time.isBefore(s.isha!.time), isTrue, reason: 'Maghrib not before Isha in $cityName');
      }
    });

    test('Equatorial location (Pontianak) has ~12 hours of daylight year-round', () {
      final equinoxDate = DateTime.utc(2026, 3, 21);
      final coords = testLocations['Pontianak (Equator)']!['coords'] as GeoCoordinates;
      final tz = testLocations['Pontianak (Equator)']!['tz'] as Duration;
      final params = testLocations['Pontianak (Equator)']!['params'] as CalculationParameters;

      final res = calculator.calculateSchedule(
        date: equinoxDate,
        location: coords,
        parameters: params,
        timezoneOffset: tz,
      );

      final s = res.valueOrNull!;
      final daylightMinutes = s.sunset!.time.difference(s.sunrise!.time).inMinutes;

      // Daylight on equator is approximately 12 hours (720 min) ± 15 min due to refraction
      expect(daylightMinutes, inInclusiveRange(710, 735));
    });

    test('Hemispheric daylight asymmetry: Northern summer vs Southern winter on August 31', () {
      final date = DateTime.utc(2026, 8, 31);
      final london = testLocations['London']!;
      final sydney = testLocations['Sydney (Southern Hemisphere)']!;

      final londonRes = calculator.calculateSchedule(
        date: date,
        location: london['coords'] as GeoCoordinates,
        parameters: london['params'] as CalculationParameters,
        timezoneOffset: london['tz'] as Duration,
      );

      final sydneyRes = calculator.calculateSchedule(
        date: date,
        location: sydney['coords'] as GeoCoordinates,
        parameters: sydney['params'] as CalculationParameters,
        timezoneOffset: sydney['tz'] as Duration,
      );

      final londonDaylight = londonRes.valueOrNull!.sunset!.time.difference(londonRes.valueOrNull!.sunrise!.time).inMinutes;
      final sydneyDaylight = sydneyRes.valueOrNull!.sunset!.time.difference(sydneyRes.valueOrNull!.sunrise!.time).inMinutes;

      // In late August, London daylight > 13 hours, while Sydney daylight < 11.5 hours
      expect(londonDaylight, greaterThan(780));
      expect(sydneyDaylight, lessThan(700));
      expect(londonDaylight, greaterThan(sydneyDaylight));
    });
  });
}
