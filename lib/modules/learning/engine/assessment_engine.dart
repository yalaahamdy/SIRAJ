import 'dart:math';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/assessment_result.dart';
import '../domain/quiz_question.dart';
import '../store/read_only_learning_store.dart';

/// Detailed feedback item for an evaluated quiz question (§15, §16).
class QuestionFeedback {
  final QuizQuestion question;
  final List<int> selectedIndices;
  final bool isCorrect;
  final String explanation;

  const QuestionFeedback({
    required this.question,
    required this.selectedIndices,
    required this.isCorrect,
    required this.explanation,
  });
}

/// Evaluation outcome encompassing the recorded result and per-question explanations (§15, §16).
class QuizEvaluationReport {
  final AssessmentResult result;
  final List<QuestionFeedback> feedback;

  const QuizEvaluationReport({
    required this.result,
    required this.feedback,
  });
}

/// Engine evaluating quiz answers and generating sourced explanations (§15, §16).
class AssessmentEngine {
  final ReadOnlyLearningStore _store;

  const AssessmentEngine({required ReadOnlyLearningStore store}) : _store = store;

  /// Evaluates user answers against a Quiz.
  Result<QuizEvaluationReport, Failure> evaluateQuiz({
    required String quizId,
    required Map<String, List<int>> userAnswers, // questionId -> selectedOptionIndices
  }) {
    final quizRes = _store.getQuiz(quizId);
    if (quizRes.isFailure) return Result.err(quizRes.failureOrNull!);

    final quiz = quizRes.valueOrNull!;
    int correctCount = 0;
    final questionResults = <String, bool>{};
    final feedbackList = <QuestionFeedback>[];

    for (final q in quiz.questions) {
      final selected = userAnswers[q.questionId] ?? [];
      final isCorrect = _areListsEqual(selected, q.correctOptionIndices);

      if (isCorrect) correctCount++;
      questionResults[q.questionId] = isCorrect;

      feedbackList.add(
        QuestionFeedback(
          question: q,
          selectedIndices: selected,
          isCorrect: isCorrect,
          explanation: q.explanation,
        ),
      );
    }

    final total = quiz.questions.length;
    final percentage = total > 0 ? (correctCount / total) * 100.0 : 0.0;
    final passed = percentage >= quiz.passingScorePercentage;

    final assessmentResult = AssessmentResult(
      assessmentId: 'attempt_${quizId}_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}',
      quizId: quizId,
      score: correctCount,
      totalQuestions: total,
      percentage: percentage,
      passed: passed,
      questionResults: questionResults,
      completedAt: DateTime.now().toUtc(),
    );

    return Result.ok(
      QuizEvaluationReport(
        result: assessmentResult,
        feedback: feedbackList,
      ),
    );
  }

  bool _areListsEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    final sortedA = List<int>.from(a)..sort();
    final sortedB = List<int>.from(b)..sort();
    for (int i = 0; i < sortedA.length; i++) {
      if (sortedA[i] != sortedB[i]) return false;
    }
    return true;
  }
}
