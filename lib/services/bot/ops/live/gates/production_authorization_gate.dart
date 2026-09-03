import '../models/production_authorization.dart';

/// Result of evaluating production authorization gate (§6, §7).
class AuthorizationGateResult {
  final bool isAuthorized;
  final String? rejectionReasonArabic;

  const AuthorizationGateResult({
    required this.isAuthorized,
    this.rejectionReasonArabic,
  });

  static const AuthorizationGateResult allow = AuthorizationGateResult(isAuthorized: true);
}

/// Fail-Closed Production Authorization Gate (§6, §7, §82).
class ProductionAuthorizationGate {
  const ProductionAuthorizationGate();

  /// Evaluates whether a production authorization object satisfies all 5 mandatory release criteria (§5, §6).
  AuthorizationGateResult evaluateAuthorization(ProductionAuthorization? authorization) {
    if (authorization == null) {
      return const AuthorizationGateResult(
        isAuthorized: false,
        rejectionReasonArabic: 'حظر الإطلاق: لا يوجد سجل ترخيص إنتاجي معتمد.',
      );
    }

    if (!authorization.technicalApproval) {
      return const AuthorizationGateResult(
        isAuthorized: false,
        rejectionReasonArabic: 'حظر الإطلاق: الموافقة الهندسية والتقنية ما زالت معلقة (Technical Approval Pending).',
      );
    }

    if (!authorization.contentApproval) {
      return const AuthorizationGateResult(
        isAuthorized: false,
        rejectionReasonArabic: 'حظر الإطلاق: موافقة اللجان الشرعية البشرية ما زالت معلقة (Human Religious Approval Pending).',
      );
    }

    if (!authorization.securityApproval) {
      return const AuthorizationGateResult(
        isAuthorized: false,
        rejectionReasonArabic: 'حظر الإطلاق: الموافقة الأمنية وسلسلة التوريد معلقة (Security Approval Pending).',
      );
    }

    if (!authorization.operationsApproval) {
      return const AuthorizationGateResult(
        isAuthorized: false,
        rejectionReasonArabic: 'حظر الإطلاق: الموافقة التشغيلية والتعافي معلقة (Operations Approval Pending).',
      );
    }

    if (!authorization.productApproval || !authorization.finalAuthorization || authorization.authorizedBy == null || authorization.authorizedBy!.isEmpty) {
      return const AuthorizationGateResult(
        isAuthorized: false,
        rejectionReasonArabic: 'حظر الإطلاق: التفويض النهائي للإفراج غير موقع أو معلق (Final Authorization Pending).',
      );
    }

    return AuthorizationGateResult.allow;
  }
}
