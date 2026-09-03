import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/store/read_only_adhkar_store.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';
import '../../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('Cross-Module Zakat & Sacred Shield Invariance Tests (§32, §44)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatMod;
    late ReadOnlyCanonicalQuranStore quranStore;
    late ReadOnlyAdhkarStore adhkarStore;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatMod = ZakatModule(storageRegistry: registry);

      // Mount Canonical Quran
      quranStore = ReadOnlyCanonicalQuranStore();
      final quranPkg = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(quranPkg);

      // Mount Canonical Adhkar
      adhkarStore = ReadOnlyAdhkarStore();
      final adhkarPkg = CanonicalAdhkarFixture.createValidTestPackage();
      adhkarStore.mountPackage(adhkarPkg);
    });

    test('Executing Zakat operations causes 0 modifications to Quran and Adhkar stores', () async {
      final initialAyahRes = quranStore.getAyah(1, 1);
      expect(initialAyahRes.isSuccess, isTrue);
      final initialAyah = initialAyahRes.valueOrNull!;

      final initialAdhkarHash = adhkarStore.activePackage!.contentHash;

      // 1. Add multiple assets
      for (var i = 0; i < 50; i++) {
        await zakatMod.addOrUpdateAsset(
          SyntheticZakatFixtures.createCashAsset(id: 'asset_$i', amount: 1000.0 * (i + 1)),
        );
      }

      // 2. Perform calculations
      final calcRes = await zakatMod.calculateZakat();
      expect(calcRes.isSuccess, isTrue);

      // 3. Save snapshot
      await zakatMod.saveSnapshot(calcRes.valueOrNull!);

      // 4. Reset user data
      await zakatMod.resetAllUserData();

      // 5. Verify Quran and Adhkar stores are completely intact and untouched
      final afterAyahRes = quranStore.getAyah(1, 1);
      expect(afterAyahRes.isSuccess, isTrue);
      expect(afterAyahRes.valueOrNull!, equals(initialAyah));
      expect(afterAyahRes.valueOrNull!.integrityHash, equals(initialAyah.integrityHash));

      expect(adhkarStore.activePackage!.contentHash, equals(initialAdhkarHash));
    });
  });
}
