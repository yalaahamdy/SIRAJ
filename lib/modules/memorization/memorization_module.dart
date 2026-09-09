import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/storage/storage_contract.dart';
import '../../core/time/clock.dart';
import '../quran/domain/ayah.dart';
import '../quran/domain/ayah_key.dart';
import '../quran/store/canonical_quran_store.dart';
import 'domain/mastery_snapshot.dart';
import 'domain/memorization_item.dart';
import 'domain/memorization_plan.dart';
import 'domain/tahfeez_surah_summary.dart';
import 'domain/memorization_state.dart';
import 'domain/mistake_record.dart';
import 'domain/review_quality.dart';
import 'domain/review_session.dart';
import 'scheduler/review_scheduler_strategy.dart';
import 'scheduler/spaced_repetition_scheduler.dart';
import 'services/daily_session_engine.dart';
import 'services/memorization_progress_service.dart';
import 'store/memorization_user_data_store.dart';

import 'services/past_memorization_engine.dart';

/// Unified Module Facade for the Quran Memorization Subsystem (L2).
/// Encapsulates storage, scheduling, session workflows, and mastery tracking.
class MemorizationModule {
  final MemorizationUserDataStore dataStore;
  final ReviewSchedulerStrategy scheduler;
  final DailySessionEngine sessionEngine;
  final MemorizationProgressService progressService;
  final PastMemorizationEngine pastMemorizationEngine;
  final ReadOnlyCanonicalQuranStore quranStore;
  final Clock clock;

  MemorizationModule({
    required StorageRegistry storageRegistry,
    required ReadOnlyCanonicalQuranStore quranStore,
    ReviewSchedulerStrategy? customScheduler,
    Clock? customClock,
  }) : this._internal(
          dataStore: MemorizationUserDataStore(
            storageRegistry: storageRegistry,
            clock: customClock,
          ),
          scheduler: customScheduler ?? const SpacedRepetitionScheduler(),
          quranStore: quranStore,
          clock: customClock ?? const SystemClock(),
        );

  MemorizationModule._internal({
    required this.dataStore,
    required this.scheduler,
    required this.quranStore,
    required this.clock,
  })  : sessionEngine = DailySessionEngine(
          store: dataStore,
          quranStore: quranStore,
          scheduler: scheduler,
          clock: clock,
        ),
        progressService = MemorizationProgressService(
          store: dataStore,
          quranStore: quranStore,
          clock: clock,
        ),
        pastMemorizationEngine = PastMemorizationEngine(
          store: dataStore,
          quranStore: quranStore,
          clock: clock,
        );

  /// Initializes storage and schema versioning.
  Future<Result<bool, Failure>> initialize() => dataStore.initialize();

  /// Retrieves the active memorization plan.
  Future<Result<MemorizationPlan?, Failure>> getPlan() => dataStore.getPlan();

  /// Saves or updates the memorization plan.
  Future<Result<bool, Failure>> savePlan(MemorizationPlan plan) => dataStore.savePlan(plan);

  /// Prepares or resumes the daily study session.
  Future<Result<ReviewSession, Failure>> getOrCreateTodaySession() => sessionEngine.getOrCreateTodaySession();

  /// Submits the recall quality evaluation for an Ayah during review.
  Future<Result<ReviewSession, Failure>> submitReview({
    required ReviewSession session,
    required AyahKey ayahKey,
    required ReviewQuality quality,
    int timeTakenMs = 0,
    MistakeRecord? mistake,
  }) =>
      sessionEngine.submitReview(
        session: session,
        ayahKey: ayahKey,
        quality: quality,
        timeTakenMs: timeTakenMs,
        mistake: mistake,
      );

  /// Retrieves statistical mastery snapshot.
  Future<Result<MasterySnapshot, Failure>> getMasterySnapshot() => progressService.getMasterySnapshot();

  /// Retrieves Surah completion progress (0.0 to 1.0).
  Future<Result<double, Failure>> getSurahProgress(int surahNumber) => progressService.getSurahProgress(surahNumber);

  /// Retrieves list of weak items requiring extra focus.
  Future<Result<List<MemorizationItem>, Failure>> getWeakItems() => progressService.getWeakItems();

  /// Retrieves all memorization items.
  Future<Result<List<MemorizationItem>, Failure>> getAllItems() => dataStore.getItems();

  /// Retrieves consistency streak count.
  Future<Result<int, Failure>> getConsistencyStreak() => dataStore.getConsistencyStreak();

