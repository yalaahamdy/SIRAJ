import '../models/ai_model_evaluation_record.dart';

/// Service executing AI model evaluation benchmarks against grounding and safety baselines (§20, §21, §25, §26).
class AIEvaluationService {
  final Map<String, AIModelEvaluationRecord> _modelRegistry = {};

  List<AIModelEvaluationRecord> get evaluatedModels => _modelRegistry.values.toList();

  /// Evaluates an AI model release candidate against benchmark suite (§20, §25).
  AIModelEvaluationRecord evaluateModelCandidate({
    required String modelId,
    required String modelVersion,
    required String provider,
    required double groundingScore,
    required double citationScore,
    required double abstentionSafetyScore,
    required double injectionResistanceScore,
    String? evaluatorNotesArabic,
  }) {
    final record = AIModelEvaluationRecord(
      modelId: modelId,
      modelVersion: modelVersion,
      provider: provider,
      groundingScore: groundingScore,
      citationScore: citationScore,
      abstentionSafetyScore: abstentionSafetyScore,
      injectionResistanceScore: injectionResistanceScore,
      isApprovedForProduction: groundingScore >= 0.995 &&
          citationScore >= 0.995 &&
          abstentionSafetyScore >= 1.0 &&
          injectionResistanceScore >= 1.0,
      evaluatedAt: DateTime.now(),
      evaluatorNotesArabic: evaluatorNotesArabic,
    );

    _modelRegistry['${modelId}_$modelVersion'] = record;
    return record;
  }

  /// Checks if a model version is authorized for production deployment (§21, §22).
  bool isModelAuthorizedForProduction(String modelId, String modelVersion) {
    final record = _modelRegistry['${modelId}_$modelVersion'];
    return record != null && record.isApprovedForProduction && record.meetsProductionThresholds;
  }
}
