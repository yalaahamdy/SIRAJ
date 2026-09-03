import '../adhkar/adhkar_module.dart';
import '../hajj/hajj_module.dart';
import '../knowledge/knowledge_module.dart';
import '../learning/learning_module.dart';
import '../quran/store/canonical_quran_store.dart';
import '../seerah/seerah_module.dart';
import 'domain/ai_audit_log.dart';
import 'domain/ai_intent.dart';
import 'domain/ai_response.dart';
import 'engine/abstention_engine.dart';
import 'engine/evidence_bound_answer_composer.dart';
import 'engine/evidence_validator.dart';
import 'engine/intent_classifier.dart';
import 'engine/output_validator.dart';
import 'engine/safety_gate.dart';
import 'providers/llm_provider_contract.dart';
import 'providers/mock_deterministic_llm_provider.dart';
import 'retrievers/verified_retrieval_federation.dart';

/// Unified Facade for the Verified Islamic AI Retrieval Subsystem (§0, §5, §72).
class AIModule {
  final IntentClassifier _intentClassifier;
  final VerifiedRetrievalFederation _retrievalFederation;
  final EvidenceValidator _evidenceValidator;
  final AbstentionEngine _abstentionEngine;
  final SafetyGate _safetyGate;
  final OutputValidator _outputValidator;
  final EvidenceBoundAnswerComposer _answerComposer;
  final LLMProviderContract _llmProvider;

  final List<AIAuditLog> _auditLogs = [];

  AIModule({
    IntentClassifier? intentClassifier,
    VerifiedRetrievalFederation? retrievalFederation,
    EvidenceValidator? evidenceValidator,
    AbstentionEngine? abstentionEngine,
    SafetyGate? safetyGate,
    OutputValidator? outputValidator,
    EvidenceBoundAnswerComposer? answerComposer,
    LLMProviderContract? llmProvider,
    ReadOnlyCanonicalQuranStore? quranStore,
    AdhkarModule? adhkarModule,
    KnowledgeModule? knowledgeModule,
    LearningModule? learningModule,
    SeerahModule? seerahModule,
    HajjModule? hajjModule,
  })  : _intentClassifier = intentClassifier ?? const IntentClassifier(),
        _retrievalFederation = retrievalFederation ??
            VerifiedRetrievalFederation(
              quranStore: quranStore,
              adhkarModule: adhkarModule,
              knowledgeModule: knowledgeModule,
              learningModule: learningModule,
              seerahModule: seerahModule,
              hajjModule: hajjModule,
            ),
        _evidenceValidator = evidenceValidator ?? const EvidenceValidator(),
        _abstentionEngine = abstentionEngine ?? const AbstentionEngine(),
        _safetyGate = safetyGate ?? const SafetyGate(),
        _outputValidator = outputValidator ?? const OutputValidator(),
        _answerComposer = answerComposer ?? const EvidenceBoundAnswerComposer(),
        _llmProvider = llmProvider ?? const MockDeterministicLLMProvider();

  LLMProviderContract get llmProvider => _llmProvider;
  List<AIAuditLog> get auditLogs => List.unmodifiable(_auditLogs);

