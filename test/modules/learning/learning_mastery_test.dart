import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/learning/domain/assessment_result.dart';
import 'package:siraj/modules/learning/domain/learning_progress.dart';
import 'package:siraj/modules/learning/domain/revision_item.dart';
import 'package:siraj/modules/learning/engine/learning_mastery_engine.dart';
import 'package:siraj/modules/learning/store/read_only_learning_store.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('L2 Learning Mastery & Mathematical Invariants Tests (§21, §41)', () {
    late ReadOnlyLearningStore store;
    late LearningMasteryEngine engine;

    setUp(() {
      store = ReadOnlyLearningStore();
      engine = LearningMasteryEngine(store: store);
      final pkg = SyntheticLearningFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('Mastery score is strictly bounded in [0.0, 100.0] for empty progress', () {
      final emptyProgress = LearningProgress(updatedAt: DateTime.now().toUtc());
      final snapshot = engine.computeMastery(emptyProgress);

      expect(snapshot.overallMasteryScore >= 0.0, isTrue);
      expect(snapshot.overallMasteryScore <= 100.0, isTrue);
      expect(snapshot.lessonCompletionFactor, equals(0.0));
      expect(snapshot.quizPerformanceFactor, equals(0.0));
    });

    test('Mastery score increases predictably upon completing lessons and quizzes', () {
      final assessment = AssessmentResult(
        assessmentId: 'a1',
        quizId: 'quiz_wudu_1',
        score: 1,
        totalQuestions: 1,
        percentage: 100.0,
        passed: true,
        questionResults: const {'q1': true},
        completedAt: DateTime.now().toUtc(),
      );

      final progress = LearningProgress(
        completedLessonVersions: const {'lsn_wudu_pillars': 1},
        assessmentResults: [assessment],
        updatedAt: DateTime.now().toUtc(),
      );

      final snapshot = engine.computeMastery(progress);
      expect(snapshot.lessonCompletionFactor, equals(100.0));
      expect(snapshot.quizPerformanceFactor, equals(100.0));
      expect(snapshot.overallMasteryScore, equals(100.0));
    });

    test('Mastery score is reversible: Overdue revision items decrease revision health and overall score', () {
      final overdueRevision = RevisionItem(
        itemId: 'rev_1',
        targetType: RevisionTargetType.lesson,
        targetId: 'lsn_wudu_pillars',
        dueAt: DateTime.now().toUtc().subtract(const Duration(days: 5)), // Overdue
      );

      final progress = LearningProgress(
        completedLessonVersions: const {'lsn_wudu_pillars': 1},
        revisionQueue: [overdueRevision],
        updatedAt: DateTime.now().toUtc(),
      );

      final snapshot = engine.computeMastery(progress);
      expect(snapshot.revisionHealthFactor, equals(0.0));
      expect(snapshot.overallMasteryScore < 100.0, isTrue);
    });
  });
}
