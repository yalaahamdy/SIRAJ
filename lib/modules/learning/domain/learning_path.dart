import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

/// Progressive difficulty and depth levels for learning curricula (§9).
enum LearningLevel {
  beginner('مبتدئ / تأسيسي'),
  intermediate('متوسط / تأصيلي'),
  advanced('متقدم / استدلالي');

  final String labelArabic;
  const LearningLevel(this.labelArabic);
}

/// Structured Learning Path overarching multiple courses (§4, §8, §37).
class LearningPath extends Equatable {
  final String pathId;
  final String title;
  final String description;
  final String category;
  final LearningLevel level;
  final List<String> courseIds;
  final List<String> prerequisites;
  final int estimatedHours;
  final String integrityHash;

  const LearningPath({
    required this.pathId,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.courseIds,
    this.prerequisites = const [],
    this.estimatedHours = 10,
    required this.integrityHash,
  });

  factory LearningPath.create({
    required String pathId,
    required String title,
    required String description,
    required String category,
    required LearningLevel level,
    required List<String> courseIds,
    List<String> prerequisites = const [],
    int estimatedHours = 10,
  }) {
    final coursesPayload = courseIds.join(',');
    final prereqsPayload = prerequisites.join(',');
    final payload = '$pathId|$title|$description|$category|${level.name}|$coursesPayload|$prereqsPayload|$estimatedHours';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return LearningPath(
      pathId: pathId,
      title: title,
      description: description,
      category: category,
      level: level,
      courseIds: courseIds,
      prerequisites: prerequisites,
      estimatedHours: estimatedHours,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final coursesPayload = courseIds.join(',');
    final prereqsPayload = prerequisites.join(',');
    final payload = '$pathId|$title|$description|$category|${level.name}|$coursesPayload|$prereqsPayload|$estimatedHours';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'path_id': pathId,
      'title': title,
      'description': description,
      'category': category,
      'level': level.name,
      'course_ids': courseIds,
      'prerequisites': prerequisites,
      'estimated_hours': estimatedHours,
      'integrity_hash': integrityHash,
    };
  }

  factory LearningPath.fromMap(Map<String, dynamic> map) {
    final rawCourses = map['course_ids'] as List<dynamic>? ?? [];
    final rawPrereqs = map['prerequisites'] as List<dynamic>? ?? [];

    return LearningPath(
      pathId: map['path_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      level: LearningLevel.values.byName(map['level'] as String),
      courseIds: rawCourses.map((e) => e.toString()).toList(),
      prerequisites: rawPrereqs.map((e) => e.toString()).toList(),
      estimatedHours: map['estimated_hours'] as int? ?? 10,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        pathId,
        title,
        description,
        category,
        level,
        courseIds,
        prerequisites,
        estimatedHours,
        integrityHash,
      ];
}
