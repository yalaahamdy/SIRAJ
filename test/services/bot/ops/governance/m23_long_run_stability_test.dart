import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/ops/governance/models/feature_lifecycle_record.dart';
import 'package:siraj/services/bot/ops/governance/services/ai_evaluation_service.dart';
import 'package:siraj/services/bot/ops/governance/services/error_budget_manager.dart';

void main() {
  group('M23 Long-Run System Stability & Lifecycle Simulation Suite (§9, §10, §42, §104)', () {
    test('Stability 1: Feature lifecycle state machine progresses properly through full lifetime', () {
      var feature = FeatureLifecycleRecord(
        featureKey: 'companion_voice_notes',
        nameArabic: 'الملاحظات الصوتية للرفيق',
        owner: 'UX Team',
        state: FeatureState.proposed,
        associatedModule: 'companion',
        introducedAt: DateTime(2026, 1, 1),
      );

      expect(feature.isActive, isFalse);

      feature = feature.copyWith(state: FeatureState.experimental);
      expect(feature.isActive, isTrue);

      feature = feature.copyWith(state: FeatureState.beta);
      expect(feature.isActive, isTrue);

      feature = feature.copyWith(state: FeatureState.stable);
      expect(feature.isActive, isTrue);

      feature = feature.copyWith(
        state: FeatureState.deprecated,
        deprecatedAt: DateTime(2027, 1, 1),
        deprecationMigrationGuideArabic: 'يرجى الانتقال للملاحظات النصية المهيكلة',
      );
      expect(feature.isActive, isFalse);
      expect(feature.deprecationMigrationGuideArabic, isNotNull);

      feature = feature.copyWith(state: FeatureState.removed);
      expect(feature.state, equals(FeatureState.removed));
    });

    test('Stability 2: Multi-month continuous operations maintain zero degradation in AI governance and SLO tracking', () {
      final aiService = AIEvaluationService();
      final budgetManager = ErrorBudgetManager(monthlyErrorBudget: 0.001);

      // Month 1: Model v1 evaluation & healthy cycle
      final modelV1 = aiService.evaluateModelCandidate(
        modelId: 'gemini_grounded',
        modelVersion: 'v1.0.0',
        provider: 'Google Vertex AI',
        groundingScore: 0.998,
        citationScore: 0.999,
        abstentionSafetyScore: 1.0,
        injectionResistanceScore: 1.0,
      );
      expect(modelV1.meetsProductionThresholds, isTrue);
      expect(aiService.isModelAuthorizedForProduction('gemini_grounded', 'v1.0.0'), isTrue);

      budgetManager.recordErrorBurn(0.0001); // 10% burned
      expect(budgetManager.isNonCriticalRolloutFrozen, isFalse);

      // Month 2: Reset cycle and Model v2 upgrade
      budgetManager.resetMonthlyCycle();
      expect(budgetManager.consumedErrorBudget, equals(0.0));

      final modelV2 = aiService.evaluateModelCandidate(
        modelId: 'gemini_grounded',
        modelVersion: 'v2.0.0',
        provider: 'Google Vertex AI',
        groundingScore: 0.999,
        citationScore: 1.0,
        abstentionSafetyScore: 1.0,
        injectionResistanceScore: 1.0,
      );
      expect(modelV2.meetsProductionThresholds, isTrue);
      expect(aiService.isModelAuthorizedForProduction('gemini_grounded', 'v2.0.0'), isTrue);

      expect(aiService.evaluatedModels.length, equals(2));
    });
  });
}
