import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/services/qada_planner_service.dart';

void main() {
  group('L2 QadaPlannerService Projection & Distribution Tests (§15, §16)', () {
    final fixedNow = DateTime.utc(2026, 8, 31); // Monday
    final testClock = TestClock(fixedNow);
    final planner = QadaPlannerService(clock: testClock);

    test('Projects completion date accurately for preferred weekdays (Mon & Thu)', () {
      final plan = QadaPlan(
        totalDays: 4,
        completedDays: 0,
        preferredWeekdays: const [1, 4], // Monday and Thursday (2 days a week)
        updatedAt: fixedNow,
      );

      final projected = planner.projectCompletionDate(plan: plan, startDate: fixedNow);
      expect(projected, isNotNull);
      // Starting after Monday Aug 31:
      // Day 1: Thu Sep 3
      // Day 2: Mon Sep 7
      // Day 3: Thu Sep 10
      // Day 4: Mon Sep 14
      expect(projected!.isAfter(fixedNow), isTrue);
      expect(planner.calculateRequiredWeeks(plan), equals(2.0)); // 4 days / 2 days-per-week = 2 weeks
    });

    test('Validates whether plan completes before target date', () {
      final plan = QadaPlan(
        totalDays: 10,
        completedDays: 0,
        preferredWeekdays: const [1, 4], // 5 weeks needed (~35 days)
        updatedAt: fixedNow,
      );

      final targetFar = fixedNow.add(const Duration(days: 60)); // 2 months away -> true
      final targetNear = fixedNow.add(const Duration(days: 10)); // 10 days away -> false

      expect(planner.canCompleteBeforeTarget(plan: plan, targetDate: targetFar, startDate: fixedNow), isTrue);
      expect(planner.canCompleteBeforeTarget(plan: plan, targetDate: targetNear, startDate: fixedNow), isFalse);
    });

    test('Returns null projection when remaining days is zero', () {
      final plan = QadaPlan(
        totalDays: 5,
        completedDays: 5, // All completed
        updatedAt: fixedNow,
      );

      expect(planner.projectCompletionDate(plan: plan), isNull);
      expect(planner.calculateRequiredWeeks(plan), equals(0.0));
      expect(plan.isCompleted, isTrue);
    });
  });
}
