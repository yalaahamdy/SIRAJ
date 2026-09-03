import 'package:equatable/equatable.dart';
import '../../quran/domain/ayah_key.dart';
import 'mistake_record.dart';
import 'review_quality.dart';

/// Recorded outcome of a single Ayah recall review attempt.
class ReviewResult extends Equatable {
  final AyahKey ayahKey;
  final ReviewQuality quality;
  final int scheduledIntervalDays;
  final int timeTakenMs;
  final MistakeRecord? mistake;
  final DateTime reviewedAt;

  const ReviewResult({
    required this.ayahKey,
    required this.quality,
    required this.scheduledIntervalDays,
    this.timeTakenMs = 0,
    this.mistake,
    required this.reviewedAt,
  });

  bool get isSuccessful => quality != ReviewQuality.again;

  factory ReviewResult.fromMap(Map<String, dynamic> map) {
    return ReviewResult(
      ayahKey: AyahKey.parse(map['ayah_key'] as String),
      quality: ReviewQuality.values.firstWhere(
        (q) => q.name == map['quality'],
        orElse: () => ReviewQuality.good,
      ),
      scheduledIntervalDays: map['scheduled_interval_days'] as int? ?? 1,
      timeTakenMs: map['time_taken_ms'] as int? ?? 0,
      mistake: map['mistake'] != null ? MistakeRecord.fromMap(map['mistake'] as Map<String, dynamic>) : null,
      reviewedAt: DateTime.parse(map['reviewed_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ayah_key': ayahKey.toString(),
      'quality': quality.name,
      'scheduled_interval_days': scheduledIntervalDays,
      'time_taken_ms': timeTakenMs,
      if (mistake != null) 'mistake': mistake!.toMap(),
      'reviewed_at': reviewedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        ayahKey,
        quality,
        scheduledIntervalDays,
        timeTakenMs,
        mistake,
        reviewedAt,
      ];
}
