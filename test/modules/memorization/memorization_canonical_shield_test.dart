import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L2 Memorization Sacred Content Canonical Shield Tests (§33)', () {
    late MemoryStorageRegistry storage;
    late TestClock clock;
    late ReadOnlyCanonicalQuranStore quranStore;
    late MemorizationModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      clock = TestClock(DateTime.utc(2026, 8, 31, 10, 0));
      quranStore = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(package);

      module = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranStore,
        customClock: clock,
      );
    });

    test('Sacred Content Invariance: Memorization engine cannot mutate canonical Quran text or hashes', () async {
      // 1. Snapshot canonical text & hashes before any operations
      final fatihah1Before = quranStore.getAyah(1, 1).valueOrNull!;
      final fatihah1TextBefore = fatihah1Before.textUthmani;
      final fatihah1HashBefore = fatihah1Before.integrityHash;

      final ikhlas1Before = quranStore.getAyah(112, 1).valueOrNull!;
      final ikhlas1TextBefore = ikhlas1Before.textUthmani;
      final ikhlas1HashBefore = ikhlas1Before.integrityHash;

      // 2. Perform extensive memorization lifecycle operations
      await module.initialize();
      final plan = MemorizationPlan.createDefaultJuzAmma(clock.nowUtc());
      await module.savePlan(plan);

      var session = (await module.getOrCreateTodaySession()).valueOrNull!;
      for (var i = 1; i <= 5; i++) {
        session = (await module.submitReview(
          session: session,
          ayahKey: AyahKey(surahNumber: 112, ayahNumber: i <= 4 ? i : 1),
          quality: i.isEven ? ReviewQuality.again : ReviewQuality.good,
        )).valueOrNull!;
      }

      // Reset all user data
      await module.resetAllData();

      // 3. Snapshot canonical text & hashes after operations
      final fatihah1After = quranStore.getAyah(1, 1).valueOrNull!;
      final ikhlas1After = quranStore.getAyah(112, 1).valueOrNull!;

      // 4. Invariance Assertions
      expect(fatihah1After.textUthmani, equals(fatihah1TextBefore));
      expect(fatihah1After.integrityHash, equals(fatihah1HashBefore));
      expect(fatihah1After.verifyIntegrity(), isTrue);

      expect(ikhlas1After.textUthmani, equals(ikhlas1TextBefore));
      expect(ikhlas1After.integrityHash, equals(ikhlas1HashBefore));
      expect(ikhlas1After.verifyIntegrity(), isTrue);
    });
  });
}
