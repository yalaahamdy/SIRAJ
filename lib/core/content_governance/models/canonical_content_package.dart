import 'package:equatable/equatable.dart';

/// The 10 Lifecycle Review and Release states of a canonical content package (§4, §5).
enum ContentReviewState {
  unverified,
  underReview,
  rejected,
  approved,
  signed,
  releaseCandidate,
  active,
  revoked,
  quarantined,
  superseded,
}

/// Content class taxonomy (§3).
enum CanonicalContentClass {
  sacredText, // Class A (Quran)
  transmittedReligious, // Class B (Hadith, Canonical Adhkar)
  scholarlyFiqh, // Class C (Fiqh positions)
  historical, // Class D (Seerah)
  educational, // Class E (Lessons)
  calculationalPolicy, // Class F (Zakat, Prayer methodology, Fasting)
}

/// Structured Canonical Content Package metadata and cryptographic binding (§4, §10, §25).
class CanonicalContentPackage extends Equatable {
  final String packageId;
  final String contentType;
  final CanonicalContentClass contentClass;
  final String version;
  final String sourceEdition;
  final String contentHashSha256;
  final String? signature;
  final ContentReviewState reviewState;
  final String? approvedBy;
  final DateTime? approvedAt;
  final bool isSynthetic;
  final Map<String, dynamic> metadata;

  const CanonicalContentPackage({
    required this.packageId,
    required this.contentType,
    required this.contentClass,
    required this.version,
    required this.sourceEdition,
    required this.contentHashSha256,
    this.signature,
    this.reviewState = ContentReviewState.unverified,
    this.approvedBy,
    this.approvedAt,
    this.isSynthetic = false,
    this.metadata = const {},
  });

  bool get isApproved => reviewState == ContentReviewState.approved ||
      reviewState == ContentReviewState.signed ||
      reviewState == ContentReviewState.releaseCandidate ||
      reviewState == ContentReviewState.active;

  bool get isSigned => signature != null && signature!.isNotEmpty;

  bool get isActive => reviewState == ContentReviewState.active;

  bool get isQuarantinedOrRevoked =>
      reviewState == ContentReviewState.revoked ||
      reviewState == ContentReviewState.quarantined;

  CanonicalContentPackage copyWith({
    String? packageId,
    String? contentType,
    CanonicalContentClass? contentClass,
    String? version,
    String? sourceEdition,
    String? contentHashSha256,
    String? signature,
    ContentReviewState? reviewState,
    String? approvedBy,
    DateTime? approvedAt,
    bool? isSynthetic,
    Map<String, dynamic>? metadata,
  }) {
    return CanonicalContentPackage(
      packageId: packageId ?? this.packageId,
      contentType: contentType ?? this.contentType,
      contentClass: contentClass ?? this.contentClass,
      version: version ?? this.version,
      sourceEdition: sourceEdition ?? this.sourceEdition,
      contentHashSha256: contentHashSha256 ?? this.contentHashSha256,
      signature: signature ?? this.signature,
      reviewState: reviewState ?? this.reviewState,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      isSynthetic: isSynthetic ?? this.isSynthetic,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        packageId,
        contentType,
        contentClass,
        version,
        sourceEdition,
        contentHashSha256,
        signature,
        reviewState,
        approvedBy,
        approvedAt,
        isSynthetic,
        metadata,
      ];
}
