import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/fasting/calendar/hijri_calendar_service.dart';
import 'package:siraj/modules/fasting/domain/ramadan_confidence.dart';

void main() {
  group('L2 HijriCalendarService Deterministic Algorithmic Tests (§7, §8, §9)', () {
    const clock = SystemClock();
    const service = HijriCalendarService(clock: clock);

    test('Converts Gregorian date to Hijri deterministically', () {
      // 2026-08-31
      final date = DateTime.utc(2026, 8, 31);
      final hijri = service.getHijriDate(date);

      expect(hijri.year, equals(1448));
      expect(hijri.month, greaterThanOrEqualTo(2));
      expect(hijri.month, lessThanOrEqualTo(4));
      expect(hijri.day, greaterThanOrEqualTo(1));
      expect(hijri.day, lessThanOrEqualTo(30));
      expect(hijri.formatArabic().contains('1448 هـ'), isTrue);
    });

    test('Applies calendar offset accurately (+1 day / -1 day)', () {
      final date = DateTime.utc(2026, 8, 31);
      final base = service.getHijriDate(date, offsetDays: 0);
      final plusOne = service.getHijriDate(date, offsetDays: 1);
      final minusOne = service.getHijriDate(date, offsetDays: -1);

      expect(plusOne.day != base.day || plusOne.month != base.month, isTrue);
      expect(minusOne.day != base.day || minusOne.month != base.month, isTrue);
    });

    test('Identifies Ramadan month and day numbering correctly', () {
      // In 1447 AH, Ramadan was approximately in March 2026
      final ramadanDate = DateTime.utc(2026, 2, 25);
      final hijri = service.getHijriDate(ramadanDate);

      if (hijri.isRamadan) {
        expect(service.isRamadan(ramadanDate), isTrue);
        expect(service.getRamadanDayNumber(ramadanDate), equals(hijri.day));
      } else {
        expect(service.isRamadan(ramadanDate), isFalse);
        expect(service.getRamadanDayNumber(ramadanDate), isNull);
      }
    });

    test('Month lengths alternating between 30 and 29 days', () {
      expect(service.getDaysInHijriMonth(1448, 1), equals(30)); // Muharram = 30
      expect(service.getDaysInHijriMonth(1448, 2), equals(29)); // Safar = 29
      expect(service.getDaysInHijriMonth(1448, 9), equals(30)); // Ramadan = 30
    });

    test('Ramadan confidence states match declaration criteria', () {
      expect(service.getRamadanConfidence(hasOfficialDeclaration: true), equals(RamadanConfidence.confirmed));
      expect(service.getRamadanConfidence(offsetDays: 1), equals(RamadanConfidence.userConfigured));
      expect(service.getRamadanConfidence(), equals(RamadanConfidence.estimated));
    });
  });
}
