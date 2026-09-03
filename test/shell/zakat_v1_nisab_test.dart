import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/market_data_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Nisab Engine & Standards Suite (§7..§10, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    test('Nisab 1: Gold standard calculates 85 grams threshold deterministically', () async {
      // 85g * 350.00 SAR = 29,750.00 SAR
      final marketSnap = SyntheticZakatFixtures.createMarketSnapshot(gold24kHalalas: 35000);
      await zakatModule.setMarketSnapshot(marketSnap);

      // Asset below nisab (25,000 SAR)
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 25000.0),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      final result = calcRes.valueOrNull!;
      expect(result.nisabThreshold.units, 2975000); // 29,750 SAR
      expect(result.status, ZakatResultStatus.notDueBelowNisab);
      expect(result.zakatDue.units, 0);
    });

    test('Nisab 2: Silver standard calculates 595 grams threshold', () async {
      // 595g * 4.00 SAR = 2,380.00 SAR
      final marketSnap = SyntheticZakatFixtures.createMarketSnapshot(silverHalalas: 400);
      await zakatModule.setMarketSnapshot(marketSnap);
      await zakatModule.setActivePolicy(ZakatPolicy.silverStandard.policyId);

      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 5000.0),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      final result = calcRes.valueOrNull!;
      expect(result.nisabThreshold.units, 238000); // 2,380 SAR
      expect(result.status, ZakatResultStatus.due);
      expect(result.zakatDue.units, 12500); // 125.00 SAR (2.5% of 5,000)
    });

    test('Nisab 3: Missing market price yields insufficientData status gracefully', () async {
      final invalidSnapshot = MarketDataSnapshot(
        goldPricePerGram24k: const CurrencyAmount(units: 0, currency: 'SAR'),
        silverPricePerGram: const CurrencyAmount(units: 0, currency: 'SAR'),
        sourceName: 'Empty Market Provider',
        timestamp: DateTime.utc(2026, 8, 31),
        isManualEntry: false,
      );
      await zakatModule.setMarketSnapshot(invalidSnapshot);
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 50000.0),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      final result = calcRes.valueOrNull!;
      expect(result.status, ZakatResultStatus.insufficientData);
    });
  });
}
