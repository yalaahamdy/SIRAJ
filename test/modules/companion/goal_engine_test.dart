import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/domain/personal_goal.dart';
import 'package:siraj/modules/companion/engine/goal_engine.dart';
import 'package:siraj/modules/companion/store/companion_user_data_store.dart';

void main() {
  group('L2 Personal Goal Engine Tests (§14, §15)', () {
    late MemoryStorageRegistry registry;
    late CompanionUserDataStore store;
    late GoalEngine engine;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = CompanionUserDataStore(registry: registry);
      engine = GoalEngine(store: store);
    });

    test('Adds user goal, updates progress, and transitions status to completed upon reaching target', () async {
      final goal = PersonalGoal(
        goalId: 'goal_test_quran',
        type: GoalType.quranReading,
        title: 'قراءة 20 صفحة يومياً',
        target: 20.0,
        currentProgress: 0.0,
        unitArabic: 'صفحة',
        startDate: DateTime.now(),
        sourceModule: 'mod_companion',
      );

      final addRes = await engine.addGoal(goal);
      expect(addRes.isSuccess, isTrue);

      final updateRes1 = await engine.updateProgress('goal_test_quran', 10.0);
      expect(updateRes1.isSuccess, isTrue);
      expect(updateRes1.valueOrNull!.currentProgress, equals(10.0));
      expect(updateRes1.valueOrNull!.status, equals(GoalStatus.active));

      final updateRes2 = await engine.updateProgress('goal_test_quran', 10.0);
      expect(updateRes2.isSuccess, isTrue);
      expect(updateRes2.valueOrNull!.currentProgress, equals(20.0));
      expect(updateRes2.valueOrNull!.status, equals(GoalStatus.completed));
    });

    test('Pauses, resumes, and deletes goals deterministically', () async {
      final goal = PersonalGoal(
        goalId: 'goal_test_memorize',
        type: GoalType.memorization,
        title: 'حفظ سورة الكهف',
        target: 110.0,
        unitArabic: 'آية',
        startDate: DateTime.now(),
        sourceModule: 'mod_companion',
      );

      await engine.addGoal(goal);
      await engine.setGoalStatus('goal_test_memorize', GoalStatus.paused);

      final activeGoalsRes = await engine.getActiveGoals();
      expect(activeGoalsRes.isSuccess, isTrue);
      expect(activeGoalsRes.valueOrNull!.isEmpty, isTrue);

      await engine.deleteGoal('goal_test_memorize');
      final allGoalsRes = await store.getGoals();
      expect(allGoalsRes.valueOrNull!.isEmpty, isTrue);
    });
  });
}
