import 'package:equatable/equatable.dart';
import 'evidence_item.dart';

/// Verification status of a citation (§13).
enum CitationVerificationStatus {
  verified,
  mismatched,
  unverified,
  fabricated;

  String get labelArabic {
    switch (this) {
      case CitationVerificationStatus.verified:
        return 'استشهاد مطابق وموثق';
      case CitationVerificationStatus.mismatched:
        return 'غير متطابق مع الدليل';
      case CitationVerificationStatus.unverified:
        return 'غير مفحوص';
      case CitationVerificationStatus.fabricated:
        return 'استشهاد زائف / مختلق';
    }
  }
}

/// Traceable Citation linking a response claim to a verified EvidenceItem (§12, §13).
class Citation extends Equatable {
  final String citationId;
  final String sourceId;
  final String contentId;
  final String displayTitleArabic;
  final String referenceLocation;
  final CitationVerificationStatus status;
  final EvidenceItem? matchedEvidence;

  const Citation({
    required this.citationId,
    required this.sourceId,
    required this.contentId,
    required this.displayTitleArabic,
    required this.referenceLocation,
    this.status = CitationVerificationStatus.verified,
    this.matchedEvidence,
  });

  bool get isLegitimate => status == CitationVerificationStatus.verified;

  @override
  List<Object?> get props => [
        citationId,
        sourceId,
        contentId,
        displayTitleArabic,
        referenceLocation,
        status,
        matchedEvidence,
      ];
}
