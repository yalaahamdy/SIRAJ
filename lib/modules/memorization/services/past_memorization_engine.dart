import 'dart:math';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/time/clock.dart';
import '../../quran/domain/ayah.dart';
import '../../quran/domain/ayah_key.dart';
import '../../quran/store/canonical_quran_store.dart';
import '../domain/memorization_item.dart';
import '../domain/memorization_state.dart';
import '../store/memorization_user_data_store.dart';

/// Type of past exam prompt.
enum PastExamQuestionType {
  continuation, // أكمل من قوله تعالى
  surahStart,   // اقرأ من أول سورة كذا
  fullPassage,  // سمّع المقطع التالي
}

/// A specific challenge question generated for past memorization testing.
class PastExamQuestion {
  final AyahKey startAyahKey;
  final int passageLength;
  final String surahNameArabic;
  final Ayah promptAyah;
  final List<Ayah> expectedAyahs;
  final PastExamQuestionType type;

  const PastExamQuestion({
    required this.startAyahKey,
    required this.passageLength,
    required this.surahNameArabic,
    required this.promptAyah,
    required this.expectedAyahs,
    required this.type,
  });

  AyahKey get endAyahKey => expectedAyahs.isNotEmpty ? expectedAyahs.last.key : startAyahKey;

  String get promptText => promptAyah.textUthmani;
}

/// Statistical summary of past memorization mastery.
class PastMasteryStats {
  final int totalMasteredAyahs;
  final int totalMemorizedAyahs;
  final int totalWeakAyahs;
  final double masteryPercentage; // 0..100
  final int testedCount;

  const PastMasteryStats({
    required this.totalMasteredAyahs,
    required this.totalMemorizedAyahs,
    required this.totalWeakAyahs,
    required this.masteryPercentage,
    required this.testedCount,
  });
}

/// Engine dedicated to testing, affirming, and reinforcing past memorized Quran portions (§38, §50).
class PastMemorizationEngine {
  final MemorizationUserDataStore _store;
  final ReadOnlyCanonicalQuranStore _quranStore;
  final Clock _clock;
  final Random _random;

  PastMemorizationEngine({
    required MemorizationUserDataStore store,
    required ReadOnlyCanonicalQuranStore quranStore,
    Clock? clock,
    Random? random,
  })  : _store = store,
        _quranStore = quranStore,
        _clock = clock ?? const SystemClock(),
        _random = random ?? Random();

  /// Retrieves past mastery statistical metrics.
  Future<Result<PastMasteryStats, Failure>> getPastMasteryStats() async {
    final itemsRes = await _store.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final items = itemsRes.valueOrNull ?? [];
    int mastered = 0;
    int memorized = 0;
    int weak = 0;

    for (final item in items) {
      if (item.state == MemorizationState.mastered) {
        mastered++;
      } else if (item.state == MemorizationState.memorized) {
        memorized++;
      } else if (item.state == MemorizationState.weak) {
        weak++;
      }
    }

    final totalActive = mastered + memorized + weak;
    final pct = totalActive > 0 ? ((mastered * 1.0 + memorized * 0.7) / totalActive) * 100 : 100.0;

    return Result.ok(PastMasteryStats(
      totalMasteredAyahs: mastered,
      totalMemorizedAyahs: memorized,
      totalWeakAyahs: weak,
      masteryPercentage: pct.clamp(0.0, 100.0),
      testedCount: totalActive,
    ));
  }

