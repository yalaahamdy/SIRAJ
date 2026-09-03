import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/ops/live/gates/production_authorization_gate.dart';
import 'package:siraj/services/bot/ops/live/models/production_authorization.dart';

void main() {
  group('M22 Production Safety & Authorization Gate Suite (§6, §7, §82)', () {
    const gate = ProductionAuthorizationGate();

    test('Gate Check 1: Null or empty authorization is strictly BLOCKED', () {
      final result = gate.evaluateAuthorization(null);
      expect(result.isAuthorized, isFalse);
      expect(result.rejectionReasonArabic, contains('لا يوجد سجل ترخيص'));
    });

    test('Gate Check 2: Technical Ready but Human Religious Approval PENDING is BLOCKED', () {
      const auth = ProductionAuthorization(
        authorizationId: 'auth_siraj_prod_001',
        releaseId: 'rel_siraj_1_22_0',
        technicalApproval: true,
        contentApproval: false, // PENDING
        securityApproval: true,
        operationsApproval: true,
        productApproval: true,
        finalAuthorization: false,
      );

      final result = gate.evaluateAuthorization(auth);
      expect(result.isAuthorized, isFalse);
      expect(result.rejectionReasonArabic, contains('اللجان الشرعية البشرية'));
    });

    test('Gate Check 3: Security approval PENDING is BLOCKED', () {
      const auth = ProductionAuthorization(
        authorizationId: 'auth_siraj_prod_002',
        releaseId: 'rel_siraj_1_22_0',
        technicalApproval: true,
        contentApproval: true,
        securityApproval: false, // PENDING
        operationsApproval: true,
        productApproval: true,
        finalAuthorization: false,
      );

      final result = gate.evaluateAuthorization(auth);
      expect(result.isAuthorized, isFalse);
      expect(result.rejectionReasonArabic, contains('الموافقة الأمنية'));
    });

    test('Gate Check 4: Full 5-Point approval with authorized signature is ALLOWED', () {
      final auth = ProductionAuthorization(
        authorizationId: 'auth_siraj_prod_003',
        releaseId: 'rel_siraj_1_22_0',
        technicalApproval: true,
        contentApproval: true,
        securityApproval: true,
        operationsApproval: true,
        productApproval: true,
        finalAuthorization: true,
        authorizedAt: DateTime.now(),
        authorizedBy: 'Council of Product & Religious Governance',
      );

      final result = gate.evaluateAuthorization(auth);
      expect(result.isAuthorized, isTrue);
      expect(result.rejectionReasonArabic, isNull);
    });
  });
}
