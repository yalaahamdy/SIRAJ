import 'package:equatable/equatable.dart';

/// Categories of personal Islamic life goals (§12, §13).
enum GoalType {
  quranReading,
  memorization,
  adhkarConsistency,
  fasting,
  learning,
  zakatPreparation,
  hajjPreparation,
  custom;

  String get labelArabic {
    switch (this) {
      case GoalType.quranReading:
        return 'تلاوة القرآن';
      case GoalType.memorization:
        return 'حفظ القرآن ومراجعته';
      case GoalType.adhkarConsistency:
        return 'المحافظة على الأذكار';
      case GoalType.fasting:
        return 'الصيام';
      case GoalType.learning:
        return 'التعلم والتفقه';
      case GoalType.zakatPreparation:
        return 'الاستعداد للزكاة';
      case GoalType.hajjPreparation:
        return 'استعداد الحج والعمرة';
      case GoalType.custom:
        return 'هدف مخصص';
    }
  }
}

/// Lifecycle state of a personal goal (§14).
enum GoalStatus {
  active,
  paused,
  completed,
  archived;

  String get labelArabic {
    switch (this) {
      case GoalStatus.active:
        return 'نشط';
      case GoalStatus.paused:
        return 'متوقف مؤقتاً';
      case GoalStatus.completed:
        return 'مكتمل';
      case GoalStatus.archived:
        return 'مؤرشف';
    }
  }
}

/// Immutable User-Defined Personal Goal (§12, §13).
class PersonalGoal extends Equatable {
  final String goalId;
  final GoalType type;
  final String title;
  final double target;
  final double currentProgress;
  final String unitArabic;
  final DateTime startDate;
  final DateTime? targetDate;
  final GoalStatus status;
  final String sourceModule;
  final String? notes;

  const PersonalGoal({
    required this.goalId,
    required this.type,
    required this.title,
    required this.target,
    this.currentProgress = 0.0,
    required this.unitArabic,
    required this.startDate,
    this.targetDate,
    this.status = GoalStatus.active,
    required this.sourceModule,
    this.notes,
  }) : assert(target > 0, 'Target must be strictly positive');

  double get progressPercentage =>
      target > 0 ? (currentProgress / target * 100.0).clamp(0.0, 100.0) : 0.0;

  bool get isDone => currentProgress >= target;

  PersonalGoal copyWith({
    String? goalId,
    GoalType? type,
    String? title,
    double? target,
    double? currentProgress,
    String? unitArabic,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
    String? sourceModule,
    String? notes,
  }) {
    return PersonalGoal(
      goalId: goalId ?? this.goalId,
      type: type ?? this.type,
      title: title ?? this.title,
      target: target ?? this.target,
      currentProgress: currentProgress ?? this.currentProgress,
      unitArabic: unitArabic ?? this.unitArabic,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      sourceModule: sourceModule ?? this.sourceModule,
      notes: notes ?? this.notes,
    );
  }

  factory PersonalGoal.fromJson(Map<String, dynamic> json) {
    return PersonalGoal(
      goalId: json['goal_id'] as String,
      type: GoalType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GoalType.custom,
      ),
      title: json['title'] as String,
      target: (json['target'] as num).toDouble(),
      currentProgress: (json['current_progress'] as num?)?.toDouble() ?? 0.0,
      unitArabic: json['unit_arabic'] as String? ?? 'وحدة',
      startDate: DateTime.parse(json['start_date'] as String),
      targetDate: json['target_date'] != null
          ? DateTime.parse(json['target_date'] as String)
          : null,
      status: GoalStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => GoalStatus.active,
      ),
      sourceModule: json['source_module'] as String? ?? 'mod_companion',
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal_id': goalId,
      'type': type.name,
      'title': title,
      'target': target,
      'current_progress': currentProgress,
      'unit_arabic': unitArabic,
      'start_date': startDate.toIso8601String(),
      if (targetDate != null) 'target_date': targetDate!.toIso8601String(),
      'status': status.name,
      'source_module': sourceModule,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        goalId,
        type,
        title,
        target,
        currentProgress,
        unitArabic,
        startDate,
        targetDate,
        status,
        sourceModule,
        notes,
      ];
}
