import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Real-World Performance Suite (§115..§118, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    test('Performance 1: Calculation across 100 assets executes in < 150ms', () async {
      for (int i = 0; i < 100; i++) {
        await zakatModule.addOrUpdateAsset(
          SyntheticZakatFixtures.createCashAsset(
            id: 'asset_$i',
            title: 'أصل استثماري رقم $i',
            amount: 1000.0 * (i + 1),
          ),
        );
      }

      final stopwatch = Stopwatch()..start();
      final calcRes = await zakatModule.calculateZakat();
      stopwatch.stop();

      expect(calcRes.isSuccess, true);
      expect(stopwatch.elapsedMilliseconds, lessThan(150));
    });

    test('Performance 2: Snapshot save and verify hash executes in < 100ms', () async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 50000.0),
      );
      final calcRes = await zakatModule.calculateZakat();

      final stopwatch = Stopwatch()..start();
      final snapRes = await zakatModule.saveSnapshot(calcRes.valueOrNull!);
      stopwatch.stop();

      expect(snapRes.isSuccess, true);
      expect(snapRes.valueOrNull!.verifyHash(), true);
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
