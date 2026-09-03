import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/time/clock.dart';
import '../../quran/domain/ayah_key.dart';
import '../../quran/store/canonical_quran_store.dart';
import '../domain/memorization_item.dart';
import '../domain/memorization_state.dart';
import '../domain/mistake_record.dart';
import '../domain/review_quality.dart';
import '../domain/review_result.dart';
import '../domain/review_session.dart';
import '../scheduler/review_scheduler_strategy.dart';
import '../scheduler/spaced_repetition_scheduler.dart';
import '../store/memorization_user_data_store.dart';

/// Engine responsible for preparing, executing, and finalizing daily memorization & review sessions (§17, §18).
class DailySessionEngine {
  final MemorizationUserDataStore _store;
  final ReadOnlyCanonicalQuranStore _quranStore;
  final ReviewSchedulerStrategy _scheduler;
  final Clock _clock;

  DailySessionEngine({
    required MemorizationUserDataStore store,
    required ReadOnlyCanonicalQuranStore quranStore,
    ReviewSchedulerStrategy? scheduler,
    Clock? clock,
  })  : _store = store,
        _quranStore = quranStore,
        _scheduler = scheduler ?? const SpacedRepetitionScheduler(),
        _clock = clock ?? const SystemClock();

  /// Prepares or resumes the daily study session for today.
  Future<Result<ReviewSession, Failure>> getOrCreateTodaySession() async {
    final now = _clock.nowUtc();
    final todayMidnight = DateTime.utc(now.year, now.month, now.day);

    // Check if an active/paused session exists for today
    final activeRes = await _store.getActiveSession();
    if (activeRes.isSuccess && activeRes.valueOrNull != null) {
      final active = activeRes.valueOrNull!;
      final activeMidnight = DateTime.utc(active.date.year, active.date.month, active.date.day);
      if (activeMidnight.isAtSameMomentAs(todayMidnight) && !active.isCompleted) {
        return Result.ok(active);
      }
    }

    // Load Plan & All Items
    final planRes = await _store.getPlan();
    final itemsRes = await _store.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final allItemsMap = {for (final item in itemsRes.valueOrNull ?? <MemorizationItem>[]) item.ayahKey: item};
    final plan = planRes.valueOrNull;

    // 1. Gather Due / Overdue items
    final reviewKeys = <AyahKey>[];
    final weakKeys = <AyahKey>[];

    for (final item in allItemsMap.values) {
      if (item.state == MemorizationState.weak) {
        weakKeys.add(item.ayahKey);
      } else if (item.isDue(now)) {
        reviewKeys.add(item.ayahKey);
      }
    }

    // Limit reviews according to plan if configured
    final maxReviews = plan?.dailyReviewTarget ?? 20;
    final cappedReviewKeys = reviewKeys.take(maxReviews).toList();

    // 2. Gather New items to learn from plan
    final newKeys = <AyahKey>[];
    if (plan != null) {
      final dailyTarget = plan.dailyNewAyahs;
      // Traverse target surahs to find unstarted ayahs
      for (final sNum in plan.targetSurahs) {
        final surahAyahsRes = _quranStore.getSurahAyahs(sNum);
        if (surahAyahsRes.isSuccess) {
          for (final ayah in surahAyahsRes.valueOrNull!) {
            final key = ayah.key;
            final existing = allItemsMap[key];
            if (existing == null || existing.state == MemorizationState.notStarted) {
              newKeys.add(key);
              if (newKeys.length >= dailyTarget) break;
            }
          }
        }
        if (newKeys.length >= dailyTarget) break;
      }
    }

    final newSession = ReviewSession(
      id: 'session_${now.millisecondsSinceEpoch}',
      date: todayMidnight,
      newAyahs: List.unmodifiable(newKeys),
      reviewAyahs: List.unmodifiable(cappedReviewKeys),
      weakAyahs: List.unmodifiable(weakKeys),
      results: const [],
      isCompleted: false,
      startedAt: now,
    );

    await _store.saveActiveSession(newSession);
    return Result.ok(newSession);
  }

  /// Submits the review evaluation for an Ayah in the current session.
  Future<Result<ReviewSession, Failure>> submitReview({
    required ReviewSession session,
    required AyahKey ayahKey,
    required ReviewQuality quality,
    int timeTakenMs = 0,
    MistakeRecord? mistake,
  }) async {
    final now = _clock.nowUtc();
    final itemsRes = await _store.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final itemsList = List<MemorizationItem>.from(itemsRes.valueOrNull ?? []);
    final idx = itemsList.indexWhere((i) => i.ayahKey == ayahKey);

    MemorizationItem currentItem;
    if (idx != -1) {
      currentItem = itemsList[idx];
    } else {
      // First time encountered -> initialize
      currentItem = MemorizationItem(
        ayahKey: ayahKey,
        state: MemorizationState.learning,
        createdAt: now,
        updatedAt: now,
      );
      itemsList.add(currentItem);
    }

    // Process review through scheduler
    final updatedItem = _scheduler.processReview(
      item: currentItem,
      quality: quality,
      currentDate: now,
    );

    // Save updated item in store
    final saveIdx = itemsList.indexWhere((i) => i.ayahKey == ayahKey);
    itemsList[saveIdx] = updatedItem;
    await _store.saveItems(itemsList);

    // Create review result record
    final result = ReviewResult(
      ayahKey: ayahKey,
      quality: quality,
      scheduledIntervalDays: updatedItem.intervalDays,
      timeTakenMs: timeTakenMs,
      mistake: mistake,
      reviewedAt: now,
    );

    // Append or update in session results (idempotent)
    final updatedResults = List<ReviewResult>.from(session.results);
    final existingResIdx = updatedResults.indexWhere((r) => r.ayahKey == ayahKey);
    if (existingResIdx != -1) {
      updatedResults[existingResIdx] = result;
    } else {
      updatedResults.add(result);
    }
    final isDone = updatedResults.length >= session.totalItemsCount;

    final updatedSession = session.copyWith(
      results: updatedResults,
      isCompleted: isDone,
      completedAt: isDone ? now : null,
    );

    await _store.saveActiveSession(updatedSession);
    await _store.appendReviewResults([result]);

    if (isDone) {
      await _store.recordSessionCompleted();
    }

    return Result.ok(updatedSession);
  }
}
