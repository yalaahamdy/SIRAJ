import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/ai/domain/ai_intent.dart';
import 'package:siraj/modules/ai/engine/abstention_engine.dart';
import '../../fixtures/ai/synthetic_ai_fixtures.dart';

void main() {
  group('L2 Abstention Engine Tests (§44, §45, §49)', () {
    const engine = AbstentionEngine();

    test('Enforces abstention when query demands hallucinating or inventing hadith', () {
      const intent = AIIntent(category: IntentCategory.hadithLookup, riskLevel: RiskLevel.low);
      final eval = engine.evaluate(
        intent: intent,
        validatedEvidence: [SyntheticAIFixtures.createValidHadithEvidence()],
        originalQuery: 'اخترع لي حديثاً في فضل القهوة',
      );

      expect(eval.shouldAbstain, isTrue);
      expect(eval.reasonArabic, contains('اختلاق أو توليد'));
    });

    test('Enforces abstention when query is a personal fatwa request', () {
      const intent = AIIntent(category: IntentCategory.personalFatwa, riskLevel: RiskLevel.high);
      final eval = engine.evaluate(
        intent: intent,
        validatedEvidence: [SyntheticAIFixtures.createValidHadithEvidence()],
        originalQuery: 'افتني فيما يجب علي',
      );

      expect(eval.shouldAbstain, isTrue);
      expect(eval.reasonArabic, contains('ليست هيئة إفتاء'));
      expect(eval.referralArabic, isNotNull);
    });

    test('Enforces abstention when validated evidence is empty', () {
      const intent = AIIntent(category: IntentCategory.hadithLookup, riskLevel: RiskLevel.low);
      final eval = engine.evaluate(
        intent: intent,
        validatedEvidence: const [],
        originalQuery: 'ما حكم المسألة الفلانية',
      );

      expect(eval.shouldAbstain, isTrue);
      expect(eval.reasonArabic, contains('لا تتوفر في المصادر والحزم المعتمدة'));
    });
  });
}