  /// Generates a random past exam question from previous memorized/learned material.
  Future<Result<PastExamQuestion, Failure>> generatePastExamQuestion({
    int requestedPassageLength = 3,
  }) async {
    final itemsRes = await _store.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final items = itemsRes.valueOrNull ?? [];

    // Eligible items: mastered, memorized, or previously reviewed
    List<MemorizationItem> eligible = items.where((i) =>
        i.state == MemorizationState.mastered ||
        i.state == MemorizationState.memorized ||
        i.repetitions > 0 ||
        i.state == MemorizationState.weak).toList();

    // Fallback: If user has no memorized items yet, pick from common short Surahs (1, 112, 113, 114)
    AyahKey selectedStartKey;
    if (eligible.isEmpty) {
      final fallbackSurahs = [1, 112, 113, 114];
      final surahNum = fallbackSurahs[_random.nextInt(fallbackSurahs.length)];
      selectedStartKey = AyahKey(surahNumber: surahNum, ayahNumber: 1);
    } else {
      final chosen = eligible[_random.nextInt(eligible.length)];
      selectedStartKey = chosen.ayahKey;
    }

    // Fetch surah
    final surahRes = _quranStore.getSurah(selectedStartKey.surahNumber);
    if (surahRes.isFailure) return Result.err(surahRes.failureOrNull!);
    final surah = surahRes.valueOrNull!;

    // Fetch prompt ayah
    final promptAyahRes = _quranStore.getAyah(selectedStartKey.surahNumber, selectedStartKey.ayahNumber);
    if (promptAyahRes.isFailure) return Result.err(promptAyahRes.failureOrNull!);
    final promptAyah = promptAyahRes.valueOrNull!;

    // Fetch expected sequence of ayahs
    final expectedAyahs = <Ayah>[promptAyah];
    final maxAyahs = surah.ayahCount;
    final endAyahNum = min(selectedStartKey.ayahNumber + requestedPassageLength - 1, maxAyahs);

    for (int a = selectedStartKey.ayahNumber + 1; a <= endAyahNum; a++) {
      final nextRes = _quranStore.getAyah(selectedStartKey.surahNumber, a);
      if (nextRes.isSuccess && nextRes.valueOrNull != null) {
        expectedAyahs.add(nextRes.valueOrNull!);
      }
    }

    final type = selectedStartKey.ayahNumber == 1
        ? PastExamQuestionType.surahStart
        : PastExamQuestionType.continuation;

    return Result.ok(PastExamQuestion(
      startAyahKey: selectedStartKey,
      passageLength: expectedAyahs.length,
      surahNameArabic: surah.nameArabic,
      promptAyah: promptAyah,
      expectedAyahs: expectedAyahs,
      type: type,
    ));
  }

  /// Submits the confirmation result for a past exam test.
  /// Updates mastery status and spaced repetition interval accordingly.
  Future<Result<bool, Failure>> submitPastExamResult({
    required PastExamQuestion question,
    required bool isMastered,
  }) async {
    final itemsRes = await _store.getItems();
    if (itemsRes.isFailure) return Result.err(itemsRes.failureOrNull!);

    final items = List<MemorizationItem>.from(itemsRes.valueOrNull ?? []);
    final now = _clock.nowUtc();

    for (final expected in question.expectedAyahs) {
      final idx = items.indexWhere((i) => i.ayahKey == expected.key);
      if (idx >= 0) {
        final current = items[idx];
        final updatedState = isMastered ? MemorizationState.mastered : MemorizationState.weak;
        final nextReview = isMastered
            ? now.add(Duration(days: max(7, current.intervalDays * 2)))
            : now.add(const Duration(days: 1));

        items[idx] = current.copyWith(
          state: updatedState,
          repetitions: current.repetitions + 1,
          intervalDays: isMastered ? max(7, current.intervalDays * 2) : 1,
          nextReviewDue: nextReview,
          lastReviewedAt: now,
          updatedAt: now,
        );
      } else {
        items.add(MemorizationItem(
          ayahKey: expected.key,
          state: isMastered ? MemorizationState.mastered : MemorizationState.weak,
          repetitions: 1,
          intervalDays: isMastered ? 7 : 1,
          nextReviewDue: now.add(Duration(days: isMastered ? 7 : 1)),
          lastReviewedAt: now,
          createdAt: now,
          updatedAt: now,
        ));
      }
    }

    final saveRes = await _store.saveItems(items);
    if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);

    return Result.ok(true);
  }
}
