import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/engine/zakat_calculation_engine.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('M5 Forensic Independent Reference Test Cases (§38)', () {
    final engine = ZakatCalculationEngine();
    final fixedNow = DateTime.utc(2026, 8, 31);
    final oneYearAgo = fixedNow.subtract(const Duration(days: 400));

    test('REF-Z01: Standard Cash 200,000 SAR @ 2.5% Lunar Hijri Rate', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 200000.0,
        acquisitionDate: oneYearAgo,
      );
      final market = SyntheticZakatFixtures.createMarketSnapshot(
        gold24kHalalas: 30000, // 300.00 SAR / g -> Nisab 85g = 25,500.00 SAR
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        isHijriCalendar: true,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.netZakatableBase.toDouble(), equals(200000.0));
      expect(res.zakatDue.toDouble(), equals(5000.0)); // 200,000 * 0.025 = 5,000.00 SAR
    });

    test('REF-Z02: Cash 50,000 SAR with Current Debt 10,000 SAR Deducted', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 50000.0,
        acquisitionDate: oneYearAgo,
      );
      final debt = SyntheticZakatFixtures.createDebtLiability(
        amount: 10000.0,
        acquisitionDate: oneYearAgo,
      );
      final market = SyntheticZakatFixtures.createMarketSnapshot(
        gold24kHalalas: 35000, // Nisab = 29,750.00 SAR
      );

      final res = engine.calculate(
        assets: [cash, debt],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        isHijriCalendar: true,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.netZakatableBase.toDouble(), equals(40000.0)); // 50k - 10k = 40k (> 29,750)
      expect(res.zakatDue.toDouble(), equals(1000.0)); // 40,000 * 0.025 = 1,000.00 SAR
    });

    test('REF-Z03: Gregorian Calendar Rate 2.577% on 100,000 SAR', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 100000.0,
        acquisitionDate: oneYearAgo,
      );
      final market = SyntheticZakatFixtures.createMarketSnapshot(
        gold24kHalalas: 35000,
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: market,
        isHijriCalendar: false, // Solar Gregorian
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.appliedRate, equals(0.02577));
      expect(res.zakatDue.toDouble(), equals(2577.0)); // 100,000 * 0.02577 = 2,577.00 SAR
    });

    test('REF-Z04: Silver Standard (Hanafi) on 10,000 SAR (Silver Nisab 595g * 4 SAR = 2,380 SAR)', () {
      final cash = SyntheticZakatFixtures.createCashAsset(
        amount: 10000.0,
        acquisitionDate: oneYearAgo,
      );
      final market = SyntheticZakatFixtures.createMarketSnapshot(
        silverHalalas: 400, // 4.00 SAR / g
      );

      final res = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.silverStandard,
        marketSnapshot: market,
        isHijriCalendar: true,
        customNow: fixedNow,
      );

      expect(res.status, equals(ZakatResultStatus.due));
      expect(res.nisabThreshold.toDouble(), equals(2380.0));
      expect(res.zakatDue.toDouble(), equals(250.0)); // 10,000 * 0.025 = 250.00 SAR
    });

    test('REF-Z05: Gold 18k Purity Valuation (100g @ 300 SAR 24k price = 22,500 SAR)', () {
      final gold18k = SyntheticZakatFixtures.createGoldAsset(
        weightGrams: 100.0,
        purityKarat: 18, // 18/24 = 0.75 purity ratio
        acquisitionDate: oneYearAgo,
      );
      final market = SyntheticZakatFixtures.createMarketSnapshot(
        gold24kHalalas: 30000, // 300.00 SAR / g
      );

      final res = engine.calculate(
        assets: [gold18k],
        policy: ZakatPolicy.silverStandard, // Use silver standard so it passes Nisab
        marketSnapshot: market,
        isHijriCalendar: true,
        customNow: fixedNow,
      );

      // 100g * 300 SAR * (18/24) = 22,500.00 SAR
      expect(res.grossAssets.toDouble(), equals(22500.0));
      expect(res.zakatDue.toDouble(), equals(562.5)); // 22,500 * 0.025 = 562.50 SAR
    });
  });
}
