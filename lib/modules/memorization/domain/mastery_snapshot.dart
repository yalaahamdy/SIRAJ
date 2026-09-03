import 'package:equatable/equatable.dart';

/// Statistical snapshot summarizing overall memorization progress and consistency.
class MasterySnapshot extends Equatable {
  final int totalTargetedAyahs;
  final int notStartedCount;
  final int learningCount;
  final int inProgressCount;
  final int memorizedCount;
  final int masteredCount;
  final int needsReviewCount;
  final int weakCount;
  final double overallMasteryPercent;
  final int currentStreakDays;
  final DateTime snapshotDate;

  const MasterySnapshot({
    required this.totalTargetedAyahs,
    this.notStartedCount = 0,
    this.learningCount = 0,
    this.inProgressCount = 0,
    this.memorizedCount = 0,
    this.masteredCount = 0,
    this.needsReviewCount = 0,
    this.weakCount = 0,
    this.overallMasteryPercent = 0.0,
    this.currentStreakDays = 0,
    required this.snapshotDate,
  });

  int get totalCompletedAyahs => memorizedCount + masteredCount;
  double get completionRate => totalTargetedAyahs > 0
      ? ((memorizedCount + masteredCount) / totalTargetedAyahs * 100).clamp(0.0, 100.0)
      : 0.0;

  @override
  List<Object?> get props => [
        totalTargetedAyahs,
        notStartedCount,
        learningCount,
        inProgressCount,
        memorizedCount,
        masteredCount,
        needsReviewCount,
        weakCount,
        overallMasteryPercent,
        currentStreakDays,
        snapshotDate,
      ];
}
