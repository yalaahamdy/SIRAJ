import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Knowledge & Learning Performance Suite (§68..§71, §118, §120)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Performance 1: Knowledge search across mounted items completes in < 50ms', () {
      final stopwatch = Stopwatch()..start();
      final res = knowledgeModule.search('النيات');
      stopwatch.stop();

      expect(res.isSuccess, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });

    test('Performance 2: Quiz evaluation completes in < 50ms', () {
      final stopwatch = Stopwatch()..start();
      final res = learningModule.evaluateQuiz(
        quizId: 'quiz_wudu_1',
        userAnswers: {
          'q_wudu_count': [0],
        },
      );
      stopwatch.stop();

      expect(res.isSuccess, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50));
    });
  });
}
