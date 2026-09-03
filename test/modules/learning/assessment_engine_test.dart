import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/learning/engine/assessment_engine.dart';
import 'package:siraj/modules/learning/store/read_only_learning_store.dart';
import '../../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('L2 Assessment Engine & Sourced Explanations Tests (§15, §16)', () {
    late ReadOnlyLearningStore store;
    late AssessmentEngine engine;

    setUp(() {
      store = ReadOnlyLearningStore();
      engine = AssessmentEngine(store: store);
      final pkg = SyntheticLearningFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('Correct answer submission evaluates to 100% and passed with sourced feedback', () {
      final reportRes = engine.evaluateQuiz(
        quizId: 'quiz_wudu_1',
        userAnswers: {
          'q_wudu_count': [0], // Correct option index
        },
      );

      expect(reportRes.isSuccess, isTrue);
      final report = reportRes.valueOrNull!;

      expect(report.result.score, equals(1));
      expect(report.result.totalQuestions, equals(1));
      expect(report.result.percentage, equals(100.0));
      expect(report.result.passed, isTrue);
      expect(report.feedback.first.isCorrect, isTrue);
      expect(report.feedback.first.explanation.contains('الفرائض المنصوصة'), isTrue);
    });

    test('Incorrect answer submission evaluates to 0% and failed with explanation', () {
      final reportRes = engine.evaluateQuiz(
        quizId: 'quiz_wudu_1',
        userAnswers: {
          'q_wudu_count': [1], // Incorrect option index
        },
      );

      expect(reportRes.isSuccess, isTrue);
      final report = reportRes.valueOrNull!;

      expect(report.result.score, equals(0));
      expect(report.result.percentage, equals(0.0));
      expect(report.result.passed, isFalse);
      expect(report.feedback.first.isCorrect, isFalse);
    });
  });
}
