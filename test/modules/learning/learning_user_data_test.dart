import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/domain/assessment_result.dart';
import 'package:siraj/modules/learning/domain/learning_goal.dart';
import 'package:siraj/modules/learning/domain/revision_item.dart';
import 'package:siraj/modules/learning/store/learning_user_data_store.dart';

void main() {
  group('L2 Learning User Data & Local Privacy Isolation Tests (§31, §32)', () {
    late MemoryStorageRegistry registry;
    late LearningUserDataStore store;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = LearningUserDataStore(storageRegistry: registry);
    });

    test('Saves and retrieves learning completions, assessments, goals, and notes strictly in mod_learning', () async {
      await store.markLessonCompleted('lsn_wudu_pillars', 1);
      await store.toggleBookmark('lsn_wudu_pillars');
      await store.saveUserNote('lsn_wudu_pillars', 'ملاحظتي الخاصة');

      final assessment = AssessmentResult(
        assessmentId: 'a1',
        quizId: 'quiz_1',
        score: 1,
        totalQuestions: 1,
        percentage: 100.0,
        passed: true,
        questionResults: const {'q1': true},
        completedAt: DateTime.now().toUtc(),
      );
      await store.recordAssessmentResult(assessment);

      final goal = LearningGoal(
        goalId: 'g1',
        title: 'هدف',
        startDate: DateTime.now().toUtc(),
      );
      await store.saveGoal(goal);

      final revision = RevisionItem(
        itemId: 'rev_1',
        targetType: RevisionTargetType.lesson,
        targetId: 'lsn_wudu_pillars',
        dueAt: DateTime.now().toUtc().add(const Duration(days: 3)),
      );
      await store.addOrUpdateRevisionItem(revision);

      final progRes = await store.getProgress();
      expect(progRes.isSuccess, isTrue);
      final p = progRes.valueOrNull!;

      expect(p.isLessonCompleted('lsn_wudu_pillars', 1), isTrue);
      expect(p.bookmarkedLessonIds.contains('lsn_wudu_pillars'), isTrue);
      expect(p.userNotes['lsn_wudu_pillars'], equals('ملاحظتي الخاصة'));
      expect(p.assessmentResults.length, equals(1));
      expect(p.learningGoal?.goalId, equals('g1'));
      expect(p.revisionQueue.length, equals(1));
    });

    test('resetAllUserData clears strictly mod_learning and leaves other module stores untouched', () async {
      await store.markLessonCompleted('lsn_1', 1);

      final knowledgeStore = registry.getStoreForModule('mod_knowledge');
      await knowledgeStore.setString('know_key', 'some_val');

      await store.resetAllUserData();

      final pAfter = await store.getProgress();
      expect(pAfter.valueOrNull!.completedLessonVersions, isEmpty);

      final knowVal = await knowledgeStore.getString('know_key');
      expect(knowVal.valueOrNull, equals('some_val')); // Untouched
    });
  });
}
