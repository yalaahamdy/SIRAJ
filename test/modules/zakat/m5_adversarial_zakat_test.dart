import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/zakat/domain/currency_amount.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/engine/zakat_calculation_engine.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('M5 Zakat Adversarial & Property Invariants Suite (§30, §31, §32, §45)', () {
    final engine = ZakatCalculationEngine();
    final marketSnapshot = SyntheticZakatFixtures.createMarketSnapshot();
    final fixedDate = DateTime.utc(2025, 1, 1);
    final evaluationDate = DateTime.utc(2026, 8, 31);

    test('Adversarial 1: Resulting Zakat due is NEVER negative across any combination of debts', () {
      final cash = SyntheticZakatFixtures.createCashAsset(amount: 10000, acquisitionDate: fixedDate);
      final debt = SyntheticZakatFixtures.createDebtLiability(amount: 500000, acquisitionDate: fixedDate); // 500k debt > 10k cash

      final res = engine.calculate(
        assets: [cash, debt],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: evaluationDate,
      );

      expect(res.netZakatableBase.isNegative, isFalse);
      expect(res.zakatDue.isNegative, isFalse);
      expect(res.zakatDue.units, equals(0));
      expect(res.status, equals(ZakatResultStatus.notDueBelowNisab));
    });

    test('Adversarial 2: Monotonicity Property: Increasing eligible assets never decreases Zakat due', () {
      final assetLow = SyntheticZakatFixtures.createCashAsset(amount: 50000, acquisitionDate: fixedDate);
      final assetMid = SyntheticZakatFixtures.createCashAsset(amount: 100000, acquisitionDate: fixedDate);
      final assetHigh = SyntheticZakatFixtures.createCashAsset(amount: 500000, acquisitionDate: fixedDate);

      final resLow = engine.calculate(
        assets: [assetLow],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: evaluationDate,
      );

      final resMid = engine.calculate(
        assets: [assetMid],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: evaluationDate,
      );

      final resHigh = engine.calculate(
        assets: [assetHigh],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: evaluationDate,
      );

      expect(resMid.zakatDue.units, greaterThanOrEqualTo(resLow.zakatDue.units));
      expect(resHigh.zakatDue.units, greaterThanOrEqualTo(resMid.zakatDue.units));
    });

    test('Adversarial 3: Stale market data detection triggers warning (>24 hours)', () {
      final oldSnapshot = SyntheticZakatFixtures.createMarketSnapshot(
        timestamp: DateTime.utc(2026, 8, 1), // 30 days old
      );

      expect(oldSnapshot.isStale(evaluationDate), isTrue);

      final freshSnapshot = SyntheticZakatFixtures.createMarketSnapshot(
        timestamp: evaluationDate.subtract(const Duration(hours: 2)), // 2 hours old
      );
      expect(freshSnapshot.isStale(evaluationDate), isFalse);
    });

    test('Adversarial 4: Historical snapshot tampering fails cryptographic verification', () {
      final asset = SyntheticZakatFixtures.createCashAsset(amount: 100000, acquisitionDate: fixedDate);
      final result = engine.calculate(
        assets: [asset],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: evaluationDate,
      );

      final snapshot = ZakatCalculationSnapshot.create(
        snapshotId: 'snap_adv_001',
        assets: [asset],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        result: result,
        createdAt: evaluationDate,
      );

      expect(snapshot.verifyHash(), isTrue);

      // Tamper with Zakat due in the result
      final tamperedResult = ZakatCalculationResult(
        status: result.status,
        grossAssets: result.grossAssets,
        deductibleLiabilities: result.deductibleLiabilities,
        netZakatableBase: result.netZakatableBase,
        nisabThreshold: result.nisabThreshold,
        zakatDue: const CurrencyAmount(units: 100, currency: 'SAR'), // Tampered from 2500.00 to 1.00 SAR
        isHawlComplete: result.isHawlComplete,
        daysRemainingInHawl: result.daysRemainingInHawl,
        appliedRate: result.appliedRate,
        policyUsed: result.policyUsed,
        marketSnapshotUsed: result.marketSnapshotUsed,
        itemizedAssetValues: result.itemizedAssetValues,
        explanation: result.explanation,
        calculatedAt: result.calculatedAt,
      );

      final tamperedSnapshot = ZakatCalculationSnapshot(
        snapshotId: snapshot.snapshotId,
        assets: snapshot.assets,
        policy: snapshot.policy,
        marketSnapshot: snapshot.marketSnapshot,
        result: tamperedResult,
        createdAt: snapshot.createdAt,
        integrityHash: snapshot.integrityHash, // Stale hash
      );

      expect(tamperedSnapshot.verifyHash(), isFalse);
    });

    test('Adversarial 5: Policy switching updates results transparently', () {
      // Amount of 15,000 SAR is below Gold Nisab (29,750 SAR) but ABOVE Silver Nisab (2,380 SAR)
      final cash = SyntheticZakatFixtures.createCashAsset(amount: 15000, acquisitionDate: fixedDate);

      // Under Gold standard: Not Due (below 29,750)
      final goldRes = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        customNow: evaluationDate,
      );
      expect(goldRes.status, equals(ZakatResultStatus.notDueBelowNisab));
      expect(goldRes.zakatDue.isZero, isTrue);

      // Under Silver standard: Due (above 2,380)
      final silverRes = engine.calculate(
        assets: [cash],
        policy: ZakatPolicy.silverStandard,
        marketSnapshot: marketSnapshot,
        customNow: evaluationDate,
      );
      expect(silverRes.status, equals(ZakatResultStatus.due));
      expect(silverRes.zakatDue.toDouble(), equals(375.0)); // 15,000 * 2.5% = 375 SAR
    });
  });
}
