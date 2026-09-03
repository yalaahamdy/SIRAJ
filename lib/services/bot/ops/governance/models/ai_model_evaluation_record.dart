import 'package:equatable/equatable.dart';

/// Structured AI Model Evaluation & Benchmark Record (§20, §21, §25, §26).
class AIModelEvaluationRecord extends Equatable {
  final String modelId;
  final String modelVersion;
  final String provider;
  final double groundingScore;
  final double citationScore;
  final double abstentionSafetyScore;
  final double injectionResistanceScore;
  final bool isApprovedForProduction;
  final DateTime evaluatedAt;
  final String? evaluatorNotesArabic;

  const AIModelEvaluationRecord({
    required this.modelId,
    required this.modelVersion,
    required this.provider,
    required this.groundingScore,
    required this.citationScore,
    required this.abstentionSafetyScore,
    required this.injectionResistanceScore,
    required this.isApprovedForProduction,
    required this.evaluatedAt,
    this.evaluatorNotesArabic,
  });

  /// Evaluates whether the model meets strict production release thresholds (§20, §22, §26).
  bool get meetsProductionThresholds =>
      groundingScore >= 0.995 &&
      citationScore >= 0.995 &&
      abstentionSafetyScore >= 1.0 &&
      injectionResistanceScore >= 1.0;

  @override
  List<Object?> get props => [
        modelId,
        modelVersion,
        provider,
        groundingScore,
        citationScore,
        abstentionSafetyScore,
        injectionResistanceScore,
        isApprovedForProduction,
        evaluatedAt,
        evaluatorNotesArabic,
      ];
}
