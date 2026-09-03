import 'package:equatable/equatable.dart';
import 'assessment_result.dart';
import 'learning_goal.dart';
import 'revision_item.dart';

/// User's isolated, local learning progress with version-aware completion (§20, §35, §36).
class LearningProgress extends Equatable {
  final Map<String, int> completedLessonVersions; // lessonId -> version completed
  final List<AssessmentResult> assessmentResults;
  final List<RevisionItem> revisionQueue;
  final LearningGoal? learningGoal;
  final String? lastStudiedLessonId;
  final Set<String> bookmarkedLessonIds;
  final Map<String, String> userNotes; // lessonId -> note
  final DateTime updatedAt;

  const LearningProgress({
    this.completedLessonVersions = const {},
    this.assessmentResults = const [],
    this.revisionQueue = const [],
    this.learningGoal,
    this.lastStudiedLessonId,
    this.bookmarkedLessonIds = const {},
    this.userNotes = const {},
    required this.updatedAt,
  });

  /// Checks whether a lesson was completed, specifically matching the current version or any version.
  bool isLessonCompleted(String lessonId, [int? currentVersion]) {
    final completedVersion = completedLessonVersions[lessonId];
    if (completedVersion == null) return false;
    if (currentVersion != null) return completedVersion == currentVersion;
    return true;
  }

  int? getCompletedVersion(String lessonId) => completedLessonVersions[lessonId];

  LearningProgress copyWith({
    Map<String, int>? completedLessonVersions,
    List<AssessmentResult>? assessmentResults,
    List<RevisionItem>? revisionQueue,
    LearningGoal? learningGoal,
    String? lastStudiedLessonId,
    Set<String>? bookmarkedLessonIds,
    Map<String, String>? userNotes,
    DateTime? updatedAt,
  }) {
    return LearningProgress(
      completedLessonVersions: completedLessonVersions ?? this.completedLessonVersions,
      assessmentResults: assessmentResults ?? this.assessmentResults,
      revisionQueue: revisionQueue ?? this.revisionQueue,
      learningGoal: learningGoal ?? this.learningGoal,
      lastStudiedLessonId: lastStudiedLessonId ?? this.lastStudiedLessonId,
      bookmarkedLessonIds: bookmarkedLessonIds ?? this.bookmarkedLessonIds,
      userNotes: userNotes ?? this.userNotes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'completed_lesson_versions': completedLessonVersions,
      'assessment_results': assessmentResults.map((a) => a.toMap()).toList(),
      'revision_queue': revisionQueue.map((r) => r.toMap()).toList(),
      'learning_goal': learningGoal?.toMap(),
      'last_studied_lesson_id': lastStudiedLessonId,
      'bookmarked_lesson_ids': bookmarkedLessonIds.toList(),
      'user_notes': userNotes,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory LearningProgress.fromMap(Map<String, dynamic> map) {
    final rawCompleted = map['completed_lesson_versions'] as Map<String, dynamic>? ?? {};
    final compMap = rawCompleted.map((k, v) => MapEntry(k, v as int));

    final rawAssessments = map['assessment_results'] as List<dynamic>? ?? [];
    final assessments = rawAssessments.map((a) => AssessmentResult.fromMap(a as Map<String, dynamic>)).toList();

    final rawRevisions = map['revision_queue'] as List<dynamic>? ?? [];
    final revisions = rawRevisions.map((r) => RevisionItem.fromMap(r as Map<String, dynamic>)).toList();

    final rawGoal = map['learning_goal'] as Map<String, dynamic>?;
    final rawBookmarks = map['bookmarked_lesson_ids'] as List<dynamic>? ?? [];
    final rawNotes = map['user_notes'] as Map<String, dynamic>? ?? {};

    return LearningProgress(
      completedLessonVersions: compMap,
      assessmentResults: assessments,
      revisionQueue: revisions,
      learningGoal: rawGoal != null ? LearningGoal.fromMap(rawGoal) : null,
      lastStudiedLessonId: map['last_studied_lesson_id'] as String?,
      bookmarkedLessonIds: rawBookmarks.map((e) => e.toString()).toSet(),
      userNotes: rawNotes.map((k, v) => MapEntry(k, v.toString())),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        completedLessonVersions,
        assessmentResults,
        revisionQueue,
        learningGoal,
        lastStudiedLessonId,
        bookmarkedLessonIds,
        userNotes,
        updatedAt,
      ];
}
