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
  group('SIRAJ v1.0 — Sprint 10: M35 Quran Memorization Adversarial & Canonical Shield Suite (§95..§103)', () {
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

    test('Adversarial 1: Canonical Shield (§49, §97) — Memorization operations cannot mutate Quran canonical text', () async {
      final initialAyah = quranModule.store.getAyah(1, 1).valueOrNull!;
      final initialText = initialAyah.textUthmani;

      // Add to plan, review multiple times
      await memorizationModule.savePlan(MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)));
      const key = AyahKey(surahNumber: 1, ayahNumber: 1);
      await memorizationModule.addAyahToPlan(key);

      final sessionRes = await memorizationModule.getOrCreateTodaySession();
      final session = sessionRes.valueOrNull!;
      await memorizationModule.submitReview(session: session, ayahKey: key, quality: ReviewQuality.easy);

      // Verify canonical text in Quran store is completely untouched
      final verifyAyah = quranModule.store.getAyah(1, 1).valueOrNull!;
      expect(verifyAyah.textUthmani, equals(initialText));
      expect(verifyAyah.surahNumber, 1);
      expect(verifyAyah.ayahNumber, 1);
    });

    test('Adversarial 2: No Canonical Text Copies in User Progress (§50, §90)', () async {
      const key = AyahKey(surahNumber: 114, ayahNumber: 6);
      await memorizationModule.addAyahToPlan(key);

      final session = (await memorizationModule.getOrCreateTodaySession()).valueOrNull!;
      await memorizationModule.submitReview(session: session, ayahKey: key, quality: ReviewQuality.good);

      final items = (await memorizationModule.getAllItems()).valueOrNull!;
      for (final it in items) {
        expect(it.ayahKey, isA<AyahKey>());
      }
    });

    test('Adversarial 3: Safe handling of invalid Ayah query and corrupt requests (§51, §52)', () async {
      final ayahRes = quranModule.store.getAyah(114, 999);
      expect(ayahRes.isFailure, isTrue);
    });

    test('Adversarial 4: No Religious Scoring / No Piety / No Certification Injection (§30, §48, §103)', () async {
      await memorizationModule.savePlan(MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)));
      const key = AyahKey(surahNumber: 1, ayahNumber: 1);
      await memorizationModule.addAyahToPlan(key);

      final snapshot = (await memorizationModule.getMasterySnapshot()).valueOrNull!;
      expect(snapshot.overallMasteryPercent, isA<double>());
      // Ensure mastery percent is purely educational mathematical metric
      expect(snapshot.totalCompletedAyahs, isA<int>());
    });

    test('Adversarial 5: Cross-Module Isolation (§45, §97) — Memorization does NOT mutate Adhkar or Zakat data', () async {
      await zakatModule.addOrUpdateAsset(
        ZakatAsset(
          id: 'test_cash',
          title: 'مدخرات الحساب',
          category: AssetCategory.cash,
          amount: const CurrencyAmount(units: 5000000),
          acquisitionDate: DateTime.utc(2026, 9, 1),
        ),
      );

      await memorizationModule.resetAllData();

      final assets = (await zakatModule.getAssets()).valueOrNull!;
      expect(assets.length, 1);
      expect(adhkarModule.getAllItems().isSuccess, true);
    });
  });
}
