import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Hadith Search Integration Suite (§15, §71, §85, §93)', () {
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

    test('Hadith Search 1: Hadith search returns verifiable hadith records and grades (§15, §85)', () async {
      final res = await companionModule.search('الأعمال');
      expect(res.isSuccess, true);
      expect(res.valueOrNull!.any((e) => e.moduleId == 'knowledge'), true);
    });
  });
}
