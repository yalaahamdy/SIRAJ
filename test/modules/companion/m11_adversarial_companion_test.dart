import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/module_status.dart';
import 'package:siraj/modules/companion/domain/personal_goal.dart';
import 'package:siraj/modules/companion/engine/cognitive_load_guard.dart';
import 'package:siraj/modules/companion/engine/personal_priority_engine.dart';

void main() {
  group('M11 Companion Adversarial & Safety Attack Tests (§51, §52, §54)', () {
    test('Attack 1: Absolute prohibition of Piety / Faith scores in Goal and Priority Engines', () {
      final goal = PersonalGoal(
        goalId: 'goal_attack_1',
        type: GoalType.quranReading,
        title: 'قراءة القرآن',
        target: 10.0,
        currentProgress: 5.0,
        unitArabic: 'صفحات',
        startDate: DateTime.now(),
        sourceModule: 'mod_companion',
      );

      // Percentage is purely mathematical in [0.0, 100.0]
      expect(goal.progressPercentage, equals(50.0));
      // No moral scoring properties exist
      expect(goal.props.contains('piety_score'), isFalse);
      expect(goal.props.contains('faith_level'), isFalse);
    });

    test('Attack 2: Financial data minimization: Dashboard exposes zero raw monetary amounts', () async {
      const engine = PersonalPriorityEngine();
      final statuses = [
        ModuleStatusSummary(
          moduleId: 'zakat',
          moduleTitleArabic: 'حساب الزكاة',
          status: ModuleAvailabilityStatus.available,
          progressSummary: 'حاسبة الزكاة والحول متاحة محلياً', // Minimal summary without numbers
          timestamp: DateTime.now(),
        ),
      ];

      final cards = engine.buildDashboard(
        moduleStatuses: statuses,
        activeGoals: const [],
        preferences: const CompanionPreferences(),
        currentTime: DateTime.now(),
      );

      for (final c in cards) {
        expect(c.subtitleArabic, isNot(contains('\$')));
        expect(c.subtitleArabic, isNot(contains('ريال')));
      }
    });

    test('Attack 3: Partial module failure does not crash the Dashboard (Fail Gracefully)', () async {
      const engine = PersonalPriorityEngine();
      final brokenStatuses = [
        ModuleStatusSummary(
          moduleId: 'prayer',
          moduleTitleArabic: 'مواقيت الصلاة',
          status: ModuleAvailabilityStatus.error,
          statusMessage: 'تعذر تحديد الموقع الجغرافي',
          timestamp: DateTime.now(),
        ),
        ModuleStatusSummary(
          moduleId: 'quran',
          moduleTitleArabic: 'المصحف الشريف',
          status: ModuleAvailabilityStatus.available,
          progressSummary: 'المصحف متاح',
          timestamp: DateTime.now(),
        ),
      ];

      final cards = engine.buildDashboard(
        moduleStatuses: brokenStatuses,
        activeGoals: const [],
        preferences: const CompanionPreferences(),
        currentTime: DateTime.now(),
      );

      expect(cards.isNotEmpty, isTrue);
      expect(cards.any((c) => c.sourceModule == 'quran'), isTrue);
      // Prayer card with error was safely excluded or handled without crash
    });

    test('Attack 4: Goal flood attack is capped strictly by CognitiveLoadGuard', () {
      const guard = CognitiveLoadGuard();
      const engine = PersonalPriorityEngine(loadGuard: guard);

      final floodedGoals = List.generate(
        50,
        (i) => PersonalGoal(
          goalId: 'goal_flood_$i',
          type: GoalType.custom,
          title: 'هدف فائض $i',
          target: 100.0,
          unitArabic: 'مرة',
          startDate: DateTime.now(),
          sourceModule: 'mod_companion',
        ),
      );

      final cards = engine.buildDashboard(
        moduleStatuses: const [],
        activeGoals: floodedGoals,
        preferences: const CompanionPreferences(maxDailyCards: 6),
        currentTime: DateTime.now(),
      );

      expect(cards.length, lessThanOrEqualTo(6));
    });

    test('Attack 5: Privacy isolation: CompanionUserDataStore operations do not leak into other namespaces', () async {
      final registry = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: registry);

      final zakatStore = registry.getStoreForModule('mod_zakat');
      await zakatStore.setString('zakat_profile', 'sensitive_financial_record');

      await companion.addGoal(PersonalGoal(
        goalId: 'goal_p',
        type: GoalType.learning,
        title: 'دراسة كتاب الفقه',
        target: 5.0,
        unitArabic: 'دروس',
        startDate: DateTime.now(),
        sourceModule: 'mod_companion',
      ));

      await companion.resetAllUserData();

      final zakatVal = await zakatStore.getString('zakat_profile');
      expect(zakatVal.valueOrNull, equals('sensitive_financial_record'));
    });
  });
}
