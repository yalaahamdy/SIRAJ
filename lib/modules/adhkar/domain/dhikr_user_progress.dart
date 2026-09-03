import 'package:equatable/equatable.dart';

/// User progress record for a single Dhikr item (§19). Local-first only.
class DhikrUserProgress extends Equatable {
  final String contentId;
  final int currentCount;
  final int targetCount;
  final bool isCompleted;
  final String dateKey; // YYYY-MM-DD
  final DateTime updatedAt;

  const DhikrUserProgress({
    required this.contentId,
    required this.currentCount,
    required this.targetCount,
    required this.isCompleted,
    required this.dateKey,
    required this.updatedAt,
  });

  DhikrUserProgress copyWith({
    int? currentCount,
    int? targetCount,
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    final nextCount = currentCount ?? this.currentCount;
    final nextTarget = targetCount ?? this.targetCount;
    return DhikrUserProgress(
      contentId: contentId,
      currentCount: nextCount,
      targetCount: nextTarget,
      isCompleted: isCompleted ?? (nextCount >= nextTarget),
      dateKey: dateKey,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory DhikrUserProgress.fromMap(Map<String, dynamic> map) {
    return DhikrUserProgress(
      contentId: map['content_id'] as String,
      currentCount: map['current_count'] as int? ?? 0,
      targetCount: map['target_count'] as int? ?? 1,
      isCompleted: map['is_completed'] as bool? ?? false,
      dateKey: map['date_key'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content_id': contentId,
      'current_count': currentCount,
      'target_count': targetCount,
      'is_completed': isCompleted,
      'date_key': dateKey,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [contentId, currentCount, targetCount, isCompleted, dateKey, updatedAt];
}
