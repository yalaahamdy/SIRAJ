import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/engine/astronomical_calculator.dart';

void main() {
  group('L2 Timezone & Fractional Offset Robustness Tests (§8, §11)', () {
    const calculator = AstronomicalPrayerCalculator();

    test('Strict Determinism: repeated calls with same parameters yield identical times', () {
      final date = DateTime.utc(2026, 8, 31);
      const loc = GeoCoordinates(latitude: 24.7136, longitude: 46.6753);
      const params = CalculationParameters.muslimWorldLeague;
      const tz = Duration(hours: 3);

      final run1 = calculator.calculateSchedule(
        date: date,
        location: loc,
        parameters: params,
        timezoneOffset: tz,
      );

      final run2 = calculator.calculateSchedule(
        date: date,
        location: loc,
        parameters: params,
        timezoneOffset: tz,
      );

      expect(run1.isSuccess, isTrue);
      expect(run2.isSuccess, isTrue);
      expect(run1.valueOrNull, equals(run2.valueOrNull));
    });

    test('Fractional timezone offsets (Kathmandu +5:45, Tehran +3:30, Adelaide +9:30)', () {
      final date = DateTime.utc(2026, 8, 31);

      // Kathmandu (+05:45)
      const kathmandu = GeoCoordinates(latitude: 27.7172, longitude: 85.3240);
      final kathmanduRes = calculator.calculateSchedule(
        date: date,
        location: kathmandu,
        parameters: CalculationParameters.karachi,
        timezoneOffset: const Duration(hours: 5, minutes: 45),
      );
      expect(kathmanduRes.isSuccess, isTrue);
      expect(kathmanduRes.valueOrNull!.dhuhr!.time.minute, inInclusiveRange(0, 59));

      // Tehran (+03:30)
      const tehran = GeoCoordinates(latitude: 35.6892, longitude: 51.3890);
      final tehranRes = calculator.calculateSchedule(
        date: date,
        location: tehran,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3, minutes: 30),
      );
      expect(tehranRes.isSuccess, isTrue);

      // Adelaide (+09:30)
      const adelaide = GeoCoordinates(latitude: -34.9285, longitude: 138.6007);
      final adelaideRes = calculator.calculateSchedule(
        date: date,
        location: adelaide,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 9, minutes: 30),
      );
      expect(adelaideRes.isSuccess, isTrue);
    });

    test('1-hour Timezone difference shifts all wall-clock times by exactly 1 hour', () {
      final date = DateTime.utc(2026, 8, 31);
      const loc = GeoCoordinates(latitude: 24.7136, longitude: 46.6753);
      const params = CalculationParameters.muslimWorldLeague;

      final tz3 = calculator.calculateSchedule(
        date: date,
        location: loc,
        parameters: params,
        timezoneOffset: const Duration(hours: 3),
      ).valueOrNull!;

      final tz4 = calculator.calculateSchedule(
        date: date,
        location: loc,
        parameters: params,
        timezoneOffset: const Duration(hours: 4),
      ).valueOrNull!;

      for (final type in [
        PrayerType.fajr,
        PrayerType.sunrise,
        PrayerType.dhuhr,
        PrayerType.asr,
        PrayerType.maghrib,
        PrayerType.isha,
      ]) {
        final t3 = tz3.entries[type]!.time;
        final t4 = tz4.entries[type]!.time;
        expect(t4.difference(t3).inMinutes, equals(60), reason: 'Mismatch on ${type.name}');
      }
    });
  });
}
