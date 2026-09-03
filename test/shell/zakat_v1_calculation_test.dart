import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Calculation Engine & Mathematical Precision Suite (§44..§53, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    test('Calculation 1: Net Zakatable Base deducts deductible liabilities correctly', () async {
      // Cash: 100,000 SAR
      // Debt: 20,000 SAR
      // Net Base: 80,000 SAR
      // Zakat due (2.5%): 2,000.00 SAR
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0),
      );
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createDebtLiability(amount: 20000.0),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      final result = calcRes.valueOrNull!;

      expect(result.grossAssets.units, 10000000);
      expect(result.deductibleLiabilities.units, 2000000);
      expect(result.netZakatableBase.units, 8000000);
      expect(result.zakatDue.units, 200000); // 2,000.00 SAR
      expect(result.status, ZakatResultStatus.due);
    });

    test('Calculation 2: Exact boundary conditions (zero assets, negative net base)', () async {
      // Debt: 50,000 SAR, Cash: 10,000 SAR -> Net Base: 0 SAR
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 10000.0),
      );
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createDebtLiability(amount: 50000.0),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      final result = calcRes.valueOrNull!;

      expect(result.netZakatableBase.units, 0);
      expect(result.zakatDue.units, 0);
      expect(result.status, ZakatResultStatus.notDueBelowNisab);
    });
  });
}
