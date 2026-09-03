import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'content_status.dart';
import 'content_type.dart';
import 'source_ref.dart';

/// Immutable domain entity representing a verified content unit in SIRAJ.
class ContentRecord extends Equatable {
  final String contentId;
  final ContentType contentType;
  final String text;
  final String language;
  final List<SourceRef> sources;
  final Attribution? attribution;
  final HadithGrade? grade;
  final JurisprudenceMetadata? jurisprudence;
  final ContentStatus status;
  final int version;
  final String integrityHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<HumanReviewRecord> reviewRecords;
  final Map<String, dynamic> metadata;

  const ContentRecord({
    required this.contentId,
    required this.contentType,
    required this.text,
    required this.sources,
    required this.status,
    required this.version,
    required this.integrityHash,
    required this.createdAt,
    required this.updatedAt,
    this.language = 'ar',
    this.attribution,
    this.grade,
    this.jurisprudence,
    this.reviewRecords = const [],
    this.metadata = const {},
  });

  /// Factory to construct a new record with automatic SHA-256 hash calculation.
  factory ContentRecord.create({
    required String contentId,
    required ContentType contentType,
    required String text,
    required List<SourceRef> sources,
    required ContentStatus status,
    int version = 1,
    String language = 'ar',
    Attribution? attribution,
    HadithGrade? grade,
    JurisprudenceMetadata? jurisprudence,
    List<HumanReviewRecord> reviewRecords = const [],
    Map<String, dynamic> metadata = const {},
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now().toUtc();
    final hash = computeHash(text);

    return ContentRecord(
      contentId: contentId,
      contentType: contentType,
      text: text,
      sources: sources,
      status: status,
      version: version,
      integrityHash: hash,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      language: language,
      attribution: attribution,
      grade: grade,
      jurisprudence: jurisprudence,
      reviewRecords: reviewRecords,
      metadata: metadata,
    );
  }

  /// Calculates deterministic SHA-256 hash of the text payload.
  static String computeHash(String textPayload) {
    final bytes = utf8.encode(textPayload);
    final digest = sha256.convert(bytes);
    return 'sha256:${digest.toString()}';
  }

  /// Verifies if the current payload matches the stored integrity hash.
  bool verifyIntegrity() {
    return computeHash(text) == integrityHash;
  }

  /// Returns true if this record has received valid human approval.
  bool get hasValidHumanApproval {
    if (status != ContentStatus.approved && status != ContentStatus.locked) {
      return false;
    }
    return reviewRecords.any((r) => r.verdict == 'APPROVED');
  }

  ContentRecord copyWith({
    String? text,
    List<SourceRef>? sources,
    Attribution? attribution,
    HadithGrade? grade,
    JurisprudenceMetadata? jurisprudence,
    ContentStatus? status,
    int? version,
    List<HumanReviewRecord>? reviewRecords,
    Map<String, dynamic>? metadata,
  }) {
    final updatedText = text ?? this.text;
    final updatedHash = computeHash(updatedText);

    return ContentRecord(
      contentId: contentId,
      contentType: contentType,
      text: updatedText,
      language: language,
      sources: sources ?? this.sources,
      attribution: attribution ?? this.attribution,
      grade: grade ?? this.grade,
      jurisprudence: jurisprudence ?? this.jurisprudence,
      status: status ?? this.status,
      version: version ?? (this.version + 1),
      integrityHash: updatedHash,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
      reviewRecords: reviewRecords ?? this.reviewRecords,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        contentId,
        contentType,
        text,
        language,
        sources,
        attribution,
        grade,
        jurisprudence,
        status,
        version,
        integrityHash,
        createdAt,
        updatedAt,
        reviewRecords,
        metadata,
      ];
}
