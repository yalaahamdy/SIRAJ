import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/domain/knowledge_relation.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Evidence & Graph Reference Suite (§20..§22, §98..§100, §120)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());
    });

    test('Evidence 1: Graph service correctly links Hadith as evidence for Fiqh topic', () {
      final relationsRes = knowledgeModule.graphService.getEvidencesFor('topic_niyyah_fasting');
      expect(relationsRes.isSuccess, isTrue);
      final relations = relationsRes.valueOrNull!;
      expect(relations, isNotEmpty);
      expect(relations.first.sourceKey, equals('hadith_001'));
      expect(relations.first.relationType, equals(RelationType.evidenceFor));
    });

    test('Evidence 2: Source lookup returns full edition and publisher metadata without guessing', () {
      final srcRes = knowledgeModule.getSource('src_bukhari_test');
      expect(srcRes.isSuccess, isTrue);
      final src = srcRes.valueOrNull!;
      expect(src.title, contains('صحيح البخاري'));
      expect(src.publisher, equals('دار التأصيل'));
    });
  });
}
