import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/engine/zakat_calculation_engine.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('M5 Forensic Nisab & Hawl Boundary Precision Tests (§7, §12)', () {
    final engine = ZakatCalculationEngine();
    final fixedNow = DateTime.utc(2026, 8, 31);
    final market = SyntheticZakatFixtures.createMarketSnapshot(
      gold24kHalalas: 35000, // Nisab 85g = 29,750.00 SAR (2,975,000 halalas)
    );

    test('Nisab Boundary 1: Exactly 1 cent below Nisab (29,749.99 SAR) is NOT DUE', () {
      final cashBelow = SyntheticZakatFixtures.createCashAsset(
        amount: 29749.99,
        acquisitionDate: fixedNow.subtract(const Duration(days: 400)),
      );

      final res = engine.calculate(
        assets: [cashBelow],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.notDueBelowNisab));
      expect(res.zakatDue.isZero, isTrue);
    });

    test('Nisab Boundary 2: Exactly at Nisab (29,750.00 SAR) is DUE', () {
      final cashExact = SyntheticZakatFixtures.createCashAsset(
        amount: 29750.00,
        acquisitionDate: fixedNow.subtract(const Duration(days: 400)),
      );

      final res = engine.calculate(
        assets: [cashExact],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.zakatDue.toDouble(), equals(743.75)); // 29,750 * 0.025 = 743.75 SAR
    });

    test('Nisab Boundary 3: Exactly 1 cent above Nisab (29,750.01 SAR) is DUE', () {
      final cashAbove = SyntheticZakatFixtures.createCashAsset(
        amount: 29750.01,
        acquisitionDate: fixedNow.subtract(const Duration(days: 400)),
      );

      final res = engine.calculate(
        assets: [cashAbove],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
    });

    test('Hawl Boundary 1: Exactly 1 day before Hawl maturity (Day 353) is NOT DUE', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 100000.0,
        acquisitionDate: fixedNow.subtract(const Duration(days: 353)),
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.notDueHawlIncomplete));
      expect(res.daysRemainingInHawl, equals(1));
    });

    test('Hawl Boundary 2: Exactly on Hawl maturity day (Day 354) is DUE', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 100000.0,
        acquisitionDate: fixedNow.subtract(const Duration(days: 354)),
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.daysRemainingInHawl, equals(0));
    });

    test('Hawl Boundary 3: 1 day past Hawl maturity (Day 355) remains DUE', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 100000.0,
        acquisitionDate: fixedNow.subtract(const Duration(days: 355)),
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.daysRemainingInHawl, equals(0));
    });
  });
}
