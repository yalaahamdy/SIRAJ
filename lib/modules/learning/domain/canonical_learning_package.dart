import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'course.dart';
import 'course_module.dart';
import 'learning_path.dart';
import 'lesson.dart';
import 'quiz.dart';

/// Cryptographically signed canonical learning package (§33, §34).
class CanonicalLearningPackage extends Equatable {
  final String packageId;
  final String schemaVersion;
  final List<LearningPath> paths;
  final List<Course> courses;
  final List<CourseModule> modules;
  final List<Lesson> lessons;
  final List<Quiz> quizzes;
  final String contentHash;
  final String signerIdentity;
  final String signature;
  final DateTime publishedAt;

  const CanonicalLearningPackage({
    required this.packageId,
    required this.schemaVersion,
    required this.paths,
    required this.courses,
    required this.modules,
    required this.lessons,
    required this.quizzes,
    required this.contentHash,
    required this.signerIdentity,
    required this.signature,
    required this.publishedAt,
  });

  /// Factory creating package with computed aggregate SHA-256 hash.
  factory CanonicalLearningPackage.create({
    required String packageId,
    String schemaVersion = '1.0.0',
    required List<LearningPath> paths,
    required List<Course> courses,
    required List<CourseModule> modules,
    required List<Lesson> lessons,
    required List<Quiz> quizzes,
    required String signerIdentity,
    required String signature,
    required DateTime publishedAt,
  }) {
    final pathsHash = paths.map((p) => p.integrityHash).join(';');
    final coursesHash = courses.map((c) => c.integrityHash).join(';');
    final lessonsHash = lessons.map((l) => l.integrityHash).join(';');
    final quizzesHash = quizzes.map((q) => q.integrityHash).join(';');

    final rawPayload = '$packageId|$schemaVersion|$pathsHash|$coursesHash|$lessonsHash|$quizzesHash|$signerIdentity|${publishedAt.toIso8601String()}';
    final computedHash = 'sha256:${sha256.convert(utf8.encode(rawPayload)).toString()}';

    return CanonicalLearningPackage(
      packageId: packageId,
      schemaVersion: schemaVersion,
      paths: paths,
      courses: courses,
      modules: modules,
      lessons: lessons,
      quizzes: quizzes,
      contentHash: computedHash,
      signerIdentity: signerIdentity,
      signature: signature,
      publishedAt: publishedAt,
    );
  }

  /// Verifies internal cryptographic integrity and all entity hashes.
  bool verifyPackageIntegrity() {
    if (signature.isEmpty || signerIdentity.isEmpty) return false;

    for (final p in paths) {
      if (!p.verifyHash()) return false;
    }
    for (final c in courses) {
      if (!c.verifyHash()) return false;
    }
    for (final l in lessons) {
      if (!l.verifyHash()) return false;
    }
    for (final q in quizzes) {
      if (!q.verifyHash()) return false;
    }

    final pathsHash = paths.map((p) => p.integrityHash).join(';');
    final coursesHash = courses.map((c) => c.integrityHash).join(';');
    final lessonsHash = lessons.map((l) => l.integrityHash).join(';');
    final quizzesHash = quizzes.map((q) => q.integrityHash).join(';');

    final rawPayload = '$packageId|$schemaVersion|$pathsHash|$coursesHash|$lessonsHash|$quizzesHash|$signerIdentity|${publishedAt.toIso8601String()}';
    final expectedHash = 'sha256:${sha256.convert(utf8.encode(rawPayload)).toString()}';

    return contentHash == expectedHash;
  }

  Map<String, dynamic> toMap() {
    return {
      'package_id': packageId,
      'schema_version': schemaVersion,
      'paths': paths.map((p) => p.toMap()).toList(),
      'courses': courses.map((c) => c.toMap()).toList(),
      'modules': modules.map((m) => m.toMap()).toList(),
      'lessons': lessons.map((l) => l.toMap()).toList(),
      'quizzes': quizzes.map((q) => q.toMap()).toList(),
      'content_hash': contentHash,
      'signer_identity': signerIdentity,
      'signature': signature,
      'published_at': publishedAt.toIso8601String(),
    };
  }

  factory CanonicalLearningPackage.fromMap(Map<String, dynamic> map) {
    final rawPaths = map['paths'] as List<dynamic>? ?? [];
    final rawCourses = map['courses'] as List<dynamic>? ?? [];
    final rawModules = map['modules'] as List<dynamic>? ?? [];
    final rawLessons = map['lessons'] as List<dynamic>? ?? [];
    final rawQuizzes = map['quizzes'] as List<dynamic>? ?? [];

    return CanonicalLearningPackage(
      packageId: map['package_id'] as String,
      schemaVersion: map['schema_version'] as String? ?? '1.0.0',
      paths: rawPaths.map((p) => LearningPath.fromMap(p as Map<String, dynamic>)).toList(),
      courses: rawCourses.map((c) => Course.fromMap(c as Map<String, dynamic>)).toList(),
      modules: rawModules.map((m) => CourseModule.fromMap(m as Map<String, dynamic>)).toList(),
      lessons: rawLessons.map((l) => Lesson.fromMap(l as Map<String, dynamic>)).toList(),
      quizzes: rawQuizzes.map((q) => Quiz.fromMap(q as Map<String, dynamic>)).toList(),
      contentHash: map['content_hash'] as String,
      signerIdentity: map['signer_identity'] as String,
      signature: map['signature'] as String,
      publishedAt: DateTime.parse(map['published_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        packageId,
        schemaVersion,
        paths,
        courses,
        modules,
        lessons,
        quizzes,
        contentHash,
        signerIdentity,
        signature,
        publishedAt,
      ];
}
