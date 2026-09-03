import 'package:equatable/equatable.dart';

/// Pedagogical learning objective defining what the student should comprehend (§10).
class LearningObjective extends Equatable {
  final String objectiveId;
  final String title;
  final String description;

  const LearningObjective({
    required this.objectiveId,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'objective_id': objectiveId,
      'title': title,
      'description': description,
    };
  }

  factory LearningObjective.fromMap(Map<String, dynamic> map) {
    return LearningObjective(
      objectiveId: map['objective_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

  @override
  List<Object?> get props => [objectiveId, title, description];
}
