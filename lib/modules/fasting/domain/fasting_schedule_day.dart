import 'package:equatable/equatable.dart';
import 'hijri_date.dart';

/// Immutable model representing the computed fasting and timing schedule for a day (§4, §10, §11).
class FastingScheduleDay extends Equatable {
  final DateTime date;
  final HijriDate hijriDate;
  final bool isRamadan;
  final int? ramadanDayNumber;
  final DateTime suhoorImsakTime;
  final DateTime fastStartTime;
  final DateTime fastEndTime;
  final Duration fastingDuration;
  final bool isCurrentlyFasting;
  final String nextBoundaryLabel;
  final DateTime nextBoundaryTime;
  final Duration remainingToNextBoundary;

  const FastingScheduleDay({
    required this.date,
    required this.hijriDate,
    required this.isRamadan,
    this.ramadanDayNumber,
    required this.suhoorImsakTime,
    required this.fastStartTime,
    required this.fastEndTime,
    required this.fastingDuration,
    required this.isCurrentlyFasting,
    required this.nextBoundaryLabel,
    required this.nextBoundaryTime,
    required this.remainingToNextBoundary,
  });

  @override
  List<Object?> get props => [
        date,
        hijriDate,
        isRamadan,
        ramadanDayNumber,
        suhoorImsakTime,
        fastStartTime,
        fastEndTime,
        fastingDuration,
        isCurrentlyFasting,
        nextBoundaryLabel,
        nextBoundaryTime,
        remainingToNextBoundary,
      ];
}
