import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Search Result Routing & Target Route Fidelity Suite (§34..§37, §93)', () {
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

    test('Routing 1: Search results declare valid and non-empty targetRoute destinations', () async {
      final res = await companionModule.search('الله');
      expect(res.isSuccess, true);

      for (final result in res.valueOrNull!) {
        expect(result.targetRoute.startsWith('/'), true);
        expect(result.itemId.isNotEmpty, true);
      }
    });
  });
}
