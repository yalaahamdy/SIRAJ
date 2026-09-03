import '../../../core/time/clock.dart';
import '../domain/qada_plan.dart';

/// Pure service for managing and projecting Qada fasting distribution (§15, §16).
class QadaPlannerService {
  final Clock _clock;

  const QadaPlannerService({Clock? clock}) : _clock = clock ?? const SystemClock();

  /// Calculates the estimated completion date given the plan's preferred weekdays.
  DateTime? projectCompletionDate({
    required QadaPlan plan,
    DateTime? startDate,
  }) {
    if (plan.remainingDays == 0) return null;
    if (plan.preferredWeekdays.isEmpty) return null;

    var current = startDate ?? _clock.nowUtc();
    var daysLeft = plan.remainingDays;

    while (daysLeft > 0) {
      current = current.add(const Duration(days: 1));
      if (plan.preferredWeekdays.contains(current.weekday)) {
        daysLeft--;
      }
    }

    return current;
  }

  /// Calculates how many weeks are required to complete the remaining Qada days.
  double calculateRequiredWeeks(QadaPlan plan) {
    if (plan.preferredWeekdays.isEmpty || plan.remainingDays == 0) return 0.0;
    return plan.remainingDays / plan.preferredWeekdays.length;
  }

  /// Checks if remaining Qada days can be completed before a target date.
  bool canCompleteBeforeTarget({
    required QadaPlan plan,
    required DateTime targetDate,
    DateTime? startDate,
  }) {
    final projected = projectCompletionDate(plan: plan, startDate: startDate);
    if (projected == null) return true;
    return projected.isBefore(targetDate) || projected.isAtSameMomentAs(targetDate);
  }
}
