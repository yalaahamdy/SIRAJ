import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Knowledge & Learning Integration Suite (§3, §57..§62, §120)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(
        storageRegistry: storage,
        knowledgeModule: knowledgeModule,
      );
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Integration 1: Learning lesson dynamically resolves and cross-references Knowledge evidence', () {
      final lessonRes = learningModule.getLesson('lsn_wudu_pillars');
      expect(lessonRes.isSuccess, isTrue);

      final lesson = lessonRes.valueOrNull!;
      expect(lesson.sections, isNotEmpty);
      expect(lesson.sections.first.evidenceLinks, isNotEmpty);

      // Verify that the linked source exists in knowledge module
      final evLink = lesson.sections.first.evidenceLinks.first;
      expect(evLink.citation, contains('المائدة: 6'));
    });
  });
}
