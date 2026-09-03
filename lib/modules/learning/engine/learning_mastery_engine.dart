import '../domain/learning_progress.dart';
import '../store/read_only_learning_store.dart';

/// Bounded, explainable pedagogical mastery breakdown (§21, §41).
class LearningMasterySnapshot {
  final double overallMasteryScore; // 0.0 to 100.0
  final double lessonCompletionFactor; // 0.0 to 100.0
  final double quizPerformanceFactor; // 0.0 to 100.0
  final double revisionHealthFactor; // 0.0 to 100.0
  final int totalLessonsCompleted;
  final int totalQuizzesPassed;
  final int pendingRevisionsCount;

  const LearningMasterySnapshot({
    required this.overallMasteryScore,
    required this.lessonCompletionFactor,
    required this.quizPerformanceFactor,
    required this.revisionHealthFactor,
    required this.totalLessonsCompleted,
    required this.totalQuizzesPassed,
    required this.pendingRevisionsCount,
  });
}

/// Engine calculating bounded, explainable, reversible learning progress indicators (§21, §41).
class LearningMasteryEngine {
  final ReadOnlyLearningStore _store;

  const LearningMasteryEngine({required ReadOnlyLearningStore store}) : _store = store;

  /// Computes pedagogical mastery strictly bounded in [0.0, 100.0] with explainable factors.
  LearningMasterySnapshot computeMastery(LearningProgress progress, {DateTime? now}) {
    final currentTime = now ?? DateTime.now().toUtc();
    final allLessonsRes = _store.getAllLessons();
    final totalCatalogLessons = allLessonsRes.isSuccess ? allLessonsRes.valueOrNull!.length : 0;

    // 1. Lesson Completion Factor (Weight: 40%)
    final completedCount = progress.completedLessonVersions.length;
    final lessonFactor = totalCatalogLessons > 0
        ? ((completedCount / totalCatalogLessons) * 100.0).clamp(0.0, 100.0)
        : 0.0;

    // 2. Quiz Performance Factor (Weight: 40%)
    double quizFactor = 0.0;
    int passedQuizzes = 0;
    if (progress.assessmentResults.isNotEmpty) {
      double totalPercentage = 0.0;
      for (final a in progress.assessmentResults) {
        totalPercentage += a.percentage;
        if (a.passed) passedQuizzes++;
      }
      quizFactor = (totalPercentage / progress.assessmentResults.length).clamp(0.0, 100.0);
    }

    // 3. Revision Health Factor (Weight: 20%)
    double revisionFactor = completedCount > 0 ? 100.0 : 0.0;
    int pendingRevisions = 0;
    if (progress.revisionQueue.isNotEmpty) {
      int overdueCount = 0;
      for (final r in progress.revisionQueue) {
        if (r.dueAt.isBefore(currentTime)) {
          overdueCount++;
          pendingRevisions++;
        }
      }
      final overdueRatio = overdueCount / progress.revisionQueue.length;
      revisionFactor = ((1.0 - overdueRatio) * 100.0).clamp(0.0, 100.0);
    }

    // Overall Weighted Score
    final rawOverall = (lessonFactor * 0.40) + (quizFactor * 0.40) + (revisionFactor * 0.20);
    final overallScore = rawOverall.clamp(0.0, 100.0);

    return LearningMasterySnapshot(
      overallMasteryScore: overallScore,
      lessonCompletionFactor: lessonFactor,
      quizPerformanceFactor: quizFactor,
      revisionHealthFactor: revisionFactor,
      totalLessonsCompleted: completedCount,
      totalQuizzesPassed: passedQuizzes,
      pendingRevisionsCount: pendingRevisions,
    );
  }
}
