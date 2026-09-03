import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import '../domain/learning_path.dart';

/// Structured Islamic Course entity (§5, §37).
class Course extends Equatable {
  final String courseId;
  final String pathId;
  final String title;
  final String description;
  final LearningLevel level;
  final List<String> moduleIds;
  final String author;
  final int version;
  final String integrityHash;

  const Course({
    required this.courseId,
    required this.pathId,
    required this.title,
    required this.description,
    required this.level,
    required this.moduleIds,
    required this.author,
    this.version = 1,
    required this.integrityHash,
  });

  factory Course.create({
    required String courseId,
    required String pathId,
    required String title,
    required String description,
    required LearningLevel level,
    required List<String> moduleIds,
    required String author,
    int version = 1,
  }) {
    final modulesPayload = moduleIds.join(',');
    final payload = '$courseId|$pathId|$title|$description|${level.name}|$modulesPayload|$author|$version';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return Course(
      courseId: courseId,
      pathId: pathId,
      title: title,
      description: description,
      level: level,
      moduleIds: moduleIds,
      author: author,
      version: version,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final modulesPayload = moduleIds.join(',');
    final payload = '$courseId|$pathId|$title|$description|${level.name}|$modulesPayload|$author|$version';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'course_id': courseId,
      'path_id': pathId,
      'title': title,
      'description': description,
      'level': level.name,
      'module_ids': moduleIds,
      'author': author,
      'version': version,
      'integrity_hash': integrityHash,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    final rawModules = map['module_ids'] as List<dynamic>? ?? [];

    return Course(
      courseId: map['course_id'] as String,
      pathId: map['path_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      level: LearningLevel.values.byName(map['level'] as String),
      moduleIds: rawModules.map((e) => e.toString()).toList(),
      author: map['author'] as String,
      version: map['version'] as int? ?? 1,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        courseId,
        pathId,
        title,
        description,
        level,
        moduleIds,
        author,
        version,
        integrityHash,
      ];
}
