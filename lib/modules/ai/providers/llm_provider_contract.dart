import '../domain/evidence_item.dart';

/// Contract for model-agnostic LLM providers (§55).
abstract class LLMProviderContract {
  String get providerIdentifier;

  Future<String> generateEvidenceGroundedAnswer({
    required String userQuery,
    required List<EvidenceItem> validatedEvidence,
    required String systemInstructions,
  });
}
