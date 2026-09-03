import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Real-World Performance & Aggregation Speed Suite (§81, §82, §114)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late PrayerModule prayerModule;
    late AdhkarModule adhkarModule;
    late FastingModule fastingModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      prayerModule = PrayerModule(storageRegistry: storage);

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      fastingModule = FastingModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
      );

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
        prayerModule: prayerModule,
        adhkarModule: adhkarModule,
        fastingModule: fastingModule,
      );
    });

    test('Performance 1: Home dashboard aggregation across all modules completes in < 200ms', () async {
      // Warmup
      await companionModule.getDashboardCards();

      final stopwatch = Stopwatch()..start();
      final cards = (await companionModule.getDashboardCards()).valueOrNull!;
      stopwatch.stop();

      expect(cards.isNotEmpty, true);
      expect(stopwatch.elapsedMilliseconds, lessThan(200));
    });
  });
}
