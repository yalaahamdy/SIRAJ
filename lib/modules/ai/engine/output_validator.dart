import '../domain/citation.dart';
import '../domain/claim.dart';
import '../domain/evidence_item.dart';
import '../domain/grounding_status.dart';

/// Validation result of auditing model output claims and citations (§18, §57).
class OutputValidationResult {
  final bool isValid;
  final GroundingStatus groundingStatus;
  final List<Claim> verifiedClaims;
  final List<Citation> verifiedCitations;
  final String? rejectionReasonArabic;

  const OutputValidationResult({
    required this.isValid,
    required this.groundingStatus,
    this.verifiedClaims = const [],
    this.verifiedCitations = const [],
    this.rejectionReasonArabic,
  });
}

/// Validator performing forensic cross-checks on model outputs against validated evidence (§13, §18, §58).
class OutputValidator {
  const OutputValidator();

  OutputValidationResult validate({
    required String answerText,
    required List<Citation> rawCitations,
    required List<EvidenceItem> availableEvidence,
  }) {
    // Strip zero-width/control characters from answer text (§45)
    final cleanText = answerText
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF\u202E\u202A-\u202D]'), '')
        .trim();

    if (availableEvidence.isEmpty) {
      return const OutputValidationResult(
        isValid: false,
        groundingStatus: GroundingStatus.insufficientEvidence,
        rejectionReasonArabic: 'لا توجد أدلة معتمدة لدعم هذا الجواب.',
      );
    }

    final verifiedCitations = <Citation>[];
    bool hasFabricatedCitation = false;
    bool hasMismatchedCitation = false;

    // 1. Verify every citation against the actual available evidence pool (§7, §9, §10, §13)
    for (final c in rawCitations) {
      final match = availableEvidence.cast<EvidenceItem?>().firstWhere(
            (e) => e?.sourceId == c.sourceId && e?.contentId == c.contentId,
            orElse: () => null,
          );

      if (match == null) {
        hasFabricatedCitation = true;
        verifiedCitations.add(Citation(
          citationId: c.citationId,
          sourceId: c.sourceId,
          contentId: c.contentId,
          displayTitleArabic: c.displayTitleArabic,
          referenceLocation: c.referenceLocation,
          status: CitationVerificationStatus.fabricated,
        ));
      } else {
        // Check for reference mismatch or wrong topic (§9, §10)
        final isRefMatching = c.referenceLocation.isEmpty ||
            match.referenceLocation.contains(c.referenceLocation) ||
            c.referenceLocation.contains(match.referenceLocation);

        if (!isRefMatching) {
          hasMismatchedCitation = true;
          verifiedCitations.add(Citation(
            citationId: c.citationId,
            sourceId: c.sourceId,
            contentId: c.contentId,
            displayTitleArabic: c.displayTitleArabic,
            referenceLocation: c.referenceLocation,
            status: CitationVerificationStatus.mismatched,
            matchedEvidence: match,
          ));
        } else {
          verifiedCitations.add(Citation(
            citationId: c.citationId,
            sourceId: c.sourceId,
            contentId: c.contentId,
            displayTitleArabic: c.displayTitleArabic,
            referenceLocation: c.referenceLocation,
            status: CitationVerificationStatus.verified,
            matchedEvidence: match,
          ));
        }
      }
    }

    // 2. Reject immediately if citation fabrication or mismatch detected (§13, §58)
    if (hasFabricatedCitation) {
      return OutputValidationResult(
        isValid: false,
        groundingStatus: GroundingStatus.insufficientEvidence,
        verifiedCitations: verifiedCitations,
        rejectionReasonArabic: 'تم رفض الإجابة لاحتوائها على استشهاد غير مطابق أو غير معتمد.',
      );
    }

    if (hasMismatchedCitation) {
      return OutputValidationResult(
        isValid: false,
        groundingStatus: GroundingStatus.insufficientEvidence,
        verifiedCitations: verifiedCitations,
        rejectionReasonArabic: 'تم رفض الإجابة لوجود عدم تطابق بين موضع الاستشهاد والدليل المعتمد.',
      );
    }

    // 3. Extract and verify factual claims against available evidence (§5, §6, §40)
    final claims = <Claim>[];
    final sentences = cleanText
        .split(RegExp(r'[.\n•]'))
        .map((s) => s.trim())
        .where((s) => s.length > 5)
        .toList();

    int supportedCount = 0;
    int unsupportedCount = 0;

    final allEvidenceText = availableEvidence.map((e) => e.textExcerpt).join(' ');

    for (int i = 0; i < sentences.length; i++) {
      final s = sentences[i];
      // Check if statement has lexical or factual anchoring in retrieved evidence
      final tokens = s.split(RegExp(r'\s+')).where((t) => t.length > 3).toList();
      final matchingTokens = tokens.where((t) => allEvidenceText.contains(t)).length;

      final isSupported = tokens.isEmpty || (matchingTokens / tokens.length) >= 0.3;

      if (isSupported) {
        supportedCount++;
        claims.add(Claim(
          claimId: 'claim_$i',
          statement: s,
          supportLevel: ClaimSupportLevel.supported,
          supportingEvidence: availableEvidence,
          isAllowed: true,
        ));
      } else {
        unsupportedCount++;
        claims.add(Claim(
          claimId: 'claim_$i',
          statement: s,
          supportLevel: ClaimSupportLevel.unsupported,
          supportingEvidence: const [],
          isAllowed: false,
        ));
      }
    }

    // 4. Check for conflicting sources (§13, §14, §54)
    final sourceCount = availableEvidence.map((e) => e.sourceId).toSet().length;
    final hasConflictingPositions = availableEvidence.any((e) =>
        e.textExcerpt.contains('خلاف') ||
        e.textExcerpt.contains('اختلف') ||
        e.textExcerpt.contains('ذهب الحنفية') ||
        e.textExcerpt.contains('وقال الشافعية'));

    if (hasConflictingPositions && sourceCount > 1) {
      return OutputValidationResult(
        isValid: true,
        groundingStatus: GroundingStatus.conflictingSources,
        verifiedClaims: claims,
        verifiedCitations: verifiedCitations,
      );
    }

    // 5. Claim decomposition check (§5, §6, §40)
    if (unsupportedCount > 0 && supportedCount > 0) {
      return OutputValidationResult(
        isValid: true,
        groundingStatus: GroundingStatus.partiallyGrounded,
        verifiedClaims: claims,
        verifiedCitations: verifiedCitations,
      );
    } else if (unsupportedCount > 0 && supportedCount == 0) {
      return OutputValidationResult(
        isValid: false,
        groundingStatus: GroundingStatus.insufficientEvidence,
        verifiedClaims: claims,
        verifiedCitations: verifiedCitations,
        rejectionReasonArabic: 'تم رفض الإجابة لاحتوائها على ادعاءات غير مدعومة بالأدلة.',
      );
    }

    return OutputValidationResult(
      isValid: true,
      groundingStatus: GroundingStatus.fullyGrounded,
      verifiedClaims: claims,
      verifiedCitations: verifiedCitations,
    );
  }
}
