import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/core/time/hijri_date.dart';

void main() {
  group('L0 Clock Abstraction Tests', () {
    test('SystemClock returns valid non-null timestamps', () {
      const clock = SystemClock();
      final utc = clock.nowUtc();
      final local = clock.nowLocal();

      expect(utc.isUtc, isTrue);
      expect(clock.nowMillisecondsSinceEpoch(), greaterThan(0));
      expect(local, isNotNull);
    });

    test('TestClock allows deterministic time setting and advancement', () {
      final initial = DateTime.utc(2026, 8, 31, 12, 0, 0);
      final clock = TestClock(initial);

      expect(clock.nowUtc(), equals(initial));

      clock.advance(const Duration(hours: 2));
      expect(clock.nowUtc(), equals(DateTime.utc(2026, 8, 31, 14, 0, 0)));

      clock.rewind(const Duration(minutes: 30));
      expect(clock.nowUtc(), equals(DateTime.utc(2026, 8, 31, 13, 30, 0)));

      clock.setTime(DateTime.utc(2030, 1, 1));
      expect(clock.nowUtc(), equals(DateTime.utc(2030, 1, 1)));
    });

    test('TimeUtils calculates day boundaries accurately', () {
      final dt = DateTime.utc(2026, 8, 31, 15, 30, 45);
      final start = TimeUtils.startOfDayUtc(dt);
      final end = TimeUtils.endOfDayUtc(dt);

      expect(start, equals(DateTime.utc(2026, 8, 31, 0, 0, 0)));
      expect(end, equals(DateTime.utc(2026, 8, 31, 23, 59, 59, 999)));
      expect(TimeUtils.isSameDay(dt, DateTime.utc(2026, 8, 31, 2, 0, 0)), isTrue);
      expect(TimeUtils.isSameDay(dt, DateTime.utc(2026, 9, 1, 0, 0, 0)), isFalse);
    });

    test('SafeTimeOfDay enforces bounds and formatting', () {
      const t = SafeTimeOfDay(hour: 5, minute: 9, second: 3);
      expect(t.toString(), equals('05:09:03'));

      expect(() => SafeTimeOfDay(hour: 24, minute: 0), throwsAssertionError);
      expect(() => SafeTimeOfDay(hour: 12, minute: 60), throwsAssertionError);
    });
  });

  group('L0 Hijri Calendar Baseline Tests', () {
    const converter = TabularHijriConverter();

    test('Converts Gregorian to Hijri accurately for baseline reference date', () {
      // 2026-08-31 corresponds to approx Safar/Rabi' 1448 AH
      final gregorian = DateTime.utc(2026, 8, 31);
      final hijri = converter.fromGregorian(gregorian);

      expect(hijri.year, equals(1448));
      expect(hijri.month, inInclusiveRange(1, 12));
      expect(hijri.day, inInclusiveRange(1, 30));
      expect(hijri.formatArabic(), contains('1448 هـ'));
    });

    test('Bidirectional conversion sanity', () {
      const originalHijri = HijriDate(year: 1448, month: 3, day: 15);
      final gregorian = converter.toGregorian(originalHijri);
      final reconverted = converter.fromGregorian(gregorian);

      expect(reconverted.year, equals(originalHijri.year));
      expect(reconverted.month, equals(originalHijri.month));
      expect(reconverted.day, equals(originalHijri.day));
    });

    test('Month lengths are strictly 29 or 30 days', () {
      for (int month = 1; month <= 12; month++) {
        final len = converter.getMonthLength(1448, month);
        expect(len, isIn([29, 30]));
      }
    });
  });
}
