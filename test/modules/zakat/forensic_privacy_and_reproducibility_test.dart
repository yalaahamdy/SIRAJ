import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/market_data_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/domain/zakat_profile.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('M5 Forensic Privacy & Historical Reproducibility Tests (§24, §25, §29)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule module;

    setUp(() {
      registry = MemoryStorageRegistry();
      module = ZakatModule(storageRegistry: registry);
    });

    test('Historical Reproducibility: Price and Policy changes NEVER mutate historical snapshots', () async {
      // 1. Initial State: Gold @ 350 SAR, 100k cash -> Zakat due = 2,500 SAR
      await module.setMarketSnapshot(SyntheticZakatFixtures.createMarketSnapshot());
      await module.saveProfile(const ZakatProfile(currencyCode: 'SAR'));
      final asset = SyntheticZakatFixtures.createCashAsset(
        amount: 100000,
        acquisitionDate: DateTime.utc(2025, 1, 1),
      );
      await module.addOrUpdateAsset(asset);

      final initialCalc = await module.calculateZakat();
      expect(initialCalc.isSuccess, isTrue);
      expect(initialCalc.valueOrNull!.zakatDue.toDouble(), equals(2500.0));

      final saveSnapshotRes = await module.saveSnapshot(initialCalc.valueOrNull!);
      expect(saveSnapshotRes.isSuccess, isTrue);
      final savedSnapshot = saveSnapshotRes.valueOrNull!;

      // 2. Change Market Price to 600 SAR/g
      final newMarket = MarketDataSnapshot(
        goldPricePerGram24k: const CurrencyAmount(units: 60000, currency: 'SAR'),
        silverPricePerGram: const CurrencyAmount(units: 800, currency: 'SAR'),
        sourceName: 'Updated Live Feed',
        timestamp: DateTime.utc(2026, 9, 1),
      );
      await module.setMarketSnapshot(newMarket);

      // 3. Switch Policy to Silver Standard
      await module.setActivePolicy(ZakatPolicy.silverStandard.policyId);

      // 4. Retrieve old snapshot and verify complete immutability
      final snapshotsRes = await module.getSnapshots();
      expect(snapshotsRes.isSuccess, isTrue);
      final retrievedSnapshot = snapshotsRes.valueOrNull!.first;

      expect(retrievedSnapshot.snapshotId, equals(savedSnapshot.snapshotId));
      expect(retrievedSnapshot.policy.policyId, equals(ZakatPolicy.goldStandard.policyId));
      expect(retrievedSnapshot.result.zakatDue.toDouble(), equals(2500.0));
      expect(retrievedSnapshot.result.nisabThreshold.toDouble(), equals(29750.0)); // 85 * 350 SAR
      expect(retrievedSnapshot.verifyHash(), isTrue);
    });

    test('Privacy Isolation: User financial assets and snapshots reside exclusively in mod_zakat', () async {
      final asset = SyntheticZakatFixtures.createCashAsset(amount: 50000);
      await module.addOrUpdateAsset(asset);

      final zakatStore = registry.getStoreForModule('mod_zakat');
      final quranStore = registry.getStoreForModule('mod_quran');
      final prayerStore = registry.getStoreForModule('mod_prayer');

      final zakatAssets = await zakatStore.getString('zakat_assets');
      expect(zakatAssets.valueOrNull, isNotNull);

      // Other modules cannot see zakat keys
      final quranCheck = await quranStore.getString('zakat_assets');
      expect(quranCheck.valueOrNull, isNull);

      final prayerCheck = await prayerStore.getString('zakat_assets');
      expect(prayerCheck.valueOrNull, isNull);
    });
  });
}
