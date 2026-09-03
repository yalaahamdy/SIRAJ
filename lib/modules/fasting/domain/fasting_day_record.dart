import 'package:equatable/equatable.dart';
import 'fasting_status.dart';
import 'fasting_type.dart';
import 'hijri_date.dart';

/// Immutable record of a single fasting day tracked by the user (§4, §14).
class FastingDayRecord extends Equatable {
  final String recordId;
  final DateTime date;
  final HijriDate hijriDate;
  final FastingType type;
  final FastingStatus status;
  final DateTime? fastStartTime;
  final DateTime? fastEndTime;
  final String? note;
  final DateTime createdAt;

  const FastingDayRecord({
    required this.recordId,
    required this.date,
    required this.hijriDate,
    required this.type,
    required this.status,
    this.fastStartTime,
    this.fastEndTime,
    this.note,
    required this.createdAt,
  });

  FastingDayRecord copyWith({
    FastingStatus? status,
    FastingType? type,
    DateTime? fastStartTime,
    DateTime? fastEndTime,
    String? note,
  }) {
    return FastingDayRecord(
      recordId: recordId,
      date: date,
      hijriDate: hijriDate,
      type: type ?? this.type,
      status: status ?? this.status,
      fastStartTime: fastStartTime ?? this.fastStartTime,
      fastEndTime: fastEndTime ?? this.fastEndTime,
      note: note ?? this.note,
      createdAt: createdAt,
    );
  }

  factory FastingDayRecord.fromMap(Map<String, dynamic> map) {
    return FastingDayRecord(
      recordId: map['record_id'] as String,
      date: DateTime.parse(map['date'] as String),
      hijriDate: HijriDate.fromMap(map['hijri_date'] as Map<String, dynamic>),
      type: FastingType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => FastingType.ramadan,
      ),
      status: FastingStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => FastingStatus.fasted,
      ),
      fastStartTime: map['fast_start_time'] != null
          ? DateTime.parse(map['fast_start_time'] as String)
          : null,
      fastEndTime: map['fast_end_time'] != null
          ? DateTime.parse(map['fast_end_time'] as String)
          : null,
      note: map['note'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'record_id': recordId,
      'date': date.toIso8601String(),
      'hijri_date': hijriDate.toMap(),
      'type': type.name,
      'status': status.name,
      if (fastStartTime != null) 'fast_start_time': fastStartTime!.toIso8601String(),
      if (fastEndTime != null) 'fast_end_time': fastEndTime!.toIso8601String(),
      if (note != null) 'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        recordId,
        date,
        hijriDate,
        type,
        status,
        fastStartTime,
        fastEndTime,
        note,
        createdAt,
      ];
}
