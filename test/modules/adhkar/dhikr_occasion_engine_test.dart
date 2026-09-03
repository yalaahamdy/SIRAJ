import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/modules/adhkar/services/dhikr_occasion_engine.dart';

void main() {
  group('L2 DhikrOccasionEngine Time & Context Resolution Tests (§14, §15)', () {
    test('Resolves correct occasion deterministically based on injected clock hours', () {
      // Morning at 07:00
      final morningClock = TestClock(DateTime.utc(2026, 8, 31, 7, 0));
      final engineMorning = DhikrOccasionEngine(clock: morningClock);
      expect(engineMorning.resolveCurrentOccasion(), equals(DhikrOccasion.morning));

      // Midday / After Prayer at 13:00
      final middayClock = TestClock(DateTime.utc(2026, 8, 31, 13, 0));
      final engineMidday = DhikrOccasionEngine(clock: middayClock);
      expect(engineMidday.resolveCurrentOccasion(), equals(DhikrOccasion.afterPrayer));

      // Evening at 17:00
      final eveningClock = TestClock(DateTime.utc(2026, 8, 31, 17, 0));
      final engineEvening = DhikrOccasionEngine(clock: eveningClock);
      expect(engineEvening.resolveCurrentOccasion(), equals(DhikrOccasion.evening));

      // Night / Sleep at 23:00
      final sleepClock = TestClock(DateTime.utc(2026, 8, 31, 23, 0));
      final engineSleep = DhikrOccasionEngine(clock: sleepClock);
      expect(engineSleep.resolveCurrentOccasion(), equals(DhikrOccasion.sleep));
    });

    test('getDailyOccasionsOrder places current occasion at the front of the list', () {
      final clock = TestClock(DateTime.utc(2026, 8, 31, 6, 30));
      final engine = DhikrOccasionEngine(clock: clock);
      final list = engine.getDailyOccasionsOrder();

      expect(list.first, equals(DhikrOccasion.morning));
      expect(list.length, equals(DhikrOccasion.values.length));
    });
  });
}
