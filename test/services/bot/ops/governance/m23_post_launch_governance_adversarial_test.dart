import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/ops/governance/models/governed_change_proposal.dart';
import 'package:siraj/services/bot/ops/governance/services/ai_evaluation_service.dart';
import 'package:siraj/services/bot/ops/governance/services/corrective_action_registry.dart';
import 'package:siraj/services/bot/ops/governance/services/error_budget_manager.dart';
import 'package:siraj/services/bot/ops/governance/services/governance_change_engine.dart';

void main() {
  group('M23 Post-Launch Governance Adversarial Suite (§3, §20, §37, §95, §103)', () {
    late GovernanceChangeEngine changeEngine;
    late AIEvaluationService aiEvaluationService;
    late ErrorBudgetManager errorBudgetManager;
    late CorrectiveActionRegistry capaRegistry;

    setUp(() {
      changeEngine = GovernanceChangeEngine();
      aiEvaluationService = AIEvaluationService();
      errorBudgetManager = ErrorBudgetManager(monthlyErrorBudget: 0.001);
      capaRegistry = CorrectiveActionRegistry();
    });

    test('Adversarial 1: AI model candidate with degraded grounding (0.95 < 0.995) is BLOCKED from production', () {
      final record = aiEvaluationService.evaluateModelCandidate(
        modelId: 'gemini_test_candidate',
        modelVersion: 'v2.1_unverified',
        provider: 'Google Vertex AI',
        groundingScore: 0.950, // Degraded
        citationScore: 0.998,
        abstentionSafetyScore: 1.0,
        injectionResistanceScore: 1.0,
      );

      expect(record.meetsProductionThresholds, isFalse);
      expect(record.isApprovedForProduction, isFalse);

      final isAuth = aiEvaluationService.isModelAuthorizedForProduction(
        'gemini_test_candidate',
        'v2.1_unverified',
      );
      expect(isAuth, isFalse);
    });

    test('Adversarial 2: Critical governed change requires two approvals; single approval stays underReview', () {
      final proposal = changeEngine.proposeChange(
        titleArabic: 'تحديث سياسة الاسترجاع الكنسي للذكاء الاصطناعي',
        descriptionArabic: 'توسيع نطاق الاسترجاع للمتون الفقهية المقارنة',
        changeType: 'policy',
        riskLevel: ChangeRiskLevel.critical,
        owner: 'AI Governance Lead',
        affectedModules: ['ai_retrieval', 'bot_gateway'],
        blastRadiusDescriptionArabic: 'يؤثر على كافة استعلامات المعرفة',
        rollbackStrategyArabic: 'العودة الفورية لموجهات السياسة السابقة',
      );

      expect(proposal.status, equals(ChangeProposalStatus.proposed));

      // 1st approval
      changeEngine.approveChangeProposal(
        proposalId: proposal.proposalId,
        reviewerName: 'Security Lead',
      );

      final afterFirst = changeEngine.getProposal(proposal.proposalId);
      expect(afterFirst?.status, equals(ChangeProposalStatus.underReview));
      expect(afterFirst?.isApproved, isFalse);

      // 2nd approval
      changeEngine.approveChangeProposal(
        proposalId: proposal.proposalId,
        reviewerName: 'Religious Governance Council',
      );

      final afterSecond = changeEngine.getProposal(proposal.proposalId);
      expect(afterSecond?.status, equals(ChangeProposalStatus.approved));
      expect(afterSecond?.isApproved, isTrue);
    });

    test('Adversarial 3: Exceeding 80% error budget freezes non-critical rollouts', () {
      expect(errorBudgetManager.isNonCriticalRolloutFrozen, isFalse);

      // Burn 85% of budget
      errorBudgetManager.recordErrorBurn(0.00085);

      expect(errorBudgetManager.isNonCriticalRolloutFrozen, isTrue);
      expect(errorBudgetManager.remainingBudgetPercentage, lessThan(20.0));
    });

    test('Adversarial 4: Corrective action item lifecycle correctly transitions to verified and closed', () {
      final action = capaRegistry.registerAction(
        incidentId: 'inc_prod_drill_01',
        owner: 'Platform Lead',
        descriptionArabic: 'إضافة اختبار كشف التراجع لزمن استجابة التلخيص',
        targetDate: DateTime.now().add(const Duration(days: 7)),
      );

      expect(action.status, equals(CorrectiveActionStatus.open));

      final closed = capaRegistry.verifyAndCloseAction(action.actionId);
      expect(closed, isTrue);

      final updated = capaRegistry.items.firstWhere((i) => i.actionId == action.actionId);
      expect(updated.status, equals(CorrectiveActionStatus.verifiedAndClosed));
      expect(updated.verificationDate, isNotNull);
    });
  });
}
