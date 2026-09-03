import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/engine/zakat_calculation_engine.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('L2 ZakatCalculationEngine Deterministic Calculation Tests (§20, §21, §30)', () {
    final fixedNow = DateTime.utc(2026, 8, 31);
    final clock = TestClock(fixedNow);
    final engine = ZakatCalculationEngine(clock: clock);
    final marketSnapshot = SyntheticZakatFixtures.createMarketSnapshot(
      gold24kHalalas: 35000, // Nisab 85g = 29,750.00 SAR
    );

    test('Scenario 1: Wealth below Nisab returns notDueBelowNisab with zero Zakat', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 20000.0, // 20,000 SAR < 29,750 SAR
        acquisitionDate: DateTime.utc(2025, 1, 1),
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.notDueBelowNisab));
      expect(res.zakatDue.isZero, isTrue);
      expect(res.netZakatableBase.toDouble(), equals(20000.0));
      expect(res.isDue, isFalse);
    });

    test('Scenario 2: Wealth above Nisab but Hawl incomplete returns notDueHawlIncomplete', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 100000.0, // 100,000 SAR > Nisab
        acquisitionDate: fixedNow.subtract(const Duration(days: 100)), // Only 100 days elapsed
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.notDueHawlIncomplete));
      expect(res.zakatDue.isZero, isTrue);
      expect(res.isHawlComplete, isFalse);
      expect(res.daysRemainingInHawl, equals(254)); // 354 - 100
    });

    test('Scenario 3: Wealth above Nisab and Hawl complete returns due with exact 2.5% Zakat', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 100000.0, // 100,000 SAR
        acquisitionDate: fixedNow.subtract(const Duration(days: 400)), // Completed Hawl
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.isDue, isTrue);
      expect(res.zakatDue.toDouble(), equals(2500.0)); // 100,000 * 2.5% = 2,500 SAR
      expect(res.explanation.contains('2500.00 SAR'), isTrue);
    });

    test('Scenario 4: Deductible current debts are subtracted from zakatable base', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 100000.0,
        acquisitionDate: fixedNow.subtract(const Duration(days: 400)),
      );
      final debt = SyntheticZakatFixtures.createDebtLiability(
        amount: 20000.0, // 20,000 SAR debt
        acquisitionDate: fixedNow.subtract(const Duration(days: 400)),
      );

      final res = engine.calculate(
        assets: [cash, debt],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: fixedNow,
      );

      expect(res.grossAssets.toDouble(), equals(100000.0));
      expect(res.deductibleLiabilities.toDouble(), equals(20000.0));
      expect(res.netZakatableBase.toDouble(), equals(80000.0)); // 100k - 20k
      expect(res.zakatDue.toDouble(), equals(2000.0)); // 80,000 * 2.5% = 2,000 SAR
    });

    test('Scenario 5: Automatic valuation of Gold assets by weight and Karat purity', () {
      final gold = SyntheticZakatFixtures.createGoldAsset(
        weightGrams: 100.0, // 100g 24k @ 350 SAR = 35,000 SAR
        purityKarat: 24,
        acquisitionDate: fixedNow.subtract(const Duration(days: 400)),
      );

      final res = engine.calculate(
        assets: [gold],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: fixedNow,
      );

      expect(res.grossAssets.toDouble(), equals(35000.0));
      expect(res.zakatDue.toDouble(), equals(875.0)); // 35,000 * 2.5% = 875 SAR
    });
  });
}
