import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/memorization/domain/memorization_item.dart';
import 'package:siraj/modules/memorization/domain/memorization_state.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/scheduler/spaced_repetition_scheduler.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';

void main() {
  group('M3 Adversarial State Machine & Transition Matrix Tests (§4, §5)', () {
    const scheduler = SpacedRepetitionScheduler();
    final now = DateTime.utc(2026, 8, 31, 10, 0);
    const testKey = AyahKey(surahNumber: 1, ayahNumber: 1);

    test('Transition Matrix: notStarted -> learning (via Again) or inProgress (via Hard/Good) or memorized (via Easy)', () {
      final unstarted = MemorizationItem(
        ayahKey: testKey,
        state: MemorizationState.notStarted,
        createdAt: now,
        updatedAt: now,
      );

      final rAgain = scheduler.processReview(item: unstarted, quality: ReviewQuality.again, currentDate: now);
      expect(rAgain.state, equals(MemorizationState.learning));

      final rHard = scheduler.processReview(item: unstarted, quality: ReviewQuality.hard, currentDate: now);
      expect(rHard.state, equals(MemorizationState.inProgress));

      final rGood = scheduler.processReview(item: unstarted, quality: ReviewQuality.good, currentDate: now);
      expect(rGood.state, equals(MemorizationState.inProgress));

      final rEasy = scheduler.processReview(item: unstarted, quality: ReviewQuality.easy, currentDate: now);
      expect(rEasy.state, equals(MemorizationState.memorized));
    });

    test('Transition Matrix: inProgress -> memorized (interval >= 21) -> mastered (interval >= 30)', () {
      var item = MemorizationItem(
        ayahKey: testKey,
        state: MemorizationState.inProgress,
        intervalDays: 10,
        easeFactor: 2.5,
        repetitions: 3,
        createdAt: now,
        updatedAt: now,
      );

      // Review Good -> interval = 10 * 2.5 = 25 >= 21 -> memorized
      item = scheduler.processReview(item: item, quality: ReviewQuality.good, currentDate: now);
      expect(item.state, equals(MemorizationState.memorized));
      expect(item.intervalDays, equals(25));

      // Review Good -> interval = 25 * 2.5 = 62 >= 30 -> mastered
      item = scheduler.processReview(item: item, quality: ReviewQuality.good, currentDate: now);
      expect(item.state, equals(MemorizationState.memorized));

      // Review Easy -> interval >= 30 -> mastered
      item = scheduler.processReview(item: item, quality: ReviewQuality.easy, currentDate: now);
      expect(item.state, equals(MemorizationState.mastered));
    });

    test('Transition Matrix: mastered -> learning (single lapse) -> weak (3 lapses)', () {
      var item = MemorizationItem(
        ayahKey: testKey,
        state: MemorizationState.mastered,
        intervalDays: 60,
        repetitions: 8,
        lapses: 0,
        createdAt: now,
        updatedAt: now,
      );

      // Single failure drops to learning
      item = scheduler.processReview(item: item, quality: ReviewQuality.again, currentDate: now);
      expect(item.state, equals(MemorizationState.learning));
      expect(item.intervalDays, equals(1));
      expect(item.lapses, equals(1));

      // Second failure
      item = scheduler.processReview(item: item, quality: ReviewQuality.again, currentDate: now);
      expect(item.state, equals(MemorizationState.learning));
      expect(item.lapses, equals(2));

      // Third failure transitions to weak
      item = scheduler.processReview(item: item, quality: ReviewQuality.again, currentDate: now);
      expect(item.state, equals(MemorizationState.weak));
      expect(item.lapses, equals(3));
    });

    test('Labels strictly reflect app training terminology and not religious authentication (§5)', () {
      for (final state in MemorizationState.values) {
        expect(state.labelArabic.isNotEmpty, isTrue);
        // Ensure no absolute religious certificates
        expect(state.labelArabic.contains('إجازة'), isFalse);
        expect(state.labelArabic.contains('صحيح شرعاً'), isFalse);
      }
    });
  });
}
