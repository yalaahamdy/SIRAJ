import '../engine/canonical_content_registry.dart';
import '../engine/content_signing_service.dart';
import '../models/canonical_content_package.dart';
import '../models/human_review_record.dart';

/// Evaluation result of the production content gate (§57).
class ContentGateResult {
  final bool isAllowed;
  final String? rejectionReasonArabic;

  const ContentGateResult({
    required this.isAllowed,
    this.rejectionReasonArabic,
  });

  static const ContentGateResult allow = ContentGateResult(isAllowed: true);
}

/// Fail-Closed Production Content Release & Activation Gate (§57, §63).
class ProductionContentGate {
  final CanonicalContentRegistry _registry;
  final ContentSigningService _signingService;

  const ProductionContentGate({
    required CanonicalContentRegistry registry,
    required ContentSigningService signingService,
  })  : _registry = registry,
        _signingService = signingService;

  /// Evaluates whether a canonical content package is legally allowed to activate in production (§57, §63).
  ContentGateResult evaluatePackageActivation(String packageId) {
    final package = _registry.getPackage(packageId);

    // 1. Existence check
    if (package == null) {
      return const ContentGateResult(
        isAllowed: false,
        rejectionReasonArabic: 'الحزمة المطلوبة غير مسجلة في سجل الحزم الكنسية.',
      );
    }

    // 2. Synthetic firewall (§47)
    if (package.isSynthetic || package.packageId.contains('synthetic')) {
      return const ContentGateResult(
        isAllowed: false,
        rejectionReasonArabic: 'حظر جدار الحماية: لا يمكن تفعيل الحزم الاصطناعية أو التجريبية في بيئة الإنتاج.',
      );
    }

    // 3. Quarantine and Revocation Check (§28, §30)
    if (package.isQuarantinedOrRevoked) {
      return const ContentGateResult(
        isAllowed: false,
        rejectionReasonArabic: 'الحزمة محجورة أو ملغاة رسمياً وممنوعة من التفعيل.',
      );
    }

    // 4. Human Religious Approval Check (§1, §6, §55, §57)
    if (!package.isApproved || package.approvedBy == null || package.approvedBy!.isEmpty) {
      return const ContentGateResult(
        isAllowed: false,
        rejectionReasonArabic: 'الحزمة غير معتمدة شرعياً من اللجان البشرية المختصة (بانتظار التوقيع البشري).',
      );
    }

    // 5. Cryptographic Signature & Hash Integrity Check (§7, §11, §57)
    if (!package.isSigned || !_signingService.verifyPackageSignature(package)) {
      return const ContentGateResult(
        isAllowed: false,
        rejectionReasonArabic: 'فشل التحقق من التوقيع الرقمي أو تطابق البصمة المشفرة SHA-256 للحزمة.',
      );
    }

    // 6. Audit Trail Check (§39, §55)
    final audits = _registry.getAuditTrailForPackage(packageId);
    final hasValidAudit = audits.any((r) =>
        r.decision == HumanReviewDecision.approved &&
        r.reviewedHashSha256 == package.contentHashSha256 &&
        r.isValid);

    if (!hasValidAudit) {
      return const ContentGateResult(
        isAllowed: false,
        rejectionReasonArabic: 'لا يوجد سجل مراجعة بشرية سليم ومطابق لبصمة الحزمة في سجل التدقيق غير القابل للتعديل.',
      );
    }

    return ContentGateResult.allow;
  }

  /// Activates a package atomically if gate passes (§27).
  bool activatePackage(String packageId) {
    final gateResult = evaluatePackageActivation(packageId);
    if (!gateResult.isAllowed) {
      return false;
    }

    final package = _registry.getPackage(packageId)!;
    final activePackage = package.copyWith(reviewState: ContentReviewState.active);
    _registry.registerPackage(activePackage);
    return true;
  }
}
