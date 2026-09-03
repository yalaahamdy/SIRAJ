import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/time/clock.dart';
import '../../quran/store/canonical_quran_store.dart';
import '../domain/mastery_snapshot.dart';
import '../domain/memorization_item.dart';
import '../domain/memorization_state.dart';
import '../store/memorization_user_data_store.dart';

/// Service calculating statistical metrics, mastery snapshots, and per-Surah progress (§21, §22).
class MemorizationProgressService {
  final MemorizationUserDataStore _store;
  final ReadOnlyCanonicalQuranStore _quranStore;
  final Clock _clock;

  MemorizationProgressService({
    required MemorizationUserDataStore store,
    required ReadOnlyCanonicalQuranStore quranStore,
    Clock? clock,
  })  : _store = store,
        _quranStore = quranStore,
        _clock = clock ?? const SystemClock();

  /// Generates a comprehensive [MasterySnapshot] of the user's memorization state.
  Future<Result<MasterySnapshot, Failure>> getMasterySnapshot() async {
    final planRes = await _store.getPlan();
    final itemsRes = await _store.getItems();
    final streakRes = await _store.getConsistencyStreak();

    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final items = itemsRes.valueOrNull ?? [];
    final streak = streakRes.valueOrNull ?? 0;
    final plan = planRes.valueOrNull;

    var notStarted = 0;
    var learning = 0;
    var inProgress = 0;
    var memorized = 0;
    var mastered = 0;
    var needsReview = 0;
    var weak = 0;
    var totalScore = 0.0;

    final now = _clock.nowUtc();

    for (final item in items) {
      totalScore += item.masteryScore;
      if (item.state == MemorizationState.weak) {
        weak++;
      } else if (item.isDue(now)) {
        needsReview++;
      }

      switch (item.state) {
        case MemorizationState.notStarted:
          notStarted++;
          break;
        case MemorizationState.learning:
          learning++;
          break;
        case MemorizationState.inProgress:
          inProgress++;
          break;
        case MemorizationState.memorized:
          memorized++;
          break;
        case MemorizationState.needsReview:
          // already counted
          break;
        case MemorizationState.weak:
          // already counted
          break;
        case MemorizationState.mastered:
          mastered++;
          break;
      }
    }

    var totalTargetAyahs = items.length;
    if (plan != null && _quranStore.isMounted) {
      var planCount = 0;
      for (final sNum in plan.targetSurahs) {
        final surahRes = _quranStore.getSurah(sNum);
        if (surahRes.isSuccess) {
          planCount += surahRes.valueOrNull!.ayahCount;
        }
      }
      if (planCount > totalTargetAyahs) totalTargetAyahs = planCount;
    }

    final avgMastery = items.isNotEmpty ? (totalScore / items.length).clamp(0.0, 100.0) : 0.0;

    return Result.ok(
      MasterySnapshot(
        totalTargetedAyahs: totalTargetAyahs,
        notStartedCount: notStarted,
        learningCount: learning,
        inProgressCount: inProgress,
        memorizedCount: memorized,
        masteredCount: mastered,
        needsReviewCount: needsReview,
        weakCount: weak,
        overallMasteryPercent: avgMastery,
        currentStreakDays: streak,
        snapshotDate: now,
      ),
    );
  }

  /// Calculates completion progress for a single Surah (0.0 to 1.0).
  Future<Result<double, Failure>> getSurahProgress(int surahNumber) async {
    final surahRes = _quranStore.getSurah(surahNumber);
    if (surahRes.isFailure) return Result.err(surahRes.failureOrNull!);

    final itemsRes = await _store.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final ayahCount = surahRes.valueOrNull!.ayahCount;
    if (ayahCount == 0) return Result.ok(0.0);

    final memorizedInSurah = itemsRes.valueOrNull!
        .where((i) => i.surahNumber == surahNumber && (i.state == MemorizationState.memorized || i.state == MemorizationState.mastered))
        .length;

    return Result.ok((memorizedInSurah / ayahCount).clamp(0.0, 1.0));
  }

  /// Retrieves list of weak items requiring extra focus.
  Future<Result<List<MemorizationItem>, Failure>> getWeakItems() async {
    final itemsRes = await _store.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final weak = itemsRes.valueOrNull!.where((i) => i.state == MemorizationState.weak).toList();
    return Result.ok(List.unmodifiable(weak));
  }
}
