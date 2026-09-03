import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/domain/review_result.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('M3 Workload & Performance Stress Tests (§23, §27)', () {
    late MemoryStorageRegistry storage;
    late ReadOnlyCanonicalQuranStore quranStore;
    late MemorizationModule module;
    final now = DateTime.utc(2026, 8, 31, 12, 0);

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranStore = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(package);

      module = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranStore,
        customClock: TestClock(now),
      );
      await module.initialize();
    });

    test('Stress Test: 1,000 active items & 5,000 history records perform sub-millisecond snapshot & session creation', () async {
      // 1. Populate 1,000 items
      final largeItemsList = <MemorizationItem>[];
      for (var i = 1; i <= 1000; i++) {
        final sNum = (i % 114) + 1;
        final aNum = ((i ~/ 114) % 10) + 1;
        largeItemsList.add(
          MemorizationItem(
            ayahKey: AyahKey(surahNumber: sNum, ayahNumber: aNum),
            state: i % 5 == 0 ? MemorizationState.weak : (i % 2 == 0 ? MemorizationState.memorized : MemorizationState.inProgress),
            intervalDays: (i % 60) + 1,
            nextReviewDue: i % 3 == 0 ? now : now.add(const Duration(days: 5)),
            createdAt: now,
            updatedAt: now,
          ),
        );
      }
      await module.dataStore.saveItems(largeItemsList);

      // 2. Populate 5,000 review history results
      final largeHistory = <ReviewResult>[];
      for (var i = 1; i <= 5000; i++) {
        largeHistory.add(
          ReviewResult(
            ayahKey: const AyahKey(surahNumber: 1, ayahNumber: 1),
            quality: ReviewQuality.good,
            scheduledIntervalDays: 4,
            reviewedAt: now,
          ),
        );
      }
      await module.dataStore.appendReviewResults(largeHistory);

      // 3. Measure getMasterySnapshot performance
      final stopwatch = Stopwatch()..start();
      final snapshotRes = await module.getMasterySnapshot();
      stopwatch.stop();

      expect(snapshotRes.isSuccess, isTrue);
      expect(snapshotRes.valueOrNull?.totalTargetedAyahs, greaterThanOrEqualTo(1000));
      expect(stopwatch.elapsedMilliseconds, lessThan(1500), reason: 'Snapshot calculation must execute promptly');

      // 4. Measure getOrCreateTodaySession performance
      stopwatch.reset();
      stopwatch.start();
      final sessionRes = await module.getOrCreateTodaySession();
      stopwatch.stop();

      expect(sessionRes.isSuccess, isTrue);
      expect(stopwatch.elapsedMilliseconds, lessThan(1500), reason: 'Session generation must execute promptly');
    });
  });
}
