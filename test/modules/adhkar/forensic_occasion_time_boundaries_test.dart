import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/modules/adhkar/services/dhikr_occasion_engine.dart';

void main() {
  group('M4 Forensic Occasion Boundaries & Timezone Safety Tests (§10, §11, §12)', () {
    test('Boundary test: Transitions precisely at hour cuts', () {
      // 03:59:59 -> Sleep
      final clock1 = TestClock(DateTime.utc(2026, 8, 31, 3, 59, 59));
      expect(DhikrOccasionEngine(clock: clock1).resolveCurrentOccasion(), equals(DhikrOccasion.sleep));

      // 04:00:00 -> Morning
      final clock2 = TestClock(DateTime.utc(2026, 8, 31, 4, 0, 0));
      expect(DhikrOccasionEngine(clock: clock2).resolveCurrentOccasion(), equals(DhikrOccasion.morning));

      // 11:59:59 -> Morning
      final clock3 = TestClock(DateTime.utc(2026, 8, 31, 11, 59, 59));
      expect(DhikrOccasionEngine(clock: clock3).resolveCurrentOccasion(), equals(DhikrOccasion.morning));

      // 12:00:00 -> After Prayer
      final clock4 = TestClock(DateTime.utc(2026, 8, 31, 12, 0, 0));
      expect(DhikrOccasionEngine(clock: clock4).resolveCurrentOccasion(), equals(DhikrOccasion.afterPrayer));

      // 14:59:59 -> After Prayer
      final clock5 = TestClock(DateTime.utc(2026, 8, 31, 14, 59, 59));
      expect(DhikrOccasionEngine(clock: clock5).resolveCurrentOccasion(), equals(DhikrOccasion.afterPrayer));

      // 15:00:00 -> Evening
      final clock6 = TestClock(DateTime.utc(2026, 8, 31, 15, 0, 0));
      expect(DhikrOccasionEngine(clock: clock6).resolveCurrentOccasion(), equals(DhikrOccasion.evening));

      // 20:59:59 -> Evening
      final clock7 = TestClock(DateTime.utc(2026, 8, 31, 20, 59, 59));
      expect(DhikrOccasionEngine(clock: clock7).resolveCurrentOccasion(), equals(DhikrOccasion.evening));

      // 21:00:00 -> Sleep
      final clock8 = TestClock(DateTime.utc(2026, 8, 31, 21, 0, 0));
      expect(DhikrOccasionEngine(clock: clock8).resolveCurrentOccasion(), equals(DhikrOccasion.sleep));
    });

    test('Midnight rollover test: 23:59:59 -> 00:00:00 -> 00:00:01 stays in Sleep without disruption', () {
      final clock = TestClock(DateTime.utc(2026, 8, 31, 23, 59, 59));
      final engine = DhikrOccasionEngine(clock: clock);

      expect(engine.resolveCurrentOccasion(), equals(DhikrOccasion.sleep));

      // Advance 1 second to midnight
      clock.advance(const Duration(seconds: 1));
      expect(engine.resolveCurrentOccasion(), equals(DhikrOccasion.sleep));

      // Advance 1 second past midnight
      clock.advance(const Duration(seconds: 1));
      expect(engine.resolveCurrentOccasion(), equals(DhikrOccasion.sleep));
    });
  });
}
