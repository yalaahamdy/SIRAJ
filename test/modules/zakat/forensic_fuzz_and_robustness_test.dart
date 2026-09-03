import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/zakat/domain/asset_category.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/market_data_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_asset.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/engine/zakat_calculation_engine.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('M5 Forensic Fuzzing, Stress & Robustness Tests (§36, §37)', () {
    final engine = ZakatCalculationEngine();
    final fixedNow = DateTime.utc(2026, 8, 31);
    final market = SyntheticZakatFixtures.createMarketSnapshot();

    test('Fuzzing 1,000 randomized assets maintains safety invariants and high performance', () {
      final rng = Random(42);
      final assets = <ZakatAsset>[];

      for (var i = 0; i < 1000; i++) {
        final cat = AssetCategory.values[rng.nextInt(AssetCategory.values.length)];
        final randomAmount = (rng.nextDouble() * 1000000) - 1000; // includes potential negatives
        final weight = rng.nextBool() ? rng.nextDouble() * 500 : null;
        final karat = rng.nextBool() ? rng.nextInt(30) : null; // includes invalid 0 or >24

        assets.add(
          ZakatAsset(
            id: 'fuzz_asset_$i',
            title: 'Fuzz Asset $i',
            category: cat,
            amount: CurrencyAmount.fromDouble(randomAmount),
            weightGrams: weight,
            purityKarat: karat,
            acquisitionDate: fixedNow.subtract(Duration(days: rng.nextInt(600))),
          ),
        );
      }

      final stopwatch = Stopwatch()..start();
      final res = engine.calculate(
        assets: assets,
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        customNow: fixedNow,
      );
      stopwatch.stop();

      // Invariant checks
      expect(res.zakatDue.isNegative, isFalse);
      expect(res.netZakatableBase.isNegative, isFalse);
      expect(res.zakatDue.units.isFinite, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(50)); // Fast sub-50ms execution for 1,000 items
    });

    test('Invalid Zero or Negative Market Price safely yields insufficientData status', () {
      final badMarket = MarketDataSnapshot(
        goldPricePerGram24k: const CurrencyAmount(units: 0, currency: 'SAR'), // 0 price
        silverPricePerGram: const CurrencyAmount(units: -100, currency: 'SAR'), // negative price
        sourceName: 'Corrupted Feed',
        timestamp: fixedNow,
      );

      final cash = SyntheticZakatFixtures.createCashAsset(amount: 100000);
      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: badMarket,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.insufficientData));
      expect(res.zakatDue.isZero, isTrue);
      expect(res.explanation.contains('غير كافية أو غير صالحة'), isTrue);
    });
  });
}
