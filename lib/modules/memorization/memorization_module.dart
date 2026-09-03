import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/storage/storage_contract.dart';
import '../../core/time/clock.dart';
import '../quran/domain/ayah_key.dart';
import '../quran/store/canonical_quran_store.dart';
import 'domain/mastery_snapshot.dart';
import 'domain/memorization_item.dart';
import 'domain/memorization_plan.dart';
import 'domain/memorization_state.dart';
import 'domain/mistake_record.dart';
import 'domain/review_quality.dart';
import 'domain/review_session.dart';
import 'scheduler/review_scheduler_strategy.dart';
import 'scheduler/spaced_repetition_scheduler.dart';
import 'services/daily_session_engine.dart';
import 'services/memorization_progress_service.dart';
import 'store/memorization_user_data_store.dart';

/// Unified Module Facade for the Quran Memorization Subsystem (L2).
/// Encapsulates storage, scheduling, session workflows, and mastery tracking.
class MemorizationModule {
  final MemorizationUserDataStore dataStore;
  final ReviewSchedulerStrategy scheduler;
  final DailySessionEngine sessionEngine;
  final MemorizationProgressService progressService;
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

  /// Executes safe reset of all user memorization data (§27).
  Future<Result<bool, Failure>> resetAllData() => dataStore.resetAllData();
}
