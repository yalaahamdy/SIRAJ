import 'package:equatable/equatable.dart';

/// Immutable model representing user's Qada fasting plan (§4, §15, §16).
class QadaPlan extends Equatable {
  final int totalDays;
  final int completedDays;
  final DateTime? targetDate;
  final List<int> preferredWeekdays; // 1 = Monday, 4 = Thursday, etc.
  final DateTime updatedAt;

  const QadaPlan({
    required this.totalDays,
    this.completedDays = 0,
    this.targetDate,
    this.preferredWeekdays = const [1, 4], // Monday and Thursday by default
    required this.updatedAt,
  })  : assert(totalDays >= 0, 'Total Qada days cannot be negative'),
        assert(completedDays >= 0, 'Completed Qada days cannot be negative');

  int get remainingDays => (totalDays - completedDays).clamp(0, totalDays);
  bool get isCompleted => remainingDays == 0 && totalDays > 0;
  double get progressRatio => totalDays == 0 ? 1.0 : (completedDays / totalDays).clamp(0.0, 1.0);

  QadaPlan copyWith({
    int? totalDays,
    int? completedDays,
    DateTime? targetDate,
    List<int>? preferredWeekdays,
    DateTime? updatedAt,
  }) {
    return QadaPlan(
      totalDays: totalDays ?? this.totalDays,
      completedDays: completedDays ?? this.completedDays,
      targetDate: targetDate ?? this.targetDate,
      preferredWeekdays: preferredWeekdays ?? this.preferredWeekdays,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory QadaPlan.fromMap(Map<String, dynamic> map) {
    return QadaPlan(
      totalDays: map['total_days'] as int? ?? 0,
      completedDays: map['completed_days'] as int? ?? 0,
      targetDate: map['target_date'] != null ? DateTime.parse(map['target_date'] as String) : null,
      preferredWeekdays: (map['preferred_weekdays'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          const [1, 4],
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total_days': totalDays,
      'completed_days': completedDays,
      if (targetDate != null) 'target_date': targetDate!.toIso8601String(),
      'preferred_weekdays': preferredWeekdays,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        totalDays,
        completedDays,
        targetDate,
        preferredWeekdays,
        updatedAt,
      ];
}
