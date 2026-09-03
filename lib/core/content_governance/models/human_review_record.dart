import 'package:equatable/equatable.dart';

/// Human review decision enum (§5, §6).
enum HumanReviewDecision {
  approved,
  rejected,
  changeRequested,
}

/// Structured, immutable human review and scholarly sign-off record (§6, §10, §54).
class HumanReviewRecord extends Equatable {
  final String recordId;
  final String packageId;
  final String version;
  final String reviewedHashSha256;
  final String reviewerName;
  final String reviewerRole;
  final HumanReviewDecision decision;
  final DateTime timestamp;
  final String notesArabic;
  final String? reviewerSignature;

  const HumanReviewRecord({
    required this.recordId,
    required this.packageId,
    required this.version,
    required this.reviewedHashSha256,
    required this.reviewerName,
    required this.reviewerRole,
    required this.decision,
    required this.timestamp,
    this.notesArabic = '',
    this.reviewerSignature,
  });

  bool get isValid =>
      recordId.isNotEmpty &&
      packageId.isNotEmpty &&
      version.isNotEmpty &&
      reviewedHashSha256.isNotEmpty &&
      reviewerName.isNotEmpty &&
      reviewerRole.isNotEmpty &&
      reviewerSignature != null &&
      reviewerSignature!.isNotEmpty;

  @override
  List<Object?> get props => [
        recordId,
        packageId,
        version,
        reviewedHashSha256,
        reviewerName,
        reviewerRole,
        decision,
        timestamp,
        notesArabic,
        reviewerSignature,
      ];
}
