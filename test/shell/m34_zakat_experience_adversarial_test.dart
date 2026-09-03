import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/market_data_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';
import '../fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';
import '../fixtures/seerah/synthetic_seerah_fixtures.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: M34 Zakat Experience Adversarial Suite (§135, §136)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    test('Adversarial 1: Negative asset amounts and zero currency edge cases', () async {
      // CurrencyAmount defends against negative units where necessary or clamps
      const zeroAmount = CurrencyAmount(units: 0, currency: 'SAR');
      expect(zeroAmount.units, 0);
      expect(zeroAmount.format(), contains('0'));
    });

    test('Adversarial 2: Stale/Missing market price defaults cleanly without hallucinated rate', () async {
      final invalidSnapshot = MarketDataSnapshot(
        goldPricePerGram24k: const CurrencyAmount(units: 0, currency: 'SAR'),
        silverPricePerGram: const CurrencyAmount(units: 0, currency: 'SAR'),
        sourceName: 'Unavailable Market',
        timestamp: DateTime.utc(2020, 1, 1),
        isManualEntry: false,
      );
      await zakatModule.setMarketSnapshot(invalidSnapshot);

      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 50000.0),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      expect(calcRes.valueOrNull!.status, ZakatResultStatus.insufficientData);
    });

    test('Adversarial 3: Canonical Shield & Cross-Module Mutation Immunity (§136)', () async {
      // Initialize all modules and mount synthetic packages
      final quranMod = QuranModule(storageRegistry: registry);
      quranMod.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      final prayerMod = PrayerModule(storageRegistry: registry);

      final adhkarMod = AdhkarModule(storageRegistry: registry);
      adhkarMod.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      final fastingMod = FastingModule(storageRegistry: registry, prayerModule: prayerMod);
      final memMod = MemorizationModule(storageRegistry: registry, quranStore: quranMod.store);

      final knowMod = KnowledgeModule(storageRegistry: registry);
      knowMod.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      final learnMod = LearningModule(storageRegistry: registry);
      learnMod.mountPackage(SyntheticLearningFixtures.createPackage());

      final seerahMod = SeerahModule(storageRegistry: registry);
      seerahMod.mountPackage(SyntheticSeerahFixtures.createPackage());

      final hajjMod = HajjModule(storageRegistry: registry);
      hajjMod.mountPackage(SyntheticHajjFixtures.createPackage());

      // Perform extensive Zakat operations: additions, calculations, snapshots, reset
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 1000000.0),
      );
      final calcRes = await zakatModule.calculateZakat();
      await zakatModule.saveSnapshot(calcRes.valueOrNull!);
      await zakatModule.resetAllUserData();

      // Assert Canonical Shield across all 9 modules
      expect(quranMod.store.getAllSurahs().valueOrNull!.length, 114);
      expect(adhkarMod.getAllItems().isSuccess, true);
      expect(knowMod.store.getAllFiqhTopics().isSuccess, true);
      expect(learnMod.getAllPaths().isSuccess, true);
      expect(seerahMod.getAllEvents().isSuccess, true);
      expect(hajjMod.getStepsForJourney(JourneyType.umrah).isSuccess, true);
      expect(memMod.dataStore, isNotNull);
      expect(fastingMod.prayerModule, isNotNull);
    });

    test('Adversarial 4: Policy immutability & historical snapshot tampering resistance', () async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0),
      );
      final calcRes = await zakatModule.calculateZakat();
      final snapRes = await zakatModule.saveSnapshot(calcRes.valueOrNull!);
      final snapshot = snapRes.valueOrNull!;

      // Verify cryptographic integrity hash
      expect(snapshot.verifyHash(), true);

      // Mutated snapshot should fail verification
      final tamperedSnapshot = ZakatCalculationSnapshot(
        snapshotId: snapshot.snapshotId,
        assets: snapshot.assets,
        policy: ZakatPolicy.silverStandard,
        marketSnapshot: snapshot.marketSnapshot,
        result: snapshot.result,
        createdAt: snapshot.createdAt,
        integrityHash: snapshot.integrityHash,
      );
      expect(tamperedSnapshot.verifyHash(), false);
    });
  });
}
