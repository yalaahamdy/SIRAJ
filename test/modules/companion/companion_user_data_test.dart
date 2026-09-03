import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/personal_goal.dart';
import 'package:siraj/modules/companion/domain/personal_habit.dart';
import 'package:siraj/modules/companion/store/companion_user_data_store.dart';

void main() {
  group('L2 Companion User Data & Privacy Isolation Tests (§24, §25)', () {
    late MemoryStorageRegistry registry;
    late CompanionUserDataStore store;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = CompanionUserDataStore(registry: registry);
    });

    test('Saves and retrieves preferences, goals, and habits strictly inside mod_companion namespace', () async {
      await store.savePreferences(const CompanionPreferences(maxDailyCards: 9));
      await store.saveGoals([
        PersonalGoal(
          goalId: 'goal_1',
          type: GoalType.quranReading,
          title: 'قراءة سورة يس',
          target: 1.0,
          unitArabic: 'سورة',
          startDate: DateTime.now(),
          sourceModule: 'mod_companion',
        ),
      ]);
      await store.saveHabits([
        const PersonalHabit(
          habitId: 'habit_1',
          titleArabic: 'سنة الفجر',
          description: 'ركعتان قبل الفريضة',
        ),
      ]);

      final prefsRes = await store.getPreferences();
      final goalsRes = await store.getGoals();
      final habitsRes = await store.getHabits();

      expect(prefsRes.valueOrNull!.maxDailyCards, equals(9));
      expect(goalsRes.valueOrNull!.length, equals(1));
      expect(habitsRes.valueOrNull!.length, equals(1));
    });

    test('resetAllUserData clears strictly mod_companion and leaves other modules untouched', () async {
      final quranStore = registry.getStoreForModule('mod_quran');
      await quranStore.setString('bookmark', 'page_100');

      await store.savePreferences(const CompanionPreferences(maxDailyCards: 12));
      await store.resetAllUserData();

      final prefsRes = await store.getPreferences();
      expect(prefsRes.valueOrNull!.maxDailyCards, equals(7)); // Back to default

      final otherValue = await quranStore.getString('bookmark');
      expect(otherValue.valueOrNull, equals('page_100'));
    });
  });
}
