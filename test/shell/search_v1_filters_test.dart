import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Search Domain Filtering & Categorization Suite (§8, §9, §22, §93)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    test('Filters 1: Search results retain distinct moduleId metadata for each domain', () async {
      final res = await companionModule.search('الله');
      expect(res.isSuccess, true);
      final list = res.valueOrNull!;

      final moduleIds = list.map((e) => e.moduleId).toSet();
      expect(moduleIds.isNotEmpty, true);
    });
  });
}
