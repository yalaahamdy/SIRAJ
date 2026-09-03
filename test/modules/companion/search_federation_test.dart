import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/services/search_federation_service.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 Search Federation Tests (§42, §43)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late SearchFederationService searchService;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      searchService = SearchFederationService(
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    test('Searches across multiple modules in parallel and unifies results with provenance', () async {
      final res = await searchService.search('النية');
      expect(res.isSuccess, isTrue);
      final results = res.valueOrNull!;

      expect(results.isNotEmpty, isTrue);
      expect(results.any((r) => r.moduleId == 'knowledge'), isTrue);
      expect(results.first.provenanceState, equals('APPROVED'));
    });

    test('Empty or whitespace query returns empty results immediately', () async {
      final res = await searchService.search('   ');
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull!.isEmpty, isTrue);
    });
  });
}
