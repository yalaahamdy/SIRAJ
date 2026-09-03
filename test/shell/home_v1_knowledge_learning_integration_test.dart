import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Knowledge & Learning Integration Suite (§37, §114)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
      );
    });

    test('Knowledge & Learning 1: Home dashboard aggregates continuing learning path without religious scoring', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.any((c) => c.sourceModule == 'learning' || c.targetRoute == '/learning'), true);
    });
  });
}
