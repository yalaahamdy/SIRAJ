import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/zakat/engine/hawl_engine.dart';

void main() {
  group('L2 HawlEngine Time & Maturity Tests (§12)', () {
    final fixedNow = DateTime.utc(2026, 8, 31);
    final clock = TestClock(fixedNow);
    final engine = HawlEngine(clock: clock);

    test('Calculates 354 days for Hijri Hawl and 365 days for Gregorian', () {
      final start = DateTime.utc(2025, 1, 1);

      final hijriDue = engine.calculateHawlDueDate(startDate: start, isHijri: true);
      expect(hijriDue.difference(start).inDays, equals(354));

      final gregDue = engine.calculateHawlDueDate(startDate: start, isHijri: false);
      expect(gregDue.difference(start).inDays, equals(365));
    });

    test('Detects Hawl completed exactly on due date', () {
      final start = DateTime.utc(2025, 1, 1);
      final due = start.add(const Duration(days: 354));

      // 1 day before due
      expect(
        engine.isHawlCompleted(startDate: start, currentTime: due.subtract(const Duration(days: 1))),
        isFalse,
      );
      expect(
        engine.calculateDaysRemaining(startDate: start, currentTime: due.subtract(const Duration(days: 1))),
        equals(1),
      );

      // Exactly on due date
      expect(
        engine.isHawlCompleted(startDate: start, currentTime: due),
        isTrue,
      );
      expect(
        engine.calculateDaysRemaining(startDate: start, currentTime: due),
        equals(0),
      );

      // 1 day after due date
      expect(
        engine.isHawlCompleted(startDate: start, currentTime: due.add(const Duration(days: 1))),
        isTrue,
      );
    });

    test('Calculates Hawl completion progress correctly bounded [0.0, 1.0]', () {
      final start = DateTime.utc(2026, 1, 1);

      // Start of Hawl
      expect(engine.calculateHawlProgress(startDate: start, currentTime: start), equals(0.0));

      // Halfway through Hijri Hawl (177 days)
      final mid = start.add(const Duration(days: 177));
      expect(engine.calculateHawlProgress(startDate: start, currentTime: mid), closeTo(0.5, 0.01));

      // After Hawl completion
      final past = start.add(const Duration(days: 400));
      expect(engine.calculateHawlProgress(startDate: start, currentTime: past), equals(1.0));
    });
  });
}
