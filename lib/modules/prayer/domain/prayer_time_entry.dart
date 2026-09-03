import 'package:equatable/equatable.dart';
import 'prayer_type.dart';

/// Single prayer or solar transition time entry within a daily schedule.
class PrayerTimeEntry extends Equatable {
  final PrayerType type;
  final DateTime time;
  final DateTime originalTime;
  final int adjustmentMinutes;

  const PrayerTimeEntry({
    required this.type,
    required this.time,
    required this.originalTime,
    this.adjustmentMinutes = 0,
  });

  bool get isAdjusted => adjustmentMinutes != 0;

  @override
  List<Object?> get props => [type, time, originalTime, adjustmentMinutes];

  @override
  String toString() => '${type.nameEnglish}: $time ${isAdjusted ? "($adjustmentMinutes min adjusted)" : ""}';
}
