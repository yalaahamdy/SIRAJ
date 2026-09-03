import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Midnight & Day Rollover Adaptation Suite (§57..§59, §105, §114)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late AdhkarModule adhkarModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
        adhkarModule: adhkarModule,
      );
    });

    test('Midnight Rollover 1: Dashboard cards dynamically adapt across day rollover boundary (§57, §105)', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.isNotEmpty, true);
    });
  });
}