  /// Adds an individual Ayah to the active memorization items if not already present (§82, §83).
  Future<Result<bool, Failure>> addAyahToPlan(AyahKey key) async {
    final itemsRes = await dataStore.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final currentItems = List<MemorizationItem>.from(itemsRes.valueOrNull ?? []);
    if (currentItems.any((i) => i.ayahKey == key)) {
      return Result.ok(true); // Already in plan
    }

    final now = clock.nowUtc();
    final newItem = MemorizationItem(
      ayahKey: key,
      state: MemorizationState.notStarted,
      createdAt: now,
      updatedAt: now,
    );
    currentItems.add(newItem);

    final saveRes = await dataStore.saveItems(currentItems);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    return Result.ok(true);
  }

  /// Adds a list of Ayahs to the active memorization items without duplicates (§55, §56, §57).
  Future<Result<int, Failure>> addAyahsToPlan(List<AyahKey> keys) async {
    final itemsRes = await dataStore.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final currentItems = List<MemorizationItem>.from(itemsRes.valueOrNull ?? []);
    final existingKeys = currentItems.map((i) => i.ayahKey).toSet();
    final now = clock.nowUtc();

    int addedCount = 0;
    for (final key in keys) {
      if (!existingKeys.contains(key)) {
        currentItems.add(MemorizationItem(
          ayahKey: key,
          state: MemorizationState.notStarted,
          createdAt: now,
          updatedAt: now,
        ));
        existingKeys.add(key);
        addedCount++;
      }
    }

    if (addedCount > 0) {
      final saveRes = await dataStore.saveItems(currentItems);
      if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    }

    return Result.ok(addedCount);
  }

  /// Retrieves past memorization mastery statistics (§38).
  Future<Result<PastMasteryStats, Failure>> getPastMasteryStats() => pastMemorizationEngine.getPastMasteryStats();

  /// Generates a random past memorization exam challenge question (§38, §50).
  Future<Result<PastExamQuestion, Failure>> generatePastExamQuestion({int requestedPassageLength = 3}) =>
      pastMemorizationEngine.generatePastExamQuestion(requestedPassageLength: requestedPassageLength);

  /// Submits the confirmation result for past memorization testing.
  Future<Result<bool, Failure>> submitPastExamResult({
    required PastExamQuestion question,
    required bool isMastered,
  }) =>
      pastMemorizationEngine.submitPastExamResult(question: question, isMastered: isMastered);

  /// Clears the active/cached session for today so a fresh session can be prepared.
  Future<Result<bool, Failure>> clearActiveSession() => sessionEngine.clearActiveSession();

  /// Applies a memorization plan, registers targeted Ayahs, clears old session cache,
  /// and primes today's session immediately.
  Future<Result<bool, Failure>> applyPlanWithAyahs({
    required MemorizationPlan plan,
    required List<AyahKey> ayahs,
  }) async {
    final planRes = await savePlan(plan);
    if (planRes.isFailure) return planRes;

    if (ayahs.isNotEmpty) {
      final addRes = await addAyahsToPlan(ayahs);
      if (addRes.isFailure) return Result.err(addRes.failureOrNull!);
    }

    await clearActiveSession();
    await getOrCreateTodaySession();

    return Result.ok(true);
  }

  /// Executes safe reset of all user memorization data (§27).
  Future<Result<bool, Failure>> resetAllData() => dataStore.resetAllData();

  /// Sets or toggles memorized status for an Ayah directly.
  Future<Result<bool, Failure>> setAyahMemorizedStatus(AyahKey key, bool isMemorized) async {
    final itemsRes = await dataStore.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final itemsList = List<MemorizationItem>.from(itemsRes.valueOrNull ?? []);
    final idx = itemsList.indexWhere((i) => i.ayahKey == key);
    final now = clock.nowUtc();

    if (idx != -1) {
      final old = itemsList[idx];
      itemsList[idx] = old.copyWith(
        state: isMemorized ? MemorizationState.mastered : MemorizationState.notStarted,
        masteryScore: isMemorized ? 100.0 : 0.0,
        repetitions: isMemorized ? (old.repetitions + 1) : old.repetitions,
        lastReviewedAt: isMemorized ? now : old.lastReviewedAt,
        updatedAt: now,
      );
    } else {
      itemsList.add(MemorizationItem(
        ayahKey: key,
        state: isMemorized ? MemorizationState.mastered : MemorizationState.notStarted,
        masteryScore: isMemorized ? 100.0 : 0.0,
        repetitions: isMemorized ? 1 : 0,
        lastReviewedAt: isMemorized ? now : null,
        createdAt: now,
        updatedAt: now,
      ));
    }

    final saveRes = await dataStore.saveItems(itemsList);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
    await clearActiveSession();
    return Result.ok(true);
  }

