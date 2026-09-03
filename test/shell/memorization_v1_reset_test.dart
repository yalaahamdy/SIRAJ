import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/zakat/domain/asset_category.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/zakat_asset.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 10: Memorization Reset & Isolated Data Clear Suite (§43..§45, §95, §101)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;
    late AdhkarModule adhkarModule;
    late ZakatModule zakatModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      zakatModule = ZakatModule(storageRegistry: storage);
    });

    test('Reset 1: Resetting memorization clears only mod_memorization and preserves all other modules (§45, §101)', () async {
      // 1. Populate memorization data
      await memorizationModule.savePlan(MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)));
      const key = AyahKey(surahNumber: 1, ayahNumber: 1);
      await memorizationModule.addAyahToPlan(key);
      final sessionRes = await memorizationModule.getOrCreateTodaySession();
      await memorizationModule.submitReview(session: sessionRes.valueOrNull!, ayahKey: key, quality: ReviewQuality.easy);

      // 2. Populate Quran reading progress and Zakat asset
      await quranModule.userDataService.updateProgress(
        surahNumber: 2,
        ayahNumber: 255,
        pageNumber: 42,
        surahNameArabic: 'البقرة',
      );
      await zakatModule.addOrUpdateAsset(
        ZakatAsset(
          id: 'test_cash',
          title: 'مدخرات نقدية',
          category: AssetCategory.cash,
          amount: const CurrencyAmount(units: 10000000),
          acquisitionDate: DateTime.utc(2026, 9, 1),
        ),
      );

      // 3. Trigger reset of memorization
      await memorizationModule.resetAllData();

      // 4. Verify Memorization data is reset
      final itemsAfter = (await memorizationModule.getAllItems()).valueOrNull!;
      expect(itemsAfter.isEmpty, isTrue);

      // 5. Assert Canonical & User Data Shield across other modules
      expect(quranModule.store.getAllSurahs().valueOrNull!.length, equals(114));
      final quranProgress = (await quranModule.userDataService.getProgress()).valueOrNull!;
      expect(quranProgress.lastReadSurah, equals(2));
      expect(quranProgress.lastReadAyah, equals(255));

      final zakatAssets = (await zakatModule.getAssets()).valueOrNull!;
      expect(zakatAssets.length, equals(1));
      expect(adhkarModule.getAllItems().isSuccess, isTrue);
    });
  });
}
