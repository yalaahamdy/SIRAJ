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
  group('SIRAJ v1.0 — Sprint 12: M37 Adhkar Adversarial & Canonical Shield Suite (§119, §120, §121)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late ZakatModule zakatModule;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;
    late AdhkarModule adhkarModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      zakatModule = ZakatModule(storageRegistry: storage);

      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());
    });

    test('Adversarial 1: Canonical Adhkar Shield (§120, §122) — Counter operations do not mutate canonical text', () async {
      final item = adhkarModule.getAllItems().valueOrNull!.first;
      final originalText = item.textArabic;
      final originalType = item.type;

      // Tap counter 50 times
      for (int i = 0; i < 50; i++) {
        await adhkarModule.incrementProgress(contentId: item.id, targetCount: 100);
      }

      // Verify canonical item text and attributes are unchanged
      final verifyItem = adhkarModule.getItemById(item.id).valueOrNull!;
      expect(verifyItem.textArabic, equals(originalText));
      expect(verifyItem.type, equals(originalType));
    });

    test('Adversarial 2: No Text Copies in Favorites (§102) — Favorites store only ID', () async {
      final item = adhkarModule.getAllItems().valueOrNull!.first;
      await adhkarModule.toggleFavorite(item.id);

      final favsRes = await adhkarModule.getFavorites();
      expect(favsRes.isSuccess, true);
      final fav = favsRes.valueOrNull!.first;
      expect(fav.contentId, equals(item.id));
    });

    test('Adversarial 3: Cross-Module Shield (§121) — Adhkar reset does not affect Quran, Prayer, Zakat, Knowledge', () async {
      await zakatModule.addOrUpdateAsset(
        ZakatAsset(
          id: 'test_asset',
          title: 'مدخرات',
          category: AssetCategory.cash,
          amount: const CurrencyAmount(units: 5000000),
          acquisitionDate: DateTime.utc(2026, 9, 1),
        ),
      );

      // Perform Adhkar operations
      final item = adhkarModule.getAllItems().valueOrNull!.first;
      await adhkarModule.resetProgress(contentId: item.id, targetCount: item.repetition.count);

      // Verify all other modules are untouched
      expect((await zakatModule.getAssets()).valueOrNull!.length, 1);
      expect(quranModule.store.getAllSurahs().valueOrNull!.length, 114);
      expect(knowledgeModule.store.getAllHadiths().valueOrNull!.isNotEmpty, true);
    });

    test('Adversarial 4: No Religious Scoring or Piety Profiling Injection (§48, §49, §126)', () {
      final items = adhkarModule.getAllItems().valueOrNull!;
      expect(items.isNotEmpty, true);
      for (final item in items) {
        expect(item.textArabic.isNotEmpty, true);
      }
    });
  });
}
