import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/ai/domain/ai_intent.dart';
import 'package:siraj/modules/ai/retrievers/verified_retrieval_federation.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L2 Verified Retrieval Federation Tests (§6, §7)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late VerifiedRetrievalFederation federation;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      federation = VerifiedRetrievalFederation(
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    test('Retrieves verified EvidenceItems from appropriate modules without raw storage access', () async {
      const intent = AIIntent(category: IntentCategory.hadithLookup, riskLevel: RiskLevel.low);
      final evidence = await federation.retrieve(intent: intent, query: 'النية');

      expect(evidence.isNotEmpty, isTrue);
      expect(evidence.first.isValid, isTrue);
      expect(evidence.first.sourceId.isNotEmpty, isTrue);
      expect(evidence.first.referenceLocation.isNotEmpty, isTrue);
    });

    test('Returns empty list when query has no matching records', () async {
      const intent = AIIntent(category: IntentCategory.hadithLookup, riskLevel: RiskLevel.low);
      final evidence = await federation.retrieve(intent: intent, query: 'كلمة_غير_موجودة_نهائيا');

      expect(evidence.isEmpty, isTrue);
    });
  });
}
