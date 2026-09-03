import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_result.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Hawl Engine & Temporal Boundaries Suite (§37..§43, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;
    final fixedNow = DateTime.utc(2026, 8, 31);

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(
        storageRegistry: registry,
        customClock: TestClock(fixedNow),
      );
    });

    test('Hawl 1: Complete Hawl (acquired > 354 lunar days ago) marks hawl as complete', () async {
      // Acquired 400 days ago
      final acquisition = fixedNow.subtract(const Duration(days: 400));
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0, acquisitionDate: acquisition),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      final result = calcRes.valueOrNull!;
      expect(result.isHawlComplete, true);
      expect(result.daysRemainingInHawl, 0);
      expect(result.status, ZakatResultStatus.due);
    });

    test('Hawl 2: Incomplete Hawl (acquired recently) marks notDueHawlIncomplete', () async {
      // Acquired 100 days ago
      final acquisition = fixedNow.subtract(const Duration(days: 100));
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0, acquisitionDate: acquisition),
      );

      final calcRes = await zakatModule.calculateZakat();
      expect(calcRes.isSuccess, true);
      final result = calcRes.valueOrNull!;
      expect(result.isHawlComplete, false);
      expect(result.daysRemainingInHawl, greaterThan(0));
      expect(result.status, ZakatResultStatus.notDueHawlIncomplete);
      expect(result.zakatDue.units, 0);
    });
  });
}
