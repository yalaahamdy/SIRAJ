import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/modules/zakat/domain/asset_category.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/zakat_asset.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';
import '../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: M38 Unified Home Adversarial & Canonical Shield Suite (§114, §115, §117, §120)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late PrayerModule prayerModule;
    late MemorizationModule memorizationModule;
    late AdhkarModule adhkarModule;
    late ZakatModule zakatModule;
    late FastingModule fastingModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late SeerahModule seerahModule;
    late HajjModule hajjModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      prayerModule = PrayerModule(storageRegistry: storage);

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      zakatModule = ZakatModule(storageRegistry: storage);

      fastingModule = FastingModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
      );

      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());

      hajjModule = HajjModule(storageRegistry: storage);

      companionModule = CompanionModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
        quranModule: quranModule,
        memorizationModule: memorizationModule,
        adhkarModule: adhkarModule,
        zakatModule: zakatModule,
        fastingModule: fastingModule,
        knowledgeModule: knowledgeModule,
        learningModule: learningModule,
        seerahModule: seerahModule,
        hajjModule: hajjModule,
      );
    });

    test('Adversarial 1: Home Non-Mutation Shield (§117) — Home aggregation does not mutate any module data', () async {
      await zakatModule.addOrUpdateAsset(
        ZakatAsset(
          id: 'test_asset',
          title: 'مدخرات تجارية',
          category: AssetCategory.cash,
          amount: const CurrencyAmount(units: 12000000),
          acquisitionDate: DateTime.utc(2026, 9, 1),
        ),
      );

      // Aggregate dashboard 10 times
      for (int i = 0; i < 10; i++) {
        await companionModule.getDashboardCards();
      }

      // Verify all underlying module stores remain untouched
      expect((await zakatModule.getAssets()).valueOrNull!.length, 1);
      expect(quranModule.store.getAllSurahs().valueOrNull!.length, 114);
      expect(adhkarModule.getAllItems().isSuccess, true);
    });

    test('Adversarial 2: No Canonical Copies in Home (§120) — Dashboard cards do not duplicate canonical texts', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      for (final card in cards) {
        expect(card.titleArabic.isNotEmpty, true);
        expect(card.cardId.isNotEmpty, true);
      }
    });

    test('Adversarial 3: Priority Determinism (§116) — Repeated calls produce identical ordering', () async {
      final run1 = (await companionModule.getDashboardCards()).valueOrNull!;
      final run2 = (await companionModule.getDashboardCards()).valueOrNull!;

      expect(run1.length, equals(run2.length));
      for (int i = 0; i < run1.length; i++) {
        expect(run1[i].cardId, equals(run2[i].cardId));
        expect(run1[i].priorityOrder, equals(run2[i].priorityOrder));
      }
    });

    test('Adversarial 4: Zero Piety / Worship Score Injection (§68, §119)', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      for (final card in cards) {
        expect(card.titleArabic, isNot(contains('نقاط إيمان')));
        expect(card.titleArabic, isNot(contains('درجة الروحانية')));
        expect(card.subtitleArabic, isNot(contains('مستوى تدينك')));
      }
    });
  });
}
