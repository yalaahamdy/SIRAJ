import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'evidence_link.dart';
import 'learning_content_type.dart';

/// Distinct structured section within a lesson (§6, §11).
class LessonSection extends Equatable {
  final String sectionId;
  final String title;
  final LearningContentType contentType;
  final String content;
  final List<EvidenceLink> evidenceLinks;
  final String? sourceAttribution;
  final String integrityHash;

  const LessonSection({
    required this.sectionId,
    required this.title,
    required this.contentType,
    required this.content,
    this.evidenceLinks = const [],
    this.sourceAttribution,
    required this.integrityHash,
  });

  factory LessonSection.create({
    required String sectionId,
    required String title,
    required LearningContentType contentType,
    required String content,
    List<EvidenceLink> evidenceLinks = const [],
    String? sourceAttribution,
  }) {
    final evidencesPayload = evidenceLinks.map((e) => e.integrityHash).join(';');
    final payload = '$sectionId|$title|${contentType.name}|$content|$evidencesPayload|${sourceAttribution ?? ''}';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return LessonSection(
      sectionId: sectionId,
      title: title,
      contentType: contentType,
      content: content,
      evidenceLinks: evidenceLinks,
      sourceAttribution: sourceAttribution,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final evidencesPayload = evidenceLinks.map((e) => e.integrityHash).join(';');
    final payload = '$sectionId|$title|${contentType.name}|$content|$evidencesPayload|${sourceAttribution ?? ''}';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'section_id': sectionId,
      'title': title,
      'content_type': contentType.name,
      'content': content,
      'evidence_links': evidenceLinks.map((e) => e.toMap()).toList(),
      'source_attribution': sourceAttribution,
      'integrity_hash': integrityHash,
    };
  }

  factory LessonSection.fromMap(Map<String, dynamic> map) {
    final rawEvidences = map['evidence_links'] as List<dynamic>? ?? [];
    final evidences = rawEvidences.map((e) => EvidenceLink.fromMap(e as Map<String, dynamic>)).toList();

    return LessonSection(
      sectionId: map['section_id'] as String,
      title: map['title'] as String,
      contentType: LearningContentType.values.byName(map['content_type'] as String),
      content: map['content'] as String,
      evidenceLinks: evidences,
      sourceAttribution: map['source_attribution'] as String?,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        sectionId,
        title,
        contentType,
        content,
        evidenceLinks,
        sourceAttribution,
        integrityHash,
      ];
}
