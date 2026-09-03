import 'dart:math';
import '../domain/memorization_item.dart';
import '../domain/memorization_state.dart';
import '../domain/review_quality.dart';
import 'review_scheduler_strategy.dart';

/// Adaptive Spaced Repetition scheduler based on cognitive stability and mastery intervals (§6, §7).
class SpacedRepetitionScheduler implements ReviewSchedulerStrategy {
  final int maxIntervalDays;

  const SpacedRepetitionScheduler({this.maxIntervalDays = 365})
      : assert(maxIntervalDays >= 30, 'Max interval days must be at least 30');

  @override
  MemorizationItem processReview({
    required MemorizationItem item,
    required ReviewQuality quality,
    required DateTime currentDate,
  }) {
    int newInterval;
    int newRepetitions;
    int newLapses;
    double newEase;
    MemorizationState newState;

    switch (quality) {
      case ReviewQuality.again:
        newRepetitions = 0;
        newLapses = item.lapses + 1;
        newInterval = 1;
        newEase = max(1.3, item.easeFactor - 0.2);
        newState = newLapses >= 3 ? MemorizationState.weak : MemorizationState.learning;
        break;

      case ReviewQuality.hard:
        newRepetitions = item.repetitions + 1;
        newLapses = item.lapses;
        newInterval = item.intervalDays <= 1 ? 2 : max(item.intervalDays + 1, (item.intervalDays * 1.2).floor());
        newEase = max(1.3, item.easeFactor - 0.15);
        newState = MemorizationState.inProgress;
        break;

      case ReviewQuality.good:
        newRepetitions = item.repetitions + 1;
        newLapses = item.lapses;
        if (item.intervalDays <= 0) {
          newInterval = 3;
        } else if (item.intervalDays == 1) {
          newInterval = 4;
        } else {
          newInterval = max(item.intervalDays + 1, (item.intervalDays * item.easeFactor).floor());
        }
        newEase = item.easeFactor;
        newState = newInterval >= 21 ? MemorizationState.memorized : MemorizationState.inProgress;
        break;

      case ReviewQuality.easy:
        newRepetitions = item.repetitions + 1;
        newLapses = item.lapses;
        if (item.intervalDays <= 0) {
          newInterval = 5;
        } else if (item.intervalDays == 1) {
          newInterval = 6;
        } else {
          newInterval = max(item.intervalDays + 2, (item.intervalDays * item.easeFactor * 1.3).floor());
        }
        newEase = min(2.5, item.easeFactor + 0.15);
        newState = newInterval >= 30 ? MemorizationState.mastered : MemorizationState.memorized;
        break;
    }

    // Enforce upper bound on interval to prevent date overflow in long-run simulations
    newInterval = min(maxIntervalDays, newInterval);

    // Mastery Score computation (0..100)
    final intervalPart = (newInterval / 30.0 * 50.0).clamp(0.0, 50.0);
    final consistencyPart = (newRepetitions / (newRepetitions + newLapses + 1) * 50.0).clamp(0.0, 50.0);
    final masteryScore = (intervalPart + consistencyPart).clamp(0.0, 100.0);

    final nextDue = calculateNextDueDate(currentDate: currentDate, intervalDays: newInterval);

    return item.copyWith(
      state: newState,
      repetitions: newRepetitions,
      lapses: newLapses,
      easeFactor: newEase,
      intervalDays: newInterval,
      masteryScore: masteryScore,
      lastReviewedAt: currentDate,
      nextReviewDue: nextDue,
      updatedAt: currentDate,
    );
  }

  @override
  DateTime calculateNextDueDate({
    required DateTime currentDate,
    required int intervalDays,
  }) {
    final midnight = DateTime.utc(currentDate.year, currentDate.month, currentDate.day);
    return midnight.add(Duration(days: intervalDays));
  }
}
