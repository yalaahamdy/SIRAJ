import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Knowledge Graph & Verified Relations Suite (§28, §29, §116)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());
    });

    test('Graph 1: Knowledge graph fetches verified related topics and references', () {
      final relatedRes = knowledgeModule.graphService.getRelationsFor('fiqh_niyyah_fasting');
      expect(relatedRes.isSuccess, true);
    });
  });
}
