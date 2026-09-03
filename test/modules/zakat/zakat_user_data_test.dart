import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/zakat_calculation_snapshot.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/engine/zakat_calculation_engine.dart';
import 'package:siraj/modules/zakat/store/zakat_user_data_store.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('L2 ZakatUserDataStore Local-First Isolation & Snapshots Tests (§5, §6, §28)', () {
    late MemoryStorageRegistry registry;
    late ZakatUserDataStore store;

    setUp(() {
      registry = MemoryStorageRegistry();
      store = ZakatUserDataStore(storageRegistry: registry);
    });

    test('Saves, retrieves, and deletes assets strictly inside mod_zakat namespace', () async {
      final asset1 = SyntheticZakatFixtures.createCashAsset(id: 'asset_001', amount: 50000);
      final asset2 = SyntheticZakatFixtures.createCashAsset(id: 'asset_002', amount: 25000);

      await store.saveAsset(asset1);
      await store.saveAsset(asset2);

      final listRes = await store.getAssets();
      expect(listRes.isSuccess, isTrue);
      expect(listRes.valueOrNull!.length, equals(2));

      await store.deleteAsset('asset_001');
      final afterDelete = await store.getAssets();
      expect(afterDelete.valueOrNull!.length, equals(1));
      expect(afterDelete.valueOrNull!.first.id, equals('asset_002'));
    });

    test('Saves historical calculation snapshot and verifies SHA-256 integrity', () async {
      final calcEngine = ZakatCalculationEngine();
      final marketSnapshot = SyntheticZakatFixtures.createMarketSnapshot();
      final asset = SyntheticZakatFixtures.createCashAsset(amount: 100000);

      final result = calcEngine.calculate(
        assets: [asset],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
      );

      final snapshot = ZakatCalculationSnapshot.create(
        snapshotId: 'snap_test_001',
        assets: [asset],
        policy: ZakatPolicy.goldStandard,
        marketSnapshot: marketSnapshot,
        result: result,
        createdAt: DateTime.utc(2026, 8, 31),
      );

      expect(snapshot.verifyHash(), isTrue);
      expect(snapshot.integrityHash.startsWith('sha256:'), isTrue);

      await store.saveSnapshot(snapshot);
      final snapsRes = await store.getSnapshots();
      expect(snapsRes.isSuccess, isTrue);
      expect(snapsRes.valueOrNull!.length, equals(1));
      expect(snapsRes.valueOrNull!.first.verifyHash(), isTrue);
    });

    test('Reset clears all user financial data completely from local store', () async {
      final asset = SyntheticZakatFixtures.createCashAsset();
      await store.saveAsset(asset);
      await store.setSelectedPolicyId('custom_policy');

      final resetRes = await store.resetAllUserData();
      expect(resetRes.isSuccess, isTrue);

      final assets = await store.getAssets();
      expect(assets.valueOrNull!, isEmpty);

      final policy = await store.getSelectedPolicyId();
      expect(policy.valueOrNull, isNull);
    });
  });
}
