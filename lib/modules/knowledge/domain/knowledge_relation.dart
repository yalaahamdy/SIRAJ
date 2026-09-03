import 'package:equatable/equatable.dart';

/// Semantic types of deterministic relations in the Knowledge Graph (§20).
enum RelationType {
  evidenceFor('دليل واستشهاد على'),
  commentaryOn('شرح وتفسير لـ'),
  narratedBy('مروي عن طريق'),
  authoredBy('منسوب إلى'),
  relatedTopic('مرتبط بموضوع');

  final String labelArabic;
  const RelationType(this.labelArabic);
}

/// Deterministic relationship link between two canonical knowledge entities (§20).
class KnowledgeRelation extends Equatable {
  final String relationId;
  final String sourceKey;
  final String targetKey;
  final RelationType relationType;
  final String? description;

  const KnowledgeRelation({
    required this.relationId,
    required this.sourceKey,
    required this.targetKey,
    required this.relationType,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'relation_id': relationId,
      'source_key': sourceKey,
      'target_key': targetKey,
      'relation_type': relationType.name,
      'description': description,
    };
  }

  factory KnowledgeRelation.fromMap(Map<String, dynamic> map) {
    return KnowledgeRelation(
      relationId: map['relation_id'] as String,
      sourceKey: map['source_key'] as String,
      targetKey: map['target_key'] as String,
      relationType: RelationType.values.byName(map['relation_type'] as String),
      description: map['description'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        relationId,
        sourceKey,
        targetKey,
        relationType,
        description,
      ];
}
