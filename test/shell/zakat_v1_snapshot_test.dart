import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Historical Snapshot Immutability Suite (§54..§61, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    test('Snapshot 1: Historical snapshot remains immutable when active policy or assets change', () async {
      // 1. Initial calculation with gold standard
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0),
      );
      final calcResA = await zakatModule.calculateZakat();
      final snapResA = await zakatModule.saveSnapshot(calcResA.valueOrNull!);
      expect(snapResA.isSuccess, true);
      final snapA = snapResA.valueOrNull!;

      // 2. Change policy to silver standard and modify asset
      await zakatModule.setActivePolicy(ZakatPolicy.silverStandard.policyId);
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 200000.0),
      );

      // 3. Retrieve historical snapshots and verify integrity
      final snapshots = (await zakatModule.getSnapshots()).valueOrNull!;
      expect(snapshots.length, 1);
      final retrievedSnap = snapshots.first;

      expect(retrievedSnap.snapshotId, snapA.snapshotId);
      expect(retrievedSnap.policy.policyId, ZakatPolicy.goldStandard.policyId);
      expect(retrievedSnap.result.grossAssets.units, 10000000);
      expect(retrievedSnap.verifyHash(), true);
    });
  });
}
