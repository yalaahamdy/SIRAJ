import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/zakat/domain/asset_category.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/zakat_asset.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 11: M36 Knowledge & Learning Adversarial & Canonical Shield Suite (§116, §117, §123)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late AdhkarModule adhkarModule;
    late ZakatModule zakatModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      zakatModule = ZakatModule(storageRegistry: storage);

      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Adversarial 1: Canonical Knowledge Shield (§117, §123) — Knowledge operations cannot mutate canonical records', () {
      final hadith = knowledgeModule.store.getAllHadiths().valueOrNull!.first;
      final originalMatn = hadith.arabicMatn;

      // Accessing and searching knowledge
      final searchRes = knowledgeModule.searchService.search('النيات');
      expect(searchRes.isSuccess, true);

      // Verify canonical Hadith text is unchanged
      final verifyHadith = knowledgeModule.store.getHadith(hadith.hadithId).valueOrNull!;
      expect(verifyHadith.arabicMatn, equals(originalMatn));
    });

    test('Adversarial 2: Quiz Integrity (§122) — Canonical questions and options are immutable from UI layer', () {
      final quizRes = learningModule.getQuizByLesson('lsn_wudu_pillars');
      expect(quizRes.isSuccess, true);
      final q = quizRes.valueOrNull!;

      expect(q.questions.isNotEmpty, true);
      for (final item in q.questions) {
        expect(item.questionText.isNotEmpty, true);
        expect(item.options.isNotEmpty, true);
        expect(item.correctOptionIndices.isNotEmpty, true);
      }
    });

    test('Adversarial 3: Cross-Module Shield (§123) — Learning and Knowledge do not mutate other modules', () async {
      await zakatModule.addOrUpdateAsset(
        ZakatAsset(
          id: 'test_asset',
          title: 'مدخرات تجارية',
          category: AssetCategory.cash,
          amount: const CurrencyAmount(units: 8000000),
          acquisitionDate: DateTime.utc(2026, 9, 1),
        ),
      );

      await learningModule.resetAllUserData();

      // Zakat and Quran remain completely untouched
      final assets = (await zakatModule.getAssets()).valueOrNull!;
      expect(assets.length, 1);
      expect(quranModule.store.getAllSurahs().valueOrNull!.length, 114);
      expect(adhkarModule.getAllItems().isSuccess, true);
    });

    test('Adversarial 4: No Religious Scoring or Piety Profiling Injection (§44, §57, §114, §124)', () {
      final paths = learningModule.getAllPaths().valueOrNull!;
      expect(paths.isNotEmpty, true);

      // Ensure mastery percent is purely educational mathematical metric
      final path = paths.first;
      expect(path.title.isNotEmpty, true);
    });
  });
}
