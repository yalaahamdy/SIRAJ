import 'package:equatable/equatable.dart';
import 'evidence_item.dart';

/// Support level of a factual claim (§18, §19).
enum ClaimSupportLevel {
  supported,
  partiallySupported,
  unsupported,
  contradicted;

  String get labelArabic {
    switch (this) {
      case ClaimSupportLevel.supported:
        return 'مدعوم بالدليل المعتمد';
      case ClaimSupportLevel.partiallySupported:
        return 'مدعوم جزئياً';
      case ClaimSupportLevel.unsupported:
        return 'غير مدعوم بدليل';
      case ClaimSupportLevel.contradicted:
        return 'يتعارض مع الدليل الموثق';
    }
  }
}

/// A specific factual claim extracted from model output for grounding verification (§18).
class Claim extends Equatable {
  final String claimId;
  final String statement;
  final ClaimSupportLevel supportLevel;
  final List<EvidenceItem> supportingEvidence;
  final bool isAllowed;

  const Claim({
    required this.claimId,
    required this.statement,
    required this.supportLevel,
    this.supportingEvidence = const [],
    this.isAllowed = true,
  });

  @override
  List<Object?> get props => [
        claimId,
        statement,
        supportLevel,
        supportingEvidence,
        isAllowed,
      ];
}
