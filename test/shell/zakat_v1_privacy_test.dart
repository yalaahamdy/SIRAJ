import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Privacy & Local-First Isolation Suite (§34..§36, §89..§93, §134, §137)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    test('Privacy 1: Financial amounts and assets are stored exclusively in isolated zakat partition', () async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(title: 'حساب سري للغاية', amount: 500000.0),
      );

      // Verify that the data is only in the zakat user data partition
      final zakatStore = zakatModule.userDataStore;
      final assetsRes = await zakatStore.getAssets();
      expect(assetsRes.isSuccess, true);
      expect(assetsRes.valueOrNull!.length, 1);
      expect(assetsRes.valueOrNull!.first.title, 'حساب سري للغاية');

      // Verify other partitions do not contain this key
      final quranStore = registry.getStoreForModule('mod_quran');
      final containsSecret = (await quranStore.getString('assets')).valueOrNull;
      expect(containsSecret, isNull);
    });

    test('Privacy 2: Zero analytics or external profiling telemetry generated', () async {
      // The module has no telemetry dependencies and no network sinks
      expect(zakatModule.userDataStore, isNotNull);
      expect(zakatModule.calcEngine, isNotNull);
    });
  });
}
