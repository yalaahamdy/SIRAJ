import '../domain/evidence_item.dart';

/// Validates retrieved evidence against canonical structure and integrity rules (§11, §14).
class EvidenceValidator {
  const EvidenceValidator();

  /// Validates a list of evidence items, filtering out unverified or malformed records.
  List<EvidenceItem> validateEvidence(List<EvidenceItem> rawEvidence) {
    if (rawEvidence.isEmpty) return const [];

    final validated = <EvidenceItem>[];

    for (final item in rawEvidence) {
      if (!item.isValid) continue;

      // Reject empty content or unverified state
      if (item.textExcerpt.trim().isEmpty || item.referenceLocation.trim().isEmpty) {
        continue;
      }

      if (item.verificationState != VerificationState.approved &&
          item.verificationState != VerificationState.canonical) {
        continue;
      }

      validated.add(item);
    }

    // Sort by relevance score descending
    validated.sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    return List.unmodifiable(validated);
  }
}
