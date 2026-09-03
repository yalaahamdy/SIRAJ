import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'evidence_link.dart';

/// Question formats supported in the assessment engine (§15).
enum QuestionType {
  multipleChoice('اختيار من متعدد'),
  trueFalse('صواب أو خطأ'),
  matching('مطابقة المفاهيم'),
  ordering('ترتيب تسلسلي'),
  recall('استدعاء واستحضار'),
  evidenceSelection('تحديد الدليل الشرعي');

  final String labelArabic;
  const QuestionType(this.labelArabic);
}

/// Option choice within a question (§15, §16).
class QuizOption extends Equatable {
  final String optionId;
  final String text;

  const QuizOption({
    required this.optionId,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'option_id': optionId,
      'text': text,
    };
  }

  factory QuizOption.fromMap(Map<String, dynamic> map) {
    return QuizOption(
      optionId: map['option_id'] as String,
      text: map['text'] as String,
    );
  }

  @override
  List<Object?> get props => [optionId, text];
}

/// Sourced and pedagogical assessment question (§15, §16, §17, §18).
class QuizQuestion extends Equatable {
  final String questionId;
  final String lessonId;
  final String questionText;
  final QuestionType questionType;
  final List<QuizOption> options;
  final List<int> correctOptionIndices;
  final String explanation;
  final EvidenceLink? evidenceLink;
  final String? sourceId;
  final String integrityHash;

  const QuizQuestion({
    required this.questionId,
    required this.lessonId,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.correctOptionIndices,
    required this.explanation,
    this.evidenceLink,
    this.sourceId,
    required this.integrityHash,
  });

  factory QuizQuestion.create({
    required String questionId,
    required String lessonId,
    required String questionText,
    required QuestionType questionType,
    required List<QuizOption> options,
    required List<int> correctOptionIndices,
    required String explanation,
    EvidenceLink? evidenceLink,
    String? sourceId,
  }) {
    final optionsPayload = options.map((o) => '${o.optionId}:${o.text}').join(';');
    final correctPayload = correctOptionIndices.join(',');
    final evPayload = evidenceLink?.integrityHash ?? '';

    final payload = '$questionId|$lessonId|$questionText|${questionType.name}|$optionsPayload|$correctPayload|$explanation|$evPayload|${sourceId ?? ''}';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return QuizQuestion(
      questionId: questionId,
      lessonId: lessonId,
      questionText: questionText,
      questionType: questionType,
      options: options,
      correctOptionIndices: correctOptionIndices,
      explanation: explanation,
      evidenceLink: evidenceLink,
      sourceId: sourceId,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final optionsPayload = options.map((o) => '${o.optionId}:${o.text}').join(';');
    final correctPayload = correctOptionIndices.join(',');
    final evPayload = evidenceLink?.integrityHash ?? '';

    final payload = '$questionId|$lessonId|$questionText|${questionType.name}|$optionsPayload|$correctPayload|$explanation|$evPayload|${sourceId ?? ''}';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'lesson_id': lessonId,
      'question_text': questionText,
      'question_type': questionType.name,
      'options': options.map((o) => o.toMap()).toList(),
      'correct_option_indices': correctOptionIndices,
      'explanation': explanation,
      'evidence_link': evidenceLink?.toMap(),
      'source_id': sourceId,
      'integrity_hash': integrityHash,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    final rawOptions = map['options'] as List<dynamic>? ?? [];
    final rawCorrect = map['correct_option_indices'] as List<dynamic>? ?? [];
    final rawEv = map['evidence_link'] as Map<String, dynamic>?;

    return QuizQuestion(
      questionId: map['question_id'] as String,
      lessonId: map['lesson_id'] as String,
      questionText: map['question_text'] as String,
      questionType: QuestionType.values.byName(map['question_type'] as String),
      options: rawOptions.map((o) => QuizOption.fromMap(o as Map<String, dynamic>)).toList(),
      correctOptionIndices: rawCorrect.map((e) => e as int).toList(),
      explanation: map['explanation'] as String,
      evidenceLink: rawEv != null ? EvidenceLink.fromMap(rawEv) : null,
      sourceId: map['source_id'] as String?,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        questionId,
        lessonId,
        questionText,
        questionType,
        options,
        correctOptionIndices,
        explanation,
        evidenceLink,
        sourceId,
        integrityHash,
      ];
}
