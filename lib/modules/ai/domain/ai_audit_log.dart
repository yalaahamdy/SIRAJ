import 'package:equatable/equatable.dart';
import 'ai_intent.dart';
import 'grounding_status.dart';

/// Privacy-preserving, anonymous AI Audit Log Record (§39, §60).
class AIAuditLog extends Equatable {
  final String requestId;
  final IntentCategory intentCategory;
  final RiskLevel riskLevel;
  final List<String> retrieversUsed;
  final int evidenceCount;
  final GroundingStatus groundingStatus;
  final bool isAbstained;
  final DateTime timestamp;

  const AIAuditLog({
    required this.requestId,
    required this.intentCategory,
    required this.riskLevel,
    required this.retrieversUsed,
    required this.evidenceCount,
    required this.groundingStatus,
    required this.isAbstained,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'intent_category': intentCategory.name,
      'risk_level': riskLevel.name,
      'retrievers_used': retrieversUsed,
      'evidence_count': evidenceCount,
      'grounding_status': groundingStatus.name,
      'is_abstained': isAbstained,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        requestId,
        intentCategory,
        riskLevel,
        retrieversUsed,
        evidenceCount,
        groundingStatus,
        isAbstained,
        timestamp,
      ];
}