  /// Checks if an Ayah is memorized.
  Future<bool> isAyahMemorized(AyahKey key) async {
    final itemsRes = await dataStore.getItems();
    if (itemsRes.isFailure) return false;
    final item = itemsRes.valueOrNull?.where((i) => i.ayahKey == key).firstOrNull;
    return item != null && item.state == MemorizationState.mastered;
  }

  /// Retrieves list of all Ayahs in the active plan.
  Result<List<Ayah>, Failure> getPlanAyahs(MemorizationPlan plan) {
    final result = <Ayah>[];
    for (final sNum in plan.targetSurahs) {
      final surahAyahsRes = quranStore.getSurahAyahs(sNum);
      if (surahAyahsRes.isSuccess) {
        for (final ayah in surahAyahsRes.valueOrNull!) {
          if (_isBeforeKey(ayah.key, plan.startAyah) || _isAfterKey(ayah.key, plan.endAyah)) {
            continue;
          }
          result.add(ayah);
        }
      }
    }
    return Result.ok(result);
  }

  /// Retrieves summary for each Surah in the active plan with progress stats.
  Future<Result<List<TahfeezSurahSummary>, Failure>> getPlanSurahsSummary(MemorizationPlan plan) async {
    final itemsRes = await dataStore.getItems();
    final memorizedKeys = (itemsRes.valueOrNull ?? [])
        .where((i) => i.state == MemorizationState.mastered)
        .map((i) => i.ayahKey)
        .toSet();

    final summaries = <TahfeezSurahSummary>[];
    for (final sNum in plan.targetSurahs) {
      final surahRes = quranStore.getSurah(sNum);
      final surahAyahsRes = quranStore.getSurahAyahs(sNum);
      if (surahRes.isSuccess && surahAyahsRes.isSuccess) {
        final allAyahs = surahAyahsRes.valueOrNull!;
        final planAyahs = allAyahs.where((a) =>
            !_isBeforeKey(a.key, plan.startAyah) && !_isAfterKey(a.key, plan.endAyah)).toList();

        if (planAyahs.isNotEmpty) {
          final memorizedCount = planAyahs.where((a) => memorizedKeys.contains(a.key)).length;
          final percent = (memorizedCount / planAyahs.length) * 100.0;
          summaries.add(TahfeezSurahSummary(
            surahNumber: sNum,
            surahNameArabic: surahRes.valueOrNull!.nameArabic,
            totalAyahsInPlan: planAyahs.length,
            memorizedAyahsCount: memorizedCount,
            progressPercent: percent,
          ));
        }
      }
    }
    return Result.ok(summaries);
  }

  /// Retrieves today's wird Ayahs for the active plan directly with full text.
  Future<Result<List<Ayah>, Failure>> getTodayWirdAyahs(MemorizationPlan plan) async {
    final allPlanAyahsRes = getPlanAyahs(plan);
    if (allPlanAyahsRes.isFailure) return Result.err(allPlanAyahsRes.failureOrNull!);

    final allPlanAyahs = allPlanAyahsRes.valueOrNull ?? [];
    if (allPlanAyahs.isEmpty) return Result.ok(const []);

    final itemsRes = await dataStore.getItems();
    final memorizedKeys = (itemsRes.valueOrNull ?? [])
        .where((i) => i.state == MemorizationState.mastered)
        .map((i) => i.ayahKey)
        .toSet();

    // 1. Gather unmemorized ayahs up to daily target
    final unmemorized = allPlanAyahs.where((a) => !memorizedKeys.contains(a.key)).take(plan.dailyNewAyahs).toList();
    if (unmemorized.isNotEmpty) {
      return Result.ok(unmemorized);
    }

    // 2. If all are memorized, take the first dailyTarget ayahs for revision
    final revision = allPlanAyahs.take(plan.dailyNewAyahs).toList();
    return Result.ok(revision);
  }

  static bool _isBeforeKey(AyahKey a, AyahKey start) {
    if (a.surahNumber < start.surahNumber) return true;
    if (a.surahNumber == start.surahNumber && a.ayahNumber < start.ayahNumber) return true;
    return false;
  }

  static bool _isAfterKey(AyahKey a, AyahKey end) {
    if (a.surahNumber > end.surahNumber) return true;
    if (a.surahNumber == end.surahNumber && a.ayahNumber > end.ayahNumber) return true;
    return false;
  }
}
