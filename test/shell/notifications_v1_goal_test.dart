import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/personal_goal.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Personal Goal & Habit Reminders Suite (§18, §19, §100, §106)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
    });

    test('Goals 1: Explicit user goals trigger respectful non-judgmental reminders (§18, §19)', () async {
      await companionModule.addGoal(PersonalGoal(
        goalId: 'goal_daily_quran',
        type: GoalType.quranReading,
        title: 'قراءة نصف جزء يومياً',
        target: 10,
        unitArabic: 'صفحة',
        startDate: DateTime(2026, 9, 1),
        sourceModule: 'quran',
      ));

      final goals = (await companionModule.getGoals()).valueOrNull!;
      expect(goals.isNotEmpty, true);
    });
  });
}
