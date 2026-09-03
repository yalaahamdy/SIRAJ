import 'package:equatable/equatable.dart';

/// Semantic types of biographical and historical relationships (§10).
enum RelationshipType {
  parentOf('أبوة / أمومة'),
  childOf('بنوة'),
  spouseOf('مصاهرة / زواج'),
  companionOf('صحبة ومؤاخاة'),
  studentOf('تلمذة ورواية'),
  teacherOf('تعليم وإجازة'),
  travelledWith('سفر وهجرة مشتركة'),
  participatedIn('مشاركة في واقعة');

  final String labelArabic;
  const RelationshipType(this.labelArabic);
}

/// Sourced relationship between historical figures (§10).
class PersonRelationship extends Equatable {
  final String relationshipId;
  final String fromPersonId;
  final String toPersonId;
  final RelationshipType type;
  final String? description;
  final String sourceId;

  const PersonRelationship({
    required this.relationshipId,
    required this.fromPersonId,
    required this.toPersonId,
    required this.type,
    this.description,
    required this.sourceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'relationship_id': relationshipId,
      'from_person_id': fromPersonId,
      'to_person_id': toPersonId,
      'type': type.name,
      'description': description,
      'source_id': sourceId,
    };
  }

  factory PersonRelationship.fromMap(Map<String, dynamic> map) {
    return PersonRelationship(
      relationshipId: map['relationship_id'] as String,
      fromPersonId: map['from_person_id'] as String,
      toPersonId: map['to_person_id'] as String,
      type: RelationshipType.values.byName(map['type'] as String),
      description: map['description'] as String?,
      sourceId: map['source_id'] as String,
    );
  }

  @override
  List<Object?> get props => [
        relationshipId,
        fromPersonId,
        toPersonId,
        type,
        description,
        sourceId,
      ];
}
