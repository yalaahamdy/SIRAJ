import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/domain/review_result.dart';
import 'package:siraj/modules/memorization/store/memorization_user_data_store.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

void main() {
  group('L2 Memorization User Data Store Tests (§2, §3, §26, §27)', () {
    late MemoryStorageRegistry storage;
    late TestClock clock;
    late MemorizationUserDataStore store;

    setUp(() {
      storage = MemoryStorageRegistry();
      clock = TestClock(DateTime.utc(2026, 8, 31, 10, 0));
      store = MemorizationUserDataStore(storageRegistry: storage, clock: clock);
    });

    test('Initializes schema version 1 and persists plan', () async {
      await store.initialize();

      final plan = MemorizationPlan.createDefaultJuzAmma(clock.nowUtc());
      final saveRes = await store.savePlan(plan);
      expect(saveRes.isSuccess, isTrue);

      final loadedPlanRes = await store.getPlan();
      expect(loadedPlanRes.isSuccess, isTrue);
      expect(loadedPlanRes.valueOrNull?.title, equals(plan.title));
      expect(loadedPlanRes.valueOrNull?.targetSurahs.length, equals(37));
    });

    test('Saves and retrieves memorization items list', () async {
      final items = [
        MemorizationItem(
          ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
          state: MemorizationState.memorized,
          repetitions: 4,
          intervalDays: 14,
          masteryScore: 80.0,
          createdAt: clock.nowUtc(),
          updatedAt: clock.nowUtc(),
        ),
        MemorizationItem(
          ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 2),
          state: MemorizationState.learning,
          createdAt: clock.nowUtc(),
          updatedAt: clock.nowUtc(),
        ),
      ];

      await store.saveItems(items);
      final retrievedRes = await store.getItems();

      expect(retrievedRes.isSuccess, isTrue);
      expect(retrievedRes.valueOrNull?.length, equals(2));
      expect(retrievedRes.valueOrNull?[0].ayahKey, equals(const AyahKey(surahNumber: 1, ayahNumber: 1)));
      expect(retrievedRes.valueOrNull?[1].state, equals(MemorizationState.learning));
    });

    test('Consistency Streak: consecutive days increment streak, skipped days reset gracefully', () async {
      // Day 1: 2026-08-31
      final s1 = await store.recordSessionCompleted();
      expect(s1.valueOrNull, equals(1));

      // Day 2: 2026-09-01
      clock.setTime(DateTime.utc(2026, 9, 1, 10, 0));
      final s2 = await store.recordSessionCompleted();
      expect(s2.valueOrNull, equals(2));

      // Day 4: 2026-09-03 (Skipped Day 3)
      clock.setTime(DateTime.utc(2026, 9, 3, 10, 0));
      final s3 = await store.recordSessionCompleted();
      expect(s3.valueOrNull, equals(1));
    });

    test('Safe Reset: wipes user data from mod_memorization without leaving residue', () async {
      await store.saveItems([
        MemorizationItem(
          ayahKey: const AyahKey(surahNumber: 114, ayahNumber: 1),
          state: MemorizationState.memorized,
          createdAt: clock.nowUtc(),
          updatedAt: clock.nowUtc(),
        ),
      ]);
      await store.appendReviewResults([
        ReviewResult(
          ayahKey: const AyahKey(surahNumber: 114, ayahNumber: 1),
          quality: ReviewQuality.good,
          scheduledIntervalDays: 3,
          reviewedAt: clock.nowUtc(),
        ),
      ]);

      final resetRes = await store.resetAllData();
      expect(resetRes.isSuccess, isTrue);

      final itemsAfter = await store.getItems();
      final historyAfter = await store.getReviewHistory();

      expect(itemsAfter.valueOrNull, isEmpty);
      expect(historyAfter.valueOrNull, isEmpty);
    });
  });
}
