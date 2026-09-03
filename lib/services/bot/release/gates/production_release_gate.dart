import '../services/release_automation_service.dart';

/// Result of evaluating production release readiness gate (§57).
class ReleaseGateResult {
  final bool isAllowed;
  final String? blockerReasonArabic;

  const ReleaseGateResult({
    required this.isAllowed,
    this.blockerReasonArabic,
  });

  static const ReleaseGateResult allow = ReleaseGateResult(isAllowed: true);
}

/// Fail-Closed Production Release Gate enforcing technical and external approval conditions (§9, §23, §57).
class ProductionReleaseGate {
  final ReleaseAutomationService _automationService;

  const ProductionReleaseGate({
    required ReleaseAutomationService automationService,
  }) : _automationService = automationService;

  /// Evaluates whether a release candidate is legally authorized to activate production (§57, §66).
  ReleaseGateResult evaluateReleaseAuthorization(String releaseId) {
    final release = _automationService.getRelease(releaseId);

    if (release == null) {
      return const ReleaseGateResult(
        isAllowed: false,
        blockerReasonArabic: 'سجل الإصدار غير موجود في نظام أتمتة الإطلاق.',
      );
    }

    // 1. Technical readiness check
    if (!release.isTechnicallyReady || release.technicalStatus != 'READY') {
      return const ReleaseGateResult(
        isAllowed: false,
        blockerReasonArabic: 'الإصدار لم يستوفِ شروط الجاهزية الهندسية والتقنية الكاملة.',
      );
    }

    // 2. Human Religious Approval Check (§3, §55, §66)
    if (release.humanApprovalStatus != 'APPROVED' || !release.isApprovedForRelease) {
      return const ReleaseGateResult(
        isAllowed: false,
        blockerReasonArabic: 'حظر الإطلاق: الإصدار معلق بانتظار الاعتماد والترخيص الشرعي البشري الخارجي (Awaiting External Sign-off).',
      );
    }

    return ReleaseGateResult.allow;
  }
}
