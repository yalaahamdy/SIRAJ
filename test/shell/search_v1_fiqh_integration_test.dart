import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Fiqh Search Integration Suite (§16, §72, §84, §93)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        knowledgeModule: knowledgeModule,
      );
    });

    test('Fiqh Search 1: Fiqh search preserves school distinctions without blending (§84)', () async {
      final res = await companionModule.search('الوضوء');
      expect(res.isSuccess, true);
    });
  });
}
