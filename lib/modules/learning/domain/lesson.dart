import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'learning_objective.dart';
import 'lesson_section.dart';

/// Canonical, versioned Islamic lesson entity (§7, §11, §35).
class Lesson extends Equatable {
  final String lessonId;
  final String title;
  final String courseId;
  final String moduleId;
  final int orderIndex;
  final List<LearningObjective> objectives;
  final List<LessonSection> sections;
  final List<String> sources;
  final String authorOrEditor;
  final int version;
  final String reviewState;
  final String integrityHash;

  const Lesson({
    required this.lessonId,
    required this.title,
    required this.courseId,
    required this.moduleId,
    required this.orderIndex,
    required this.objectives,
    required this.sections,
    required this.sources,
    required this.authorOrEditor,
    this.version = 1,
    this.reviewState = 'APPROVED',
    required this.integrityHash,
  });

  factory Lesson.create({
    required String lessonId,
    required String title,
    required String courseId,
    required String moduleId,
    required int orderIndex,
    required List<LearningObjective> objectives,
    required List<LessonSection> sections,
    required List<String> sources,
    required String authorOrEditor,
    int version = 1,
    String reviewState = 'APPROVED',
  }) {
    final objectivesPayload = objectives.map((o) => '${o.objectiveId}:${o.title}').join(';');
    final sectionsPayload = sections.map((s) => s.integrityHash).join(';');
    final sourcesPayload = sources.join(',');

    final payload = '$lessonId|$title|$courseId|$moduleId|$orderIndex|$objectivesPayload|$sectionsPayload|$sourcesPayload|$authorOrEditor|$version|$reviewState';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return Lesson(
      lessonId: lessonId,
      title: title,
      courseId: courseId,
      moduleId: moduleId,
      orderIndex: orderIndex,
      objectives: objectives,
      sections: sections,
      sources: sources,
      authorOrEditor: authorOrEditor,
      version: version,
      reviewState: reviewState,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    for (final s in sections) {
      if (!s.verifyHash()) return false;
    }
    final objectivesPayload = objectives.map((o) => '${o.objectiveId}:${o.title}').join(';');
    final sectionsPayload = sections.map((s) => s.integrityHash).join(';');
    final sourcesPayload = sources.join(',');

    final payload = '$lessonId|$title|$courseId|$moduleId|$orderIndex|$objectivesPayload|$sectionsPayload|$sourcesPayload|$authorOrEditor|$version|$reviewState';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'lesson_id': lessonId,
      'title': title,
      'course_id': courseId,
      'module_id': moduleId,
      'order_index': orderIndex,
      'objectives': objectives.map((o) => o.toMap()).toList(),
      'sections': sections.map((s) => s.toMap()).toList(),
      'sources': sources,
      'author_or_editor': authorOrEditor,
      'version': version,
      'review_state': reviewState,
      'integrity_hash': integrityHash,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    final rawObjectives = map['objectives'] as List<dynamic>? ?? [];
    final objectives = rawObjectives.map((o) => LearningObjective.fromMap(o as Map<String, dynamic>)).toList();

    final rawSections = map['sections'] as List<dynamic>? ?? [];
    final sections = rawSections.map((s) => LessonSection.fromMap(s as Map<String, dynamic>)).toList();

    final rawSources = map['sources'] as List<dynamic>? ?? [];

    return Lesson(
      lessonId: map['lesson_id'] as String,
      title: map['title'] as String,
      courseId: map['course_id'] as String,
      moduleId: map['module_id'] as String,
      orderIndex: map['order_index'] as int,
      objectives: objectives,
      sections: sections,
      sources: rawSources.map((s) => s.toString()).toList(),
      authorOrEditor: map['author_or_editor'] as String,
      version: map['version'] as int? ?? 1,
      reviewState: map['review_state'] as String? ?? 'APPROVED',
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        lessonId,
        title,
        courseId,
        moduleId,
        orderIndex,
        objectives,
        sections,
        sources,
        authorOrEditor,
        version,
        reviewState,
        integrityHash,
      ];
}
