import 'package:equatable/equatable.dart';
import '../../quran/domain/ayah_key.dart';
import 'memorization_state.dart';

/// Immutable domain entity tracking the memorization state and spaced repetition metrics of an Ayah.
class MemorizationItem extends Equatable {
  final AyahKey ayahKey;
  final MemorizationState state;
  final int repetitions;
  final int lapses;
  final double easeFactor;
  final int intervalDays;
  final double masteryScore; // 0.0 to 100.0
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewDue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MemorizationItem({
    required this.ayahKey,
    this.state = MemorizationState.notStarted,
    this.repetitions = 0,
    this.lapses = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 0,
    this.masteryScore = 0.0,
    this.lastReviewedAt,
    this.nextReviewDue,
    required this.createdAt,
    required this.updatedAt,
  })  : assert(easeFactor >= 1.3, 'Ease factor cannot drop below 1.3'),
        assert(intervalDays >= 0, 'Interval days cannot be negative'),
        assert(masteryScore >= 0.0 && masteryScore <= 100.0, 'Mastery score must be 0..100');

  int get surahNumber => ayahKey.surahNumber;
  int get ayahNumber => ayahKey.ayahNumber;

  /// Returns true if this item is due for review on or before [currentDate].
  bool isDue(DateTime currentDate) {
    if (state == MemorizationState.notStarted) return false;
    if (nextReviewDue == null) return true;
    final dueMidnight = DateTime.utc(nextReviewDue!.year, nextReviewDue!.month, nextReviewDue!.day);
    final currentMidnight = DateTime.utc(currentDate.year, currentDate.month, currentDate.day);
    return dueMidnight.isBefore(currentMidnight) || dueMidnight.isAtSameMomentAs(currentMidnight);
  }

  MemorizationItem copyWith({
    MemorizationState? state,
    int? repetitions,
    int? lapses,
    double? easeFactor,
    int? intervalDays,
    double? masteryScore,
    DateTime? lastReviewedAt,
    DateTime? nextReviewDue,
    DateTime? updatedAt,
  }) {
    return MemorizationItem(
      ayahKey: ayahKey,
      state: state ?? this.state,
      repetitions: repetitions ?? this.repetitions,
      lapses: lapses ?? this.lapses,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      masteryScore: (masteryScore ?? this.masteryScore).clamp(0.0, 100.0),
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewDue: nextReviewDue ?? this.nextReviewDue,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory MemorizationItem.fromMap(Map<String, dynamic> map) {
    final rawEase = (map['ease_factor'] as num?)?.toDouble() ?? 2.5;
    final rawInterval = map['interval_days'] as int? ?? 0;
    final rawScore = (map['mastery_score'] as num?)?.toDouble() ?? 0.0;

    return MemorizationItem(
      ayahKey: AyahKey.parse(map['ayah_key'] as String),
      state: MemorizationState.values.firstWhere(
        (s) => s.name == map['state'],
        orElse: () => MemorizationState.notStarted,
      ),
      repetitions: map['repetitions'] as int? ?? 0,
      lapses: map['lapses'] as int? ?? 0,
      easeFactor: rawEase < 1.3 ? 1.3 : (rawEase > 2.5 ? 2.5 : rawEase),
      intervalDays: rawInterval < 0 ? 0 : rawInterval,
      masteryScore: rawScore.clamp(0.0, 100.0),
      lastReviewedAt: map['last_reviewed_at'] != null ? DateTime.parse(map['last_reviewed_at'] as String) : null,
      nextReviewDue: map['next_review_due'] != null ? DateTime.parse(map['next_review_due'] as String) : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ayah_key': ayahKey.toString(),
      'state': state.name,
      'repetitions': repetitions,
      'lapses': lapses,
      'ease_factor': easeFactor,
      'interval_days': intervalDays,
      'mastery_score': masteryScore,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt!.toIso8601String(),
      if (nextReviewDue != null) 'next_review_due': nextReviewDue!.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        ayahKey,
        state,
        repetitions,
        lapses,
        easeFactor,
        intervalDays,
        masteryScore,
        lastReviewedAt,
        nextReviewDue,
        createdAt,
        updatedAt,
      ];
}
