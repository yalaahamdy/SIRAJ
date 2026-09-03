import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Source Registry & Traceability Suite (§16..§18, §116, §118)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());
    });

    test('Source 1: Source registry returns authoritative records with author and provenance (§17)', () {
      final sourcesRes = knowledgeModule.sourceRegistryService.getAllSources();
      expect(sourcesRes.isSuccess, true);
      final sources = sourcesRes.valueOrNull!;
      expect(sources.isNotEmpty, true);

      final bukhari = sources.firstWhere((s) => s.sourceId == 'src_bukhari_test');
      expect(bukhari.title, contains('صحيح البخاري'));
      expect(bukhari.author, contains('البخاري'));
      expect(bukhari.reviewState, isNotEmpty);
    });
  });
}
