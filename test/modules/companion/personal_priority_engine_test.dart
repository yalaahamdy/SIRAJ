import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/dashboard_card.dart';
import 'package:siraj/modules/companion/domain/module_status.dart';
import 'package:siraj/modules/companion/engine/personal_priority_engine.dart';

void main() {
  group('L2 Personal Priority Engine Tests (§10, §11)', () {
    const engine = PersonalPriorityEngine();

    test('Prioritizes active Hajj journey and Prayer cards at the top when active', () {
      final statuses = [
        ModuleStatusSummary(
          moduleId: 'hajj',
          moduleTitleArabic: 'الحج والعمرة',
          status: ModuleAvailabilityStatus.available,
          dueCount: 1,
          progressSummary: 'رحلة نسك جارية',
          timestamp: DateTime.now(),
        ),
        ModuleStatusSummary(
          moduleId: 'prayer',
          moduleTitleArabic: 'مواقيت الصلاة',
          status: ModuleAvailabilityStatus.available,
          progressSummary: 'أذان الظهر بعد 15 دقيقة',
          timestamp: DateTime.now(),
        ),
        ModuleStatusSummary(
          moduleId: 'quran',
          moduleTitleArabic: 'المصحف الشريف',
          status: ModuleAvailabilityStatus.available,
          progressSummary: 'سورة البقرة صفحة 12',
          timestamp: DateTime.now(),
        ),
      ];

      final cards = engine.buildDashboard(
        moduleStatuses: statuses,
        activeGoals: const [],
        preferences: const CompanionPreferences(),
        currentTime: DateTime(2026, 8, 31, 12, 0),
      );

      expect(cards.isNotEmpty, isTrue);
      expect(cards.first.cardId, equals('card_active_hajj_journey'));
      expect(cards.first.section, equals(CardSection.now));
      expect(cards[1].cardId, equals('card_prayer_now'));
    });

    test('Switches contextual Adhkar card between Morning and Evening based on current time', () {
      final morningCards = engine.buildDashboard(
        moduleStatuses: const [],
        activeGoals: const [],
        preferences: const CompanionPreferences(),
        currentTime: DateTime(2026, 8, 31, 8, 0), // 8 AM
      );

      final eveningCards = engine.buildDashboard(
        moduleStatuses: const [],
        activeGoals: const [],
        preferences: const CompanionPreferences(),
        currentTime: DateTime(2026, 8, 31, 18, 0), // 6 PM
      );

      final morningAdhkar = morningCards.firstWhere((c) => c.cardId == 'card_adhkar_contextual');
      final eveningAdhkar = eveningCards.firstWhere((c) => c.cardId == 'card_adhkar_contextual');

      expect(morningAdhkar.titleArabic, equals('أذكار الصباح'));
      expect(eveningAdhkar.titleArabic, equals('أذكار المساء'));
    });
  });
}
