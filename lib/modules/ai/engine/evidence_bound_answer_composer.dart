import '../domain/ai_intent.dart';
import '../domain/ai_response.dart';
import '../domain/citation.dart';
import '../domain/evidence_item.dart';
import '../domain/grounding_status.dart';

/// Composes evidence-bounded responses or formatted abstention messages (§17, §46).
class EvidenceBoundAnswerComposer {
  const EvidenceBoundAnswerComposer();

  /// Composes a grounded response from validated evidence items.
  AIResponse composeGroundedResponse({
    required String requestId,
    required String query,
    required List<EvidenceItem> evidence,
    required AIIntent intent,
  }) {
    final citations = <Citation>[];
    final buffer = StringBuffer();

    buffer.writeln('بناءً على المصادر الموثقة المتاحة في سِراج:');
    buffer.writeln();

    for (int i = 0; i < evidence.length; i++) {
      final item = evidence[i];
      final citationId = 'cite_${item.sourceId}_${item.contentId}';

      citations.add(Citation(
        citationId: citationId,
        sourceId: item.sourceId,
        contentId: item.contentId,
        displayTitleArabic: item.title,
        referenceLocation: item.referenceLocation,
        status: CitationVerificationStatus.verified,
        matchedEvidence: item,
      ));

      buffer.writeln('• ${item.textExcerpt}');
      buffer.writeln('  [المصدر: ${item.title} — ${item.referenceLocation}]');
      buffer.writeln();
    }

    return AIResponse(
      requestId: requestId,
      mode: AIResponseMode.evidenceSummary,
      answerArabic: buffer.toString().trim(),
      citations: citations,
      evidenceItems: evidence,
      groundingStatus: GroundingStatus.fullyGrounded,
      riskLevel: intent.riskLevel,
      auditMetadata: {'evidence_count': evidence.length},
    );
  }

  /// Composes a respectful, structured abstention response (§44, §49).
  AIResponse composeAbstentionResponse({
    required String requestId,
    required String reasonArabic,
    String? referralArabic,
    required AIIntent intent,
  }) {
    final buffer = StringBuffer();
    buffer.writeln(reasonArabic);
    if (referralArabic != null) {
      buffer.writeln();
      buffer.writeln(referralArabic);
    }

    return AIResponse(
      requestId: requestId,
      mode: AIResponseMode.abstention,
      answerArabic: buffer.toString().trim(),
      citations: const [],
      evidenceItems: const [],
      groundingStatus: GroundingStatus.abstained,
      riskLevel: intent.riskLevel,
      isAbstained: true,
      abstentionReasonArabic: reasonArabic,
      scholarReferralArabic: referralArabic,
    );
  }
}
