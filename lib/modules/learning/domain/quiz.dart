import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'quiz_question.dart';

/// Assessment Quiz entity linked to a lesson or module (§15, §16).
class Quiz extends Equatable {
  final String quizId;
  final String lessonId;
  final String title;
  final List<QuizQuestion> questions;
  final int passingScorePercentage;
  final int? timeLimitMinutes;
  final String integrityHash;

  const Quiz({
    required this.quizId,
    required this.lessonId,
    required this.title,
    required this.questions,
    this.passingScorePercentage = 70,
    this.timeLimitMinutes,
    required this.integrityHash,
  });

  factory Quiz.create({
    required String quizId,
    required String lessonId,
    required String title,
    required List<QuizQuestion> questions,
    int passingScorePercentage = 70,
    int? timeLimitMinutes,
  }) {
    final questionsPayload = questions.map((q) => q.integrityHash).join(';');
    final payload = '$quizId|$lessonId|$title|$questionsPayload|$passingScorePercentage|${timeLimitMinutes ?? ''}';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return Quiz(
      quizId: quizId,
      lessonId: lessonId,
      title: title,
      questions: questions,
      passingScorePercentage: passingScorePercentage,
      timeLimitMinutes: timeLimitMinutes,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    for (final q in questions) {
      if (!q.verifyHash()) return false;
    }
    final questionsPayload = questions.map((q) => q.integrityHash).join(';');
    final payload = '$quizId|$lessonId|$title|$questionsPayload|$passingScorePercentage|${timeLimitMinutes ?? ''}';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'quiz_id': quizId,
      'lesson_id': lessonId,
      'title': title,
      'questions': questions.map((q) => q.toMap()).toList(),
      'passing_score_percentage': passingScorePercentage,
      'time_limit_minutes': timeLimitMinutes,
      'integrity_hash': integrityHash,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    final rawQuestions = map['questions'] as List<dynamic>? ?? [];

    return Quiz(
      quizId: map['quiz_id'] as String,
      lessonId: map['lesson_id'] as String,
      title: map['title'] as String,
      questions: rawQuestions.map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>)).toList(),
      passingScorePercentage: map['passing_score_percentage'] as int? ?? 70,
      timeLimitMinutes: map['time_limit_minutes'] as int?,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        quizId,
        lessonId,
        title,
        questions,
        passingScorePercentage,
        timeLimitMinutes,
        integrityHash,
      ];
}
