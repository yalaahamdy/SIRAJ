import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah & Knowledge Integration Suite (§52, §54, §107)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      seerahModule = SeerahModule(
        storageRegistry: storage,
        knowledgeModule: knowledgeModule,
      );
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    test('Integration 1: NarrativeEngine resolves verified Hadith evidence for event', () {
      final refsRes = seerahModule.resolveEventReferences('evt_badr_major');
      expect(refsRes.isSuccess, isTrue);

      final refs = refsRes.valueOrNull!;
      expect(refs.event.relatedHadithIds, contains('hadith_001'));
      expect(refs.hadiths, isNotEmpty);
      expect(refs.hadiths.first.hadithId, equals('hadith_001'));
    });
  });
}
