import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Local Storage Persistence Suite (§75, §134)', () {
    late MemoryStorageRegistry registry;

    setUp(() {
      registry = MemoryStorageRegistry();
    });

    test('Persistence 1: Assets, policies, and snapshots persist across module re-instantiations', () async {
      // Phase 1: Write data with Module Instance 1
      final module1 = ZakatModule(storageRegistry: registry);
      await module1.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(title: 'حساب استثماري دائم', amount: 80000.0),
      );
      await module1.setActivePolicy(ZakatPolicy.silverStandard.policyId);

      final calc = await module1.calculateZakat();
      await module1.saveSnapshot(calc.valueOrNull!);

      // Phase 2: Create Module Instance 2 sharing same registry (simulating restart)
      final module2 = ZakatModule(storageRegistry: registry);
      final assets = (await module2.getAssets()).valueOrNull!;
      final activePolicy = await module2.getActivePolicy();
      final snapshots = (await module2.getSnapshots()).valueOrNull!;

      expect(assets.length, 1);
      expect(assets.first.title, 'حساب استثماري دائم');
      expect(assets.first.amount.units, 8000000);
      expect(activePolicy.policyId, ZakatPolicy.silverStandard.policyId);
      expect(snapshots.length, 1);
    });
  });
}
