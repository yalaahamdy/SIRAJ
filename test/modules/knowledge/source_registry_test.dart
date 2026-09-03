import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/knowledge/domain/source_record.dart';
import 'package:siraj/modules/knowledge/domain/source_type.dart';
import 'package:siraj/modules/knowledge/services/source_registry_service.dart';
import 'package:siraj/modules/knowledge/store/read_only_knowledge_store.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 SourceRegistry & Provenance Tests (§5, §6)', () {
    late ReadOnlyKnowledgeStore store;
    late SourceRegistryService service;

    setUp(() {
      store = ReadOnlyKnowledgeStore();
      service = SourceRegistryService(store: store);
      final pkg = SyntheticKnowledgeFixtures.createPackage();
      store.mountPackage(pkg);
    });

    test('SourceRecord computes and verifies SHA-256 integrity hash', () {
      final src = SyntheticKnowledgeFixtures.createSourceRecord();
      expect(src.verifyHash(), isTrue);
      expect(src.integrityHash.startsWith('sha256:'), isTrue);

      final map = src.toMap();
      final revived = SourceRecord.fromMap(map);
      expect(revived, equals(src));
      expect(revived.verifyHash(), isTrue);
    });

    test('SourceRegistryService retrieves source by ID and filters by type', () {
      final res = service.getSource('src_bukhari_test');
      expect(res.isSuccess, isTrue);
      expect(res.valueOrNull!.title.contains('صحيح البخاري'), isTrue);
      expect(service.isValidSource('src_bukhari_test'), isTrue);

      final hadithSources = service.getSourcesByType(SourceType.hadithCollection);
      expect(hadithSources.isSuccess, isTrue);
      expect(hadithSources.valueOrNull!.length, equals(1));

      final tafsirSources = service.getSourcesByType(SourceType.tafsir);
      expect(tafsirSources.isSuccess, isTrue);
      expect(tafsirSources.valueOrNull!, isEmpty);
    });
  });
}
