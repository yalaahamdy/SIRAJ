import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/knowledge/domain/knowledge_relation.dart';
import 'package:siraj/modules/knowledge/services/knowledge_graph_service.dart';
import 'package:siraj/modules/knowledge/store/read_only_knowledge_store.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 Knowledge Graph & Deterministic Relations Tests (§20)', () {
    late ReadOnlyKnowledgeStore store;
    late KnowledgeGraphService graphService;

    setUp(() {
      store = ReadOnlyKnowledgeStore();
      graphService = KnowledgeGraphService(store: store);
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('Retrieves evidence relation connecting Hadith to Fiqh topic', () {
      final res = graphService.getRelationsFor('hadith_001');
      expect(res.isSuccess, isTrue);
      final rels = res.valueOrNull!;

      expect(rels.isNotEmpty, isTrue);
      expect(rels.first.relationType, equals(RelationType.evidenceFor));
      expect(rels.first.targetKey, equals('topic_niyyah_fasting'));
      expect(rels.first.description!.contains('اشتراط النية'), isTrue);
    });
  });
}
