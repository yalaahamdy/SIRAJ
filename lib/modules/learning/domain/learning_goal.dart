import 'package:equatable/equatable.dart';

/// User's personal learning goal and daily pacing preferences (§24, §40).
class LearningGoal extends Equatable {
  final String goalId;
  final String title;
  final int targetLessonsPerWeek;
  final int targetMinutesPerDay;
  final List<String> preferredTopics;
  final DateTime startDate;
  final DateTime? targetDate;

  const LearningGoal({
    required this.goalId,
    required this.title,
    this.targetLessonsPerWeek = 3,
    this.targetMinutesPerDay = 15,
    this.preferredTopics = const [],
    required this.startDate,
    this.targetDate,
  });

  LearningGoal copyWith({
    String? goalId,
    String? title,
    int? targetLessonsPerWeek,
    int? targetMinutesPerDay,
    List<String>? preferredTopics,
    DateTime? startDate,
    DateTime? targetDate,
  }) {
    return LearningGoal(
      goalId: goalId ?? this.goalId,
      title: title ?? this.title,
      targetLessonsPerWeek: targetLessonsPerWeek ?? this.targetLessonsPerWeek,
      targetMinutesPerDay: targetMinutesPerDay ?? this.targetMinutesPerDay,
      preferredTopics: preferredTopics ?? this.preferredTopics,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goal_id': goalId,
      'title': title,
      'target_lessons_per_week': targetLessonsPerWeek,
      'target_minutes_per_day': targetMinutesPerDay,
      'preferred_topics': preferredTopics,
      'start_date': startDate.toIso8601String(),
      'target_date': targetDate?.toIso8601String(),
    };
  }

  factory LearningGoal.fromMap(Map<String, dynamic> map) {
    final rawTopics = map['preferred_topics'] as List<dynamic>? ?? [];

    return LearningGoal(
      goalId: map['goal_id'] as String,
      title: map['title'] as String,
      targetLessonsPerWeek: map['target_lessons_per_week'] as int? ?? 3,
      targetMinutesPerDay: map['target_minutes_per_day'] as int? ?? 15,
      preferredTopics: rawTopics.map((e) => e.toString()).toList(),
      startDate: DateTime.parse(map['start_date'] as String),
      targetDate: map['target_date'] != null ? DateTime.parse(map['target_date'] as String) : null,
    );
  }

  @override
  List<Object?> get props => [
        goalId,
        title,
        targetLessonsPerWeek,
        targetMinutesPerDay,
        preferredTopics,
        startDate,
        targetDate,
      ];
}
