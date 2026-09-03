import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Local-First Offline Home Resilience Suite (§41, §42, §103, §114)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late PrayerModule prayerModule;
    late AdhkarModule adhkarModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      prayerModule = PrayerModule(storageRegistry: storage);

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
        prayerModule: prayerModule,
        adhkarModule: adhkarModule,
      );
    });

    test('Offline 1: Home dashboard operates completely offline from mounted local packages (§41, §103)', () async {
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      expect(cards.isNotEmpty, true);
    });
  });
}