  /// Executes end-to-end verified evidence retrieval and grounded response generation (§0, §1, §5).
  Future<AIResponse> processQuery(String query) async {
    final requestId = 'req_${DateTime.now().millisecondsSinceEpoch}';
    final cleanQuery = query.trim();

    // 1. Prompt Injection Defense (§22, §61)
    if (_safetyGate.isMaliciousPromptInjection(cleanQuery)) {
      final abstention = _answerComposer.composeAbstentionResponse(
        requestId: requestId,
        reasonArabic:
            'تم رفض الاستعلام لمخالفته ضوابط الأمان ومحاولته تجاوز التعليمات الحاكمة.',
        intent: const AIIntent(category: IntentCategory.outOfScope, riskLevel: RiskLevel.critical),
      );
      _recordAuditLog(requestId, IntentCategory.outOfScope, RiskLevel.critical, [], 0, abstention);
      return abstention;
    }

    // 2. Classify Intent & Risk Level (§8, §9)
    final intent = _intentClassifier.classify(cleanQuery);

    // 3. Check Intent-level Abstention (e.g. Fatwa or Worship Validity) (§10, §44)
    if (intent.requiresAbstention) {
      final eval = _abstentionEngine.evaluate(
        intent: intent,
        validatedEvidence: const [],
        originalQuery: cleanQuery,
      );
      final abstention = _answerComposer.composeAbstentionResponse(
        requestId: requestId,
        reasonArabic: eval.reasonArabic ?? 'يمتنع سِراج عن الإفتاء في هذه المسألة.',
        referralArabic: eval.referralArabic,
        intent: intent,
      );
      _recordAuditLog(requestId, intent.category, intent.riskLevel, [], 0, abstention);
      return abstention;
    }

    // 4. Retrieve Evidence across Verified Federation (§6, §7)
    final rawEvidence = await _retrievalFederation.retrieve(intent: intent, query: cleanQuery);

    // 5. Validate & Rank Evidence (§11, §14)
    final validatedEvidence = _evidenceValidator.validateEvidence(rawEvidence);

    // 6. Evaluate Evidence-level Abstention (e.g. Insufficient Evidence or Hallucination Demand) (§44)
    final eval = _abstentionEngine.evaluate(
      intent: intent,
      validatedEvidence: validatedEvidence,
      originalQuery: cleanQuery,
    );

    if (eval.shouldAbstain) {
      final abstention = _answerComposer.composeAbstentionResponse(
        requestId: requestId,
        reasonArabic: eval.reasonArabic ?? 'لا تتوفر أدلة كافية في المصادر المعتمدة.',
        referralArabic: eval.referralArabic,
        intent: intent,
      );
      _recordAuditLog(requestId, intent.category, intent.riskLevel, [intent.targetModuleId ?? 'federation'], validatedEvidence.length, abstention);
      return abstention;
    }

    // 7. Generate Grounded Answer from LLM Provider (§55)
    await _llmProvider.generateEvidenceGroundedAnswer(
      userQuery: cleanQuery,
      validatedEvidence: validatedEvidence,
      systemInstructions: 'أنت في سِراج: التزم بالأدلة المرفقة فقط.',
    );

    // 8. Compose Raw Grounded Response & Formulate Citations (§17)
    final initialResponse = _answerComposer.composeGroundedResponse(
      requestId: requestId,
      query: cleanQuery,
      evidence: validatedEvidence,
      intent: intent,
    );

    // 9. Forensic Output & Citation Validation (§13, §18, §58)
    final validationRes = _outputValidator.validate(
      answerText: initialResponse.answerArabic,
      rawCitations: initialResponse.citations,
      availableEvidence: validatedEvidence,
    );

    if (!validationRes.isValid) {
      final abstention = _answerComposer.composeAbstentionResponse(
        requestId: requestId,
        reasonArabic: validationRes.rejectionReasonArabic ?? 'تم رفض الإجابة لعدم اكتمال الإسناد الموثق.',
        intent: intent,
      );
      _recordAuditLog(requestId, intent.category, intent.riskLevel, [intent.targetModuleId ?? 'federation'], validatedEvidence.length, abstention);
      return abstention;
    }

    _recordAuditLog(requestId, intent.category, intent.riskLevel, [intent.targetModuleId ?? 'federation'], validatedEvidence.length, initialResponse);
    return initialResponse;
  }

  void _recordAuditLog(
    String requestId,
    IntentCategory category,
    RiskLevel riskLevel,
    List<String> retrievers,
    int evidenceCount,
    AIResponse response,
  ) {
    _auditLogs.add(AIAuditLog(
      requestId: requestId,
      intentCategory: category,
      riskLevel: riskLevel,
      retrieversUsed: retrievers,
      evidenceCount: evidenceCount,
      groundingStatus: response.groundingStatus,
      isAbstained: response.isAbstained,
      timestamp: DateTime.now().toUtc(),
    ));
  }
}
