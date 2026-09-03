import 'package:equatable/equatable.dart';
import '../../quran/domain/ayah_key.dart';
import 'review_result.dart';

/// Representation of a daily study session with scheduled batches and results.
class ReviewSession extends Equatable {
  final String id;
  final DateTime date;
  final List<AyahKey> newAyahs;
  final List<AyahKey> reviewAyahs;
  final List<AyahKey> weakAyahs;
  final List<ReviewResult> results;
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;

  const ReviewSession({
    required this.id,
    required this.date,
    this.newAyahs = const [],
    this.reviewAyahs = const [],
    this.weakAyahs = const [],
    this.results = const [],
    this.isCompleted = false,
    required this.startedAt,
    this.completedAt,
  });

  int get totalItemsCount => (newAyahs.length + reviewAyahs.length + weakAyahs.length);
  int get completedCount => results.length;
  double get completionRatio => totalItemsCount > 0 ? (completedCount / totalItemsCount).clamp(0.0, 1.0) : 0.0;

  ReviewSession copyWith({
    List<AyahKey>? newAyahs,
    List<AyahKey>? reviewAyahs,
    List<AyahKey>? weakAyahs,
    List<ReviewResult>? results,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return ReviewSession(
      id: id,
      date: date,
      newAyahs: newAyahs ?? this.newAyahs,
      reviewAyahs: reviewAyahs ?? this.reviewAyahs,
      weakAyahs: weakAyahs ?? this.weakAyahs,
      results: results ?? this.results,
      isCompleted: isCompleted ?? this.isCompleted,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  factory ReviewSession.fromMap(Map<String, dynamic> map) {
    final rawNew = map['new_ayahs'] as List<dynamic>? ?? [];
    final rawRev = map['review_ayahs'] as List<dynamic>? ?? [];
    final rawWeak = map['weak_ayahs'] as List<dynamic>? ?? [];
    final rawResults = map['results'] as List<dynamic>? ?? [];

    return ReviewSession(
      id: map['id'] as String,
      date: DateTime.parse(map['date'] as String),
      newAyahs: rawNew.map((e) => AyahKey.parse(e as String)).toList(),
      reviewAyahs: rawRev.map((e) => AyahKey.parse(e as String)).toList(),
      weakAyahs: rawWeak.map((e) => AyahKey.parse(e as String)).toList(),
      results: rawResults.map((e) => ReviewResult.fromMap(e as Map<String, dynamic>)).toList(),
      isCompleted: map['is_completed'] as bool? ?? false,
      startedAt: DateTime.parse(map['started_at'] as String),
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'new_ayahs': newAyahs.map((k) => k.toString()).toList(),
      'review_ayahs': reviewAyahs.map((k) => k.toString()).toList(),
      'weak_ayahs': weakAyahs.map((k) => k.toString()).toList(),
      'results': results.map((r) => r.toMap()).toList(),
      'is_completed': isCompleted,
      'started_at': startedAt.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        date,
        newAyahs,
        reviewAyahs,
        weakAyahs,
        results,
        isCompleted,
        startedAt,
        completedAt,
      ];
}
