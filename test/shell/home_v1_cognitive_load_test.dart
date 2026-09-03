import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/dashboard_card.dart';
import 'package:siraj/modules/companion/engine/cognitive_load_guard.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Cognitive Load Guard & Anti-Overload Suite (§11..§14, §84, §114)', () {
    test('Cognitive Load 1: Guard limits dashboard cards to maxDailyCards and respects hiddenCardIds', () {
      const guard = CognitiveLoadGuard();
      const preferences = CompanionPreferences(
        maxDailyCards: 3,
        hiddenCardIds: {'card_3'},
      );

      final rawCards = [
        const DashboardCard(
          cardId: 'card_1',
          section: CardSection.now,
          sourceModule: 'prayer',
          titleArabic: 'الصلاة',
          subtitleArabic: 'الفجر',
          priorityOrder: 0,
        ),
        const DashboardCard(
          cardId: 'card_2',
          section: CardSection.next,
          sourceModule: 'adhkar',
          titleArabic: 'الأذكار',
          subtitleArabic: 'الصباح',
          priorityOrder: 1,
        ),
        const DashboardCard(
          cardId: 'card_3',
          section: CardSection.today,
          sourceModule: 'quran',
          titleArabic: 'القرآن',
          subtitleArabic: 'ورد اليوم',
          priorityOrder: 2,
        ),
        const DashboardCard(
          cardId: 'card_4',
          section: CardSection.continueSection,
          sourceModule: 'learning',
          titleArabic: 'التعلم',
          subtitleArabic: 'درس الوضوء',
          priorityOrder: 3,
        ),
        const DashboardCard(
          cardId: 'card_5',
          section: CardSection.explore,
          sourceModule: 'seerah',
          titleArabic: 'السيرة',
          subtitleArabic: 'الهجرة',
          priorityOrder: 4,
        ),
      ];

      final guarded = guard.guardCards(rawCards: rawCards, preferences: preferences);

      expect(guarded.length, lessThanOrEqualTo(3));
      expect(guarded.any((c) => c.cardId == 'card_3'), false);
    });
  });
}
