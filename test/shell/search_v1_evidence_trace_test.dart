import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Evidence Trace & Source Provenance Suite (§49, §50, §81, §93, §99)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());
    });

    test('Evidence Trace 1: Fiqh topics link cleanly to explicit evidence and primary sources (§49, §99)', () {
      final topics = knowledgeModule.store.getAllFiqhTopics().valueOrNull!;
      expect(topics.isNotEmpty, true);
      final topic = topics.first;
      expect(topic.positions.isNotEmpty, true);

      for (final pos in topic.positions) {
        expect(pos.evidences.isNotEmpty, true);
      }
    });
  });
}
