import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';
import '../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Real-World Search Performance Suite (§61..§63, §93)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
      );
    });

    test('Performance 1: Federated search query across all 5 content domains completes in < 150ms', () async {
      final stopwatch = Stopwatch()..start();
      final res = await companionModule.search('الله');
      stopwatch.stop();

      expect(res.isSuccess, true);
      expect(stopwatch.elapsedMilliseconds, lessThan(150));
    });
  });
}
