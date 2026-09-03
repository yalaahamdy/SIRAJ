import 'package:equatable/equatable.dart';

/// User habit for daily routine and reading consistency without religious judgment (§16, §17).
class PersonalHabit extends Equatable {
  final String habitId;
  final String titleArabic;
  final String description;
  final String targetFrequency; // e.g. 'daily', 'weekdays', 'mondays_thursdays'
  final int currentStreakDays;
  final int bestStreakDays;
  final DateTime? lastCompletedDate;
  final bool isArchived;

  const PersonalHabit({
    required this.habitId,
    required this.titleArabic,
    required this.description,
    this.targetFrequency = 'daily',
    this.currentStreakDays = 0,
    this.bestStreakDays = 0,
    this.lastCompletedDate,
    this.isArchived = false,
  });

  PersonalHabit markCompletedToday(DateTime today) {
    final isConsecutive = lastCompletedDate != null &&
        today.difference(lastCompletedDate!).inDays == 1;
    final newStreak = isConsecutive ? currentStreakDays + 1 : 1;
    final newBest = newStreak > bestStreakDays ? newStreak : bestStreakDays;

    return PersonalHabit(
      habitId: habitId,
      titleArabic: titleArabic,
      description: description,
      targetFrequency: targetFrequency,
      currentStreakDays: newStreak,
      bestStreakDays: newBest,
      lastCompletedDate: today,
      isArchived: isArchived,
    );
  }

  factory PersonalHabit.fromJson(Map<String, dynamic> json) {
    return PersonalHabit(
      habitId: json['habit_id'] as String,
      titleArabic: json['title_arabic'] as String,
      description: json['description'] as String? ?? '',
      targetFrequency: json['target_frequency'] as String? ?? 'daily',
      currentStreakDays: json['current_streak_days'] as int? ?? 0,
      bestStreakDays: json['best_streak_days'] as int? ?? 0,
      lastCompletedDate: json['last_completed_date'] != null
          ? DateTime.parse(json['last_completed_date'] as String)
          : null,
      isArchived: json['is_archived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habit_id': habitId,
      'title_arabic': titleArabic,
      'description': description,
      'target_frequency': targetFrequency,
      'current_streak_days': currentStreakDays,
      'best_streak_days': bestStreakDays,
      if (lastCompletedDate != null)
        'last_completed_date': lastCompletedDate!.toIso8601String(),
      'is_archived': isArchived,
    };
  }

  @override
  List<Object?> get props => [
        habitId,
        titleArabic,
        description,
        targetFrequency,
        currentStreakDays,
        bestStreakDays,
        lastCompletedDate,
        isArchived,
      ];
}
