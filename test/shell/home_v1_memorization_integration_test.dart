import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Memorization Integration Suite (§34, §114)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
        memorizationModule: memorizationModule,
      );
    });

    test('Memorization Integration 1: Home dashboard presents memorization review and resume entry', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.any((c) => c.sourceModule == 'memorization' || c.targetRoute == '/memorization'), true);
    });
  });
}
