import '../domain/memorization_item.dart';
import '../domain/review_quality.dart';

/// Abstract interface for memorization scheduling strategies (§7).
abstract class ReviewSchedulerStrategy {
  /// Computes the updated state, intervals, and due date of a reviewed item.
  MemorizationItem processReview({
    required MemorizationItem item,
    required ReviewQuality quality,
    required DateTime currentDate,
  });

  /// Computes the absolute due date for a given interval.
  DateTime calculateNextDueDate({
    required DateTime currentDate,
    required int intervalDays,
  });
}
