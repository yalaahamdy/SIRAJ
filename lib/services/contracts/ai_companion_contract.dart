import 'package:equatable/equatable.dart';
import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../platform/content/domain/content_record.dart';

/// Structured response from AI Research & Assistance layer (Law 1, Law 4, ADR-010).
class AiRetrievalResponse extends Equatable {
  final List<ContentRecord> verifiedPassages;
  final String? explanatoryAnswer;
  final double confidence;
  final bool needsScholarReferral;

  const AiRetrievalResponse({
    required this.verifiedPassages,
    this.explanatoryAnswer,
    required this.confidence,
    required this.needsScholarReferral,
  });

  @override
  List<Object?> get props => [
        verifiedPassages,
        explanatoryAnswer,
        confidence,
        needsScholarReferral,
      ];
}

/// Contract for AI Companion (L3). Retrieval-only over verified corpus; NO sacred generation.
abstract class AiCompanionServiceContract {
  Future<Result<AiRetrievalResponse, Failure>> query({
    required String queryText,
    String? scope,
  });
}
