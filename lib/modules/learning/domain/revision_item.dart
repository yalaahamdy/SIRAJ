import 'package:equatable/equatable.dart';

/// Target type for decoupled spaced revision (§22, §23).
enum RevisionTargetType {
  lesson('درس تعليمي'),
  topic('مسألة معرفية'),
  quiz('اختبار استيعاب'),
  evidence('دليل شرعي');

  final String labelArabic;
  const RevisionTargetType(this.labelArabic);
}

/// Decoupled spaced revision item model for learning retention (§22, §23).
class RevisionItem extends Equatable {
  final String itemId;
  final RevisionTargetType targetType;
  final String targetId;
  final DateTime dueAt;
  final int intervalDays;
  final double easeFactor;
  final int repetitionCount;
  final int? lastQuality;

  const RevisionItem({
    required this.itemId,
    required this.targetType,
    required this.targetId,
    required this.dueAt,
    this.intervalDays = 1,
    this.easeFactor = 2.5,
    this.repetitionCount = 0,
    this.lastQuality,
  });

  RevisionItem copyWith({
    String? itemId,
    RevisionTargetType? targetType,
    String? targetId,
    DateTime? dueAt,
    int? intervalDays,
    double? easeFactor,
    int? repetitionCount,
    int? lastQuality,
  }) {
    return RevisionItem(
      itemId: itemId ?? this.itemId,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      dueAt: dueAt ?? this.dueAt,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      repetitionCount: repetitionCount ?? this.repetitionCount,
      lastQuality: lastQuality ?? this.lastQuality,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_id': itemId,
      'target_type': targetType.name,
      'target_id': targetId,
      'due_at': dueAt.toIso8601String(),
      'interval_days': intervalDays,
      'ease_factor': easeFactor,
      'repetition_count': repetitionCount,
      'last_quality': lastQuality,
    };
  }

  factory RevisionItem.fromMap(Map<String, dynamic> map) {
    return RevisionItem(
      itemId: map['item_id'] as String,
      targetType: RevisionTargetType.values.byName(map['target_type'] as String),
      targetId: map['target_id'] as String,
      dueAt: DateTime.parse(map['due_at'] as String),
      intervalDays: map['interval_days'] as int? ?? 1,
      easeFactor: (map['ease_factor'] as num?)?.toDouble() ?? 2.5,
      repetitionCount: map['repetition_count'] as int? ?? 0,
      lastQuality: map['last_quality'] as int?,
    );
  }

  @override
  List<Object?> get props => [
        itemId,
        targetType,
        targetId,
        dueAt,
        intervalDays,
        easeFactor,
        repetitionCount,
        lastQuality,
      ];
}
