import 'package:equatable/equatable.dart';

/// Assessment attempt result record (§15, §16, §20).
class AssessmentResult extends Equatable {
  final String assessmentId;
  final String quizId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final bool passed;
  final Map<String, bool> questionResults; // questionId -> isCorrect
  final DateTime completedAt;

  const AssessmentResult({
    required this.assessmentId,
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.passed,
    required this.questionResults,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'assessment_id': assessmentId,
      'quiz_id': quizId,
      'score': score,
      'total_questions': totalQuestions,
      'percentage': percentage,
      'passed': passed,
      'question_results': questionResults,
      'completed_at': completedAt.toIso8601String(),
    };
  }

  factory AssessmentResult.fromMap(Map<String, dynamic> map) {
    final rawResults = map['question_results'] as Map<String, dynamic>? ?? {};
    final qMap = rawResults.map((k, v) => MapEntry(k, v as bool));

    return AssessmentResult(
      assessmentId: map['assessment_id'] as String,
      quizId: map['quiz_id'] as String,
      score: map['score'] as int,
      totalQuestions: map['total_questions'] as int,
      percentage: (map['percentage'] as num).toDouble(),
      passed: map['passed'] as bool,
      questionResults: qMap,
      completedAt: DateTime.parse(map['completed_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        assessmentId,
        quizId,
        score,
        totalQuestions,
        percentage,
        passed,
        questionResults,
        completedAt,
      ];
}
