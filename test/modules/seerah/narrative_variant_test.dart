import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/seerah/engine/narrative_engine.dart';
import 'package:siraj/modules/seerah/store/read_only_seerah_store.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('L2 Seerah Narrative Variants & References Tests (§13, §14, §17, §19)', () {
    late ReadOnlySeerahStore seerahStore;
    late KnowledgeModule knowledgeModule;
    late NarrativeEngine narrativeEngine;

    setUp(() {
      final registry = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      final knowPkg = SyntheticKnowledgeFixtures.createPackage();
      knowledgeModule.mountPackage(knowPkg);

      seerahStore = ReadOnlySeerahStore();
      final seerahPkg = SyntheticSeerahFixtures.createPackage();
      seerahStore.mountPackage(seerahPkg);

      narrativeEngine = NarrativeEngine(
        seerahStore: seerahStore,
        knowledgeModule: knowledgeModule,
      );
    });

    test('Preserves multiple variants without silent collapsing', () {
      final eventRes = seerahStore.getEvent('evt_badr_major');
      expect(eventRes.isSuccess, isTrue);
      final event = eventRes.valueOrNull!;

      expect(event.variants.isNotEmpty, isTrue);
      final variant = event.variants.first;
      expect(variant.narratorOrScholar, equals('موسى بن عقبة'));
      expect(variant.narrativeSummary, contains('ثلاثمائة وبضعة عشر رجلاً'));
    });

    test('Resolves underlying Hadith and Source records from Knowledge Module', () {
      final res = narrativeEngine.resolveEventReferences('evt_badr_major');
      expect(res.isSuccess, isTrue);
      final resolved = res.valueOrNull!;

      expect(resolved.hadiths.isNotEmpty, isTrue);
      expect(resolved.hadiths.first.arabicMatn, contains('إنما الأعمال بالنيات'));
    });
  });
}
