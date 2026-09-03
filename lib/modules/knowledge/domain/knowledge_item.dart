import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'evidence_reference.dart';

/// Semantic classification of knowledge materials (§18).
enum KnowledgeContentType {
  directSourceText('نص مصدري أصيل'),
  translation('ترجمة منسوبة'),
  commentary('شرح / حاشية'),
  scholarlyView('قول / اجتهاد عالم'),
  generalExplanation('بيان ومعرفة عامة');

  final String labelArabic;
  const KnowledgeContentType(this.labelArabic);
}

/// Generic canonical knowledge entity with strict content type safety (§17, §18).
class KnowledgeItem extends Equatable {
  final String itemId;
  final String title;
  final String category;
  final KnowledgeContentType contentType;
  final String primaryText;
  final String? explanationText;
  final String sourceId;
  final List<EvidenceReference> evidences;
  final List<String> tags;
  final String reviewState;
  final String integrityHash;

  const KnowledgeItem({
    required this.itemId,
    required this.title,
    required this.category,
    required this.contentType,
    required this.primaryText,
    this.explanationText,
    required this.sourceId,
    this.evidences = const [],
    this.tags = const [],
    this.reviewState = 'APPROVED',
    required this.integrityHash,
  });

  factory KnowledgeItem.create({
    required String itemId,
    required String title,
    required String category,
    required KnowledgeContentType contentType,
    required String primaryText,
    String? explanationText,
    required String sourceId,
    List<EvidenceReference> evidences = const [],
    List<String> tags = const [],
    String reviewState = 'APPROVED',
  }) {
    final evidencesPayload = evidences.map((e) => e.integrityHash).join(';');
    final tagsPayload = tags.join(',');
    final payload = '$itemId|$title|$category|${contentType.name}|$primaryText|${explanationText ?? ''}|$sourceId|$evidencesPayload|$tagsPayload|$reviewState';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return KnowledgeItem(
      itemId: itemId,
      title: title,
      category: category,
      contentType: contentType,
      primaryText: primaryText,
      explanationText: explanationText,
      sourceId: sourceId,
      evidences: evidences,
      tags: tags,
      reviewState: reviewState,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final evidencesPayload = evidences.map((e) => e.integrityHash).join(';');
    final tagsPayload = tags.join(',');
    final payload = '$itemId|$title|$category|${contentType.name}|$primaryText|${explanationText ?? ''}|$sourceId|$evidencesPayload|$tagsPayload|$reviewState';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'title': title,
      'category': category,
      'content_type': contentType.name,
      'primary_text': primaryText,
      'explanation_text': explanationText,
      'source_id': sourceId,
      'evidences': evidences.map((e) => e.toMap()).toList(),
      'tags': tags,
      'review_state': reviewState,
      'integrity_hash': integrityHash,
    };
  }

  factory KnowledgeItem.fromMap(Map<String, dynamic> map) {
    final rawEvidences = map['evidences'] as List<dynamic>? ?? [];
    final evidences = rawEvidences.map((e) => EvidenceReference.fromMap(e as Map<String, dynamic>)).toList();
    final rawTags = map['tags'] as List<dynamic>? ?? [];

    return KnowledgeItem(
      itemId: map['item_id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      contentType: KnowledgeContentType.values.byName(map['content_type'] as String),
      primaryText: map['primary_text'] as String,
      explanationText: map['explanation_text'] as String?,
      sourceId: map['source_id'] as String,
      evidences: evidences,
      tags: rawTags.map((t) => t.toString()).toList(),
      reviewState: map['review_state'] as String? ?? 'APPROVED',
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        title,
        category,
        contentType,
        primaryText,
        explanationText,
        sourceId,
        evidences,
        tags,
        reviewState,
        integrityHash,
      ];
}
