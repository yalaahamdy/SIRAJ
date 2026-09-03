import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Personal Priority Engine & Card Ordering Suite (§6, §7, §85, §114, §116)', () {
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

    test('Priority 1: Priority Engine generates deterministic card order based on time and context (§116)', () async {
      final cards1 = (await companionModule.getDashboardCards()).valueOrNull!;
      final cards2 = (await companionModule.getDashboardCards()).valueOrNull!;

      expect(cards1.length, equals(cards2.length));
      for (int i = 0; i < cards1.length; i++) {
        expect(cards1[i].cardId, equals(cards2[i].cardId));
      }
    });
  });
}
