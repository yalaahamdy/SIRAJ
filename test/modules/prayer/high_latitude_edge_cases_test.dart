import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/calculation_status.dart';
import 'package:siraj/modules/prayer/engine/astronomical_calculator.dart';

void main() {
  group('L2 High Latitude & Polar Boundary Edge Cases (§9, §22, §27)', () {
    const calculator = AstronomicalPrayerCalculator();

    test('London in mid-summer (June 21) with 19.5° Fajr triggers HighLatitude fallback without guessing', () {
      final summerSolstice = DateTime.utc(2026, 6, 21);
      const london = GeoCoordinates(latitude: 51.5074, longitude: -0.1278);

      final res = calculator.calculateSchedule(
        date: summerSolstice,
        location: london,
        parameters: CalculationParameters.egyptian.copyWith(
          highLatitudeRule: HighLatitudeRule.middleOfTheNight,
        ),
        timezoneOffset: const Duration(hours: 1),
      );

      expect(res.isSuccess, isTrue);
      final schedule = res.valueOrNull!;

      expect(schedule.status, equals(CalculationStatus.highLatitudeRuleApplied));
      expect(schedule.fajr, isNotNull);
      expect(schedule.fajr!.time.isBefore(schedule.sunrise!.time), isTrue);
    });

    test('Extreme Polar Region in summer (e.g. Tromso, 69.6° N on June 21) safely returns requiresConfig', () {
      final summerSolstice = DateTime.utc(2026, 6, 21);
      const tromso = GeoCoordinates(latitude: 69.6492, longitude: 18.9553);

      final res = calculator.calculateSchedule(
        date: summerSolstice,
        location: tromso,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 2),
      );

      expect(res.isSuccess, isTrue);
      final schedule = res.valueOrNull!;

      // In midnight sun, sun does not set, so calculation requires explicit juristic config
      expect(schedule.status, equals(CalculationStatus.requiresConfig));
      expect(schedule.entries, isEmpty); // Does NOT guess fake numbers
    });
  });
}
