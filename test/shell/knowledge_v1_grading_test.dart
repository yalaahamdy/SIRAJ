import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: Hadith Grading & Scholar Attribution Suite (§13..§15, §116, §120)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());
    });

    test('Grading 1: Every Hadith entity preserves its canonical gradings and scholar attributions', () {
      final hadiths = knowledgeModule.store.getAllHadiths().valueOrNull!;
      expect(hadiths.isNotEmpty, true);

      for (final h in hadiths) {
        expect(h.gradings.isNotEmpty, true);
        for (final g in h.gradings) {
          expect(g.scholarName.isNotEmpty, true);
          expect(g.grade.labelArabic.isNotEmpty, true);
        }
      }
    });
  });
}
