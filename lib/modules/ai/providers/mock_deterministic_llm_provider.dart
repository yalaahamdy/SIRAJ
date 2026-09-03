import '../domain/evidence_item.dart';
import 'llm_provider_contract.dart';

/// Offline Deterministic Mock LLM Provider for unit, red-team, and forensic testing (§54, §55).
class MockDeterministicLLMProvider implements LLMProviderContract {
  final bool shouldInjectFabricatedCitation;

  const MockDeterministicLLMProvider({
    this.shouldInjectFabricatedCitation = false,
  });

  @override
  String get providerIdentifier => 'mock_deterministic_v1';

  @override
  Future<String> generateEvidenceGroundedAnswer({
    required String userQuery,
    required List<EvidenceItem> validatedEvidence,
    required String systemInstructions,
  }) async {
    if (validatedEvidence.isEmpty) {
      return 'لا تتوفر أدلة معتمدة في السياق للإجابة.';
    }

    final buffer = StringBuffer();
    buffer.writeln('بناءً على الأدلة الموثقة في سِراج:');
    for (final e in validatedEvidence) {
      buffer.writeln('• ${e.textExcerpt} (المصدر: ${e.title} - ${e.referenceLocation})');
    }

    if (shouldInjectFabricatedCitation) {
      buffer.writeln('• معلومة مخترعة غير مسندة (المصدر: كتاب وهمي لم يوثق - ص 999)');
    }

    return buffer.toString().trim();
  }
}
