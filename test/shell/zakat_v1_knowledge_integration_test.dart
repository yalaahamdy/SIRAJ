import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat & Knowledge Module Integration Suite (§98..§100, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());
    });

    test('Knowledge Integration 1: Zakat module and Knowledge module coexist and cross-reference safely', () async {
      // 1. Check policies in Zakat
      final policies = zakatModule.getAvailablePolicies();
      expect(policies.isNotEmpty, true);

      // 2. Knowledge module provides fiqh topics and hadiths
      final topics = knowledgeModule.store.getAllFiqhTopics();
      expect(topics.isSuccess, true);
      expect(topics.valueOrNull!.isNotEmpty, true);

      // 3. Modifying zakat assets has zero effect on knowledge store
      await zakatModule.setActivePolicy(policies.first.policyId);
      final topicsAfter = knowledgeModule.store.getAllFiqhTopics();
      expect(topicsAfter.isSuccess, true);
      expect(topicsAfter.valueOrNull!.length, topics.valueOrNull!.length);
    });
  });
}
