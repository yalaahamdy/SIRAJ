import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/release/gates/production_release_gate.dart';
import 'package:siraj/services/bot/release/models/production_release_record.dart';
import 'package:siraj/services/bot/release/services/canary_rollout_manager.dart';
import 'package:siraj/services/bot/release/services/release_automation_service.dart';

void main() {
  group('M21 Release Automation, Canary & Rollback Suite (§4, §20, §22, §57)', () {
    late CanaryRolloutManager canaryManager;
    late ReleaseAutomationService automationService;
    late ProductionReleaseGate releaseGate;

    setUp(() {
      canaryManager = CanaryRolloutManager();
      automationService = ReleaseAutomationService(canaryManager: canaryManager);
      releaseGate = ProductionReleaseGate(automationService: automationService);
    });

    test('State Machine & Gate: Release with PENDING human approval is strictly BLOCKED from Production', () {
      final unapprovedRelease = ProductionReleaseRecord(
        releaseId: 'rel_siraj_1_21_0_rc1',
        codeVersion: '1.21.0',
        contentManifestVersion: 'manifest_v1_0_0',
        policyVersion: 'policy_v1_0',
        modelVersion: 'gemini_grounded_v1',
        configVersion: 'prod_config_v1',
        artifactHashSha256: 'aa11bb22cc33dd44ee55ff6677889900aabbccddeeff00112233445566778899',
        technicalStatus: 'READY',
        humanApprovalStatus: 'PENDING',
        releaseState: ReleaseLifecycleState.externalApprovalPending,
        createdAt: DateTime.now(),
      );

      automationService.registerRelease(unapprovedRelease);

      // Gate evaluation must fail closed
      final gateResult = releaseGate.evaluateReleaseAuthorization(unapprovedRelease.releaseId);
      expect(gateResult.isAllowed, isFalse);
      expect(gateResult.blockerReasonArabic, contains('الاعتماد والترخيص الشرعي'));

      // Direct transition to production must be rejected
      final transitioned = automationService.transitionReleaseState(
        releaseId: unapprovedRelease.releaseId,
        targetState: ReleaseLifecycleState.production,
      );
      expect(transitioned, isFalse);
    });

    test('Canary Rollout: Advances stages properly and rolls back on degraded error rate', () {
      expect(canaryManager.currentTrafficPercentage, equals(0));

      // 0% -> 5%
      canaryManager.advanceStage();
      expect(canaryManager.currentTrafficPercentage, equals(5));

      // 5% -> 25%
      canaryManager.advanceStage();
      expect(canaryManager.currentTrafficPercentage, equals(25));

      // Degraded error rate evaluation
      final action = canaryManager.evaluateCanaryStage(
        errorRate: 0.02, // 2% error rate (exceeds threshold)
        p95LatencyMs: 45.0,
        hasSecurityEvents: false,
      );

      expect(action, equals(CanaryAction.rollback));
      expect(canaryManager.isPaused, isTrue);

      canaryManager.reset();
      expect(canaryManager.currentTrafficPercentage, equals(0));
    });

    test('Automated Rollback: Reverts active release to rollback target and resets traffic', () {
      final v1Good = ProductionReleaseRecord(
        releaseId: 'rel_siraj_1_20_0',
        codeVersion: '1.20.0',
        contentManifestVersion: 'manifest_v1_0_0',
        policyVersion: 'policy_v1_0',
        modelVersion: 'gemini_grounded_v1',
        configVersion: 'prod_config_v1',
        artifactHashSha256: '1111222233334444555566667777888899990000aaaabbbbccccddddeeeeffff',
        technicalStatus: 'READY',
        humanApprovalStatus: 'APPROVED',
        releaseState: ReleaseLifecycleState.approvedForRelease,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      final v2Bad = ProductionReleaseRecord(
        releaseId: 'rel_siraj_1_21_0',
        codeVersion: '1.21.0',
        contentManifestVersion: 'manifest_v1_1_0',
        policyVersion: 'policy_v1_0',
        modelVersion: 'gemini_grounded_v1',
        configVersion: 'prod_config_v2',
        artifactHashSha256: '222233334444555566667777888899990000aaaabbbbccccddddeeeeffff1111',
        technicalStatus: 'READY',
        humanApprovalStatus: 'APPROVED',
        releaseState: ReleaseLifecycleState.approvedForRelease,
        createdAt: DateTime.now(),
        rollbackTarget: 'rel_siraj_1_20_0',
      );

      automationService.registerRelease(v1Good);
      automationService.registerRelease(v2Bad);

      automationService.transitionReleaseState(
        releaseId: v2Bad.releaseId,
        targetState: ReleaseLifecycleState.production,
      );
      expect(automationService.activeProductionReleaseId, equals('rel_siraj_1_21_0'));

      // Trigger automated rollback
      final rolledBack = automationService.executeAutomatedRollback(
        releaseId: v2Bad.releaseId,
        reasonArabic: 'ارتفاع معدل أخطاء الويب هوك في مرحلة الكناري',
      );

      expect(rolledBack, isTrue);
      expect(automationService.activeProductionReleaseId, equals('rel_siraj_1_20_0'));
    });
  });
}
