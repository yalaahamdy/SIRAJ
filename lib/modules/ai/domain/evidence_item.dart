import 'package:equatable/equatable.dart';

/// Verification state of an evidence item (§11).
enum VerificationState {
  approved,
  canonical,
  unverified,
  rejected;

  String get labelArabic {
    switch (this) {
      case VerificationState.approved:
        return 'معتمد وموثق';
      case VerificationState.canonical:
        return 'كنسي أصيل';
      case VerificationState.unverified:
        return 'غير مفحوص';
      case VerificationState.rejected:
        return 'مرفوض';
    }
  }
}

/// Traceable, structured Evidence Object retrieved from canonical modules (§11, §12).
class EvidenceItem extends Equatable {
  final String sourceId;
  final String contentId;
  final String contentType; // 'ayah', 'hadith', 'dhikr', 'fiqh', 'seerah', 'hajj_step', 'lesson'
  final String title;
  final String textExcerpt;
  final String referenceLocation; // Book, Chapter, Hadith No, Ayah No
  final String version;
  final VerificationState verificationState;
  final double relevanceScore;
  final Map<String, dynamic> metadata;

  const EvidenceItem({
    required this.sourceId,
    required this.contentId,
    required this.contentType,
    required this.title,
    required this.textExcerpt,
    required this.referenceLocation,
    this.version = '1.0.0',
    this.verificationState = VerificationState.approved,
    this.relevanceScore = 1.0,
    this.metadata = const {},
  });

  bool get isValid =>
      sourceId.isNotEmpty &&
      contentId.isNotEmpty &&
      textExcerpt.isNotEmpty &&
      (verificationState == VerificationState.approved ||
          verificationState == VerificationState.canonical);

  EvidenceItem copyWith({
    String? sourceId,
    String? contentId,
    String? contentType,
    String? title,
    String? textExcerpt,
    String? referenceLocation,
    String? version,
    VerificationState? verificationState,
    double? relevanceScore,
    Map<String, dynamic>? metadata,
  }) {
    return EvidenceItem(
      sourceId: sourceId ?? this.sourceId,
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      title: title ?? this.title,
      textExcerpt: textExcerpt ?? this.textExcerpt,
      referenceLocation: referenceLocation ?? this.referenceLocation,
      version: version ?? this.version,
      verificationState: verificationState ?? this.verificationState,
      relevanceScore: relevanceScore ?? this.relevanceScore,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        sourceId,
        contentId,
        contentType,
        title,
        textExcerpt,
        referenceLocation,
        version,
        verificationState,
        relevanceScore,
        metadata,
      ];
}
