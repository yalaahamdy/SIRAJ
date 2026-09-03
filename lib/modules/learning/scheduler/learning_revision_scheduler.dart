import 'dart:math';
import '../domain/revision_item.dart';

/// Independent, decoupled Spaced Repetition scheduler for learning retention (§22, §23).
class LearningRevisionScheduler {
  static const double minimumEaseFactor = 1.3;
  static const int maximumIntervalDays = 365;

  const LearningRevisionScheduler();

  /// Calculates next review interval and updated ease factor based on review quality [1..5].
  RevisionItem scheduleNextReview({
    required RevisionItem current,
    required int quality, // 1 (Again), 3 (Hard), 4 (Good), 5 (Easy)
    DateTime? now,
  }) {
    final baseTime = now ?? DateTime.now().toUtc();
    final clampedQuality = quality.clamp(1, 5);

    if (clampedQuality < 3) {
      // Failed review: Reset interval to 1 day, slightly reduce ease factor
      final newEase = max(minimumEaseFactor, current.easeFactor - 0.2);
      return current.copyWith(
        repetitionCount: 0,
        intervalDays: 1,
        easeFactor: newEase,
        lastQuality: clampedQuality,
        dueAt: baseTime.add(const Duration(days: 1)),
      );
    }

    // Successful review: Calculate progressive intervals
    int nextInterval;
    if (current.repetitionCount == 0) {
      nextInterval = 1;
    } else if (current.repetitionCount == 1) {
      nextInterval = 3;
    } else if (current.repetitionCount == 2) {
      nextInterval = 7;
    } else {
      nextInterval = min(
        maximumIntervalDays,
        max(1, (current.intervalDays * current.easeFactor).round()),
      );
    }

    // SM-2 Ease Factor calculation
    final deltaEase = 0.1 - (5 - clampedQuality) * (0.08 + (5 - clampedQuality) * 0.02);
    final updatedEase = max(minimumEaseFactor, current.easeFactor + deltaEase);

    return current.copyWith(
      repetitionCount: current.repetitionCount + 1,
      intervalDays: nextInterval,
      easeFactor: updatedEase,
      lastQuality: clampedQuality,
      dueAt: baseTime.add(Duration(days: nextInterval)),
    );
  }
}
