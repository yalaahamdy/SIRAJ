import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/calculation_status.dart';
import 'package:siraj/modules/prayer/domain/prayer_adjustments.dart';
import 'package:siraj/modules/prayer/engine/astronomical_calculator.dart';

void main() {
  group('L2 Astronomical Prayer Calculator Engine Tests', () {
    const calculator = AstronomicalPrayerCalculator();

    test('Calculates deterministic schedule for Riyadh with Muslim World League params', () {
      final date = DateTime.utc(2026, 8, 31);
      const riyadh = GeoCoordinates(
        latitude: 24.7136,
        longitude: 46.6753,
        source: LocationSource.manual,
      );

      final res = calculator.calculateSchedule(
        date: date,
        location: riyadh,
        parameters: CalculationParameters.muslimWorldLeague,
        timezoneOffset: const Duration(hours: 3),
      );

      expect(res.isSuccess, isTrue);
      final schedule = res.valueOrNull!;

      expect(schedule.status, equals(CalculationStatus.normal));
      expect(schedule.fajr, isNotNull);
      expect(schedule.sunrise, isNotNull);
      expect(schedule.dhuhr, isNotNull);
      expect(schedule.asr, isNotNull);
      expect(schedule.maghrib, isNotNull);
      expect(schedule.isha, isNotNull);

      // Chronological order verification
      expect(schedule.fajr!.time.isBefore(schedule.sunrise!.time), isTrue);
      expect(schedule.sunrise!.time.isBefore(schedule.dhuhr!.time), isTrue);
      expect(schedule.dhuhr!.time.isBefore(schedule.asr!.time), isTrue);
      expect(schedule.asr!.time.isBefore(schedule.maghrib!.time), isTrue);
      expect(schedule.maghrib!.time.isBefore(schedule.isha!.time), isTrue);
    });

    test('Hanafi Asr time is strictly later than Shafi\'i Asr time', () {
      final date = DateTime.utc(2026, 8, 31);
      const cairo = GeoCoordinates(latitude: 30.0444, longitude: 31.2357);

      final shafiiRes = calculator.calculateSchedule(
        date: date,
        location: cairo,
        parameters: CalculationParameters.egyptian.copyWith(
          asrJuristicMethod: AsrJuristicMethod.shafii,
        ),
        timezoneOffset: const Duration(hours: 3),
      );

      final hanafiRes = calculator.calculateSchedule(
        date: date,
        location: cairo,
        parameters: CalculationParameters.egyptian.copyWith(
          asrJuristicMethod: AsrJuristicMethod.hanafi,
        ),
        timezoneOffset: const Duration(hours: 3),
      );

      final shafiiAsr = shafiiRes.valueOrNull!.asr!.time;
      final hanafiAsr = hanafiRes.valueOrNull!.asr!.time;

      expect(hanafiAsr.isAfter(shafiiAsr), isTrue);
      expect(hanafiAsr.difference(shafiiAsr).inMinutes, greaterThan(30));
    });

    test('Applies user adjustments precisely to calculated times while preserving originalTime', () {
      final date = DateTime.utc(2026, 8, 31);
      const makkah = GeoCoordinates(latitude: 21.4225, longitude: 39.8262);

      const adj = PrayerAdjustments(
        fajr: 5,
        dhuhr: -2,
        maghrib: 3,
      );

      final res = calculator.calculateSchedule(
        date: date,
        location: makkah,
        parameters: CalculationParameters.ummAlQura,
        timezoneOffset: const Duration(hours: 3),
        adjustments: adj,
      );

      final schedule = res.valueOrNull!;
      final fajr = schedule.fajr!;
      final dhuhr = schedule.dhuhr!;

      expect(fajr.isAdjusted, isTrue);
      expect(fajr.adjustmentMinutes, equals(5));
      expect(fajr.time.difference(fajr.originalTime).inMinutes, equals(5));

      expect(dhuhr.isAdjusted, isTrue);
      expect(dhuhr.adjustmentMinutes, equals(-2));
      expect(dhuhr.time.difference(dhuhr.originalTime).inMinutes, equals(-2));
    });

    test('GeoCoordinates enforces valid coordinate bounds via assertion', () {
      expect(
        () => GeoCoordinates(latitude: 95.0, longitude: 45.0),
        throwsAssertionError,
      );
      expect(
        () => GeoCoordinates(latitude: 25.0, longitude: 190.0),
        throwsAssertionError,
      );
    });
  });
}
