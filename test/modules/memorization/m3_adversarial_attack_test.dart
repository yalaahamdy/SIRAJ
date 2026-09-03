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
  group('M3 Memorization Adversarial Attack & Hardening Tests (§45)', () {
    late MemoryStorageRegistry storage;
    late TestClock clock;
    late ReadOnlyCanonicalQuranStore quranStore;
    late MemorizationModule module;

    setUp(() async {
      storage = MemoryStorageRegistry();
      clock = TestClock(DateTime.utc(2026, 8, 31, 12, 0));
      quranStore = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(package);

      module = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranStore,
        customClock: clock,
      );
      await module.initialize();
    });

    test('Attack 1: Temporal Distortion (Future/Past date shifts maintain valid intervals)', () async {
      final plan = MemorizationPlan.createDefaultJuzAmma(clock.nowUtc());
      await module.savePlan(plan);

      var session = (await module.getOrCreateTodaySession()).valueOrNull!;

      // Warp clock forward 10 years
      clock.setTime(DateTime.utc(2036, 1, 1, 12, 0));

      final updatedSessionRes = await module.submitReview(
        session: session,
        ayahKey: const AyahKey(surahNumber: 114, ayahNumber: 1),
        quality: ReviewQuality.good,
      );

      expect(updatedSessionRes.isSuccess, isTrue);
      final items = (await module.getAllItems()).valueOrNull!;
      final reviewed = items.firstWhere((i) => i.ayahKey == const AyahKey(surahNumber: 114, ayahNumber: 1));

      expect(reviewed.intervalDays, greaterThanOrEqualTo(1));
      expect(reviewed.nextReviewDue?.year, equals(2036));
    });

    test('Attack 2: Storage Corruption Resilience (Malformed JSON returns typed Failure without crash)', () async {
      // Inject malformed JSON directly into mod_memorization
      final memStore = storage.getStoreForModule('mod_memorization');
      await memStore.setString('memorization_items', 'INVALID_JSON_CORRUPTED_STREAM{{{');

      final itemsRes = await module.getAllItems();
      expect(itemsRes.isFailure, isTrue);
      expect(itemsRes.failureOrNull?.message.contains('Corrupted'), isTrue);
    });

    test('Attack 3: User Data Cross-Module Isolation (Resetting memorization leaves Quran bookmarks intact)', () async {
      // Put a bookmark in mod_quran
      final quranStoreMod = storage.getStoreForModule('mod_quran');
      await quranStoreMod.setString('user_bookmarks_list', '[{"id":"bm1"}]');

      // Put items in memorization
      await module.savePlan(MemorizationPlan.createDefaultJuzAmma(clock.nowUtc()));

      // Execute Reset on Memorization
      final resetRes = await module.resetAllData();
      expect(resetRes.isSuccess, isTrue);

      // Verify Quran bookmark remains intact
      final bmRes = await quranStoreMod.getString('user_bookmarks_list');
      expect(bmRes.valueOrNull, equals('[{"id":"bm1"}]'));
    });
  });
}
