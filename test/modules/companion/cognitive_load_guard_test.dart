import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/dashboard_card.dart';
import 'package:siraj/modules/companion/engine/cognitive_load_guard.dart';

void main() {
  group('L2 Cognitive Load Guard Tests (§32)', () {
    const guard = CognitiveLoadGuard();

    test('Caps cards to maxDailyCards preference and filters out hidden cards', () {
      final rawCards = List.generate(
        15,
        (i) => DashboardCard(
          cardId: 'card_$i',
          section: CardSection.today,
          sourceModule: 'module_$i',
          titleArabic: 'بطاقة $i',
          subtitleArabic: 'وصف $i',
          priorityOrder: i,
        ),
      );

      final guarded = guard.guardCards(
        rawCards: rawCards,
        preferences: const CompanionPreferences(
          maxDailyCards: 5,
          hiddenCardIds: {'card_0'}, // Hide top card
        ),
      );

      expect(guarded.length, equals(5));
      expect(guarded.any((c) => c.cardId == 'card_0'), isFalse);
      expect(guarded.first.cardId, equals('card_1'));
    });
  });
}
