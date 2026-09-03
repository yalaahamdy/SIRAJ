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
  group('SIRAJ v1.0 — Sprint 14: M39 Unified Search Adversarial & Canonical Shield Suite (§93, §94, §95, §97)', () {
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

    test('Adversarial 1: Deterministic Search Assertion (§95) — Same query + dataset produces exact identical ordered results', () async {
      final res1 = await companionModule.search('الله');
      final res2 = await companionModule.search('الله');

      expect(res1.isSuccess, true);
      expect(res2.isSuccess, true);
      expect(res1.valueOrNull!.length, equals(res2.valueOrNull!.length));

      for (int i = 0; i < res1.valueOrNull!.length; i++) {
        expect(res1.valueOrNull![i].itemId, equals(res2.valueOrNull![i].itemId));
        expect(res1.valueOrNull![i].moduleId, equals(res2.valueOrNull![i].moduleId));
      }
    });

    test('Adversarial 2: Cross-Module Non-Mutation Shield (§97) — Search does not mutate domain data', () async {
      final initialSurahs = quranModule.store.getAllSurahs().valueOrNull!.length;
      final initialHadiths = knowledgeModule.store.getAllHadiths().valueOrNull!.length;

      // Heavy search load
      for (int i = 0; i < 50; i++) {
        await companionModule.search('صلاة');
      }

      expect(quranModule.store.getAllSurahs().valueOrNull!.length, equals(initialSurahs));
      expect(knowledgeModule.store.getAllHadiths().valueOrNull!.length, equals(initialHadiths));
    });

    test('Adversarial 3: Search Input Robustness (§59) — Oversized, injection, and unicode queries execute safely', () async {
      final oversized = 'الله ' * 500;
      final injection = "'; DROP TABLE Quran; -- <script>alert(1)</script>";

      final r1 = await companionModule.search(oversized);
      final r2 = await companionModule.search(injection);

      expect(r1.isSuccess, true);
      expect(r2.isSuccess, true);
    });
  });
}
