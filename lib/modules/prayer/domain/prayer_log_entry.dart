import 'package:equatable/equatable.dart';
import 'prayer_tracking_status.dart';
import 'prayer_type.dart';

/// Represents a single logged prayer event for a given day.
/// Strictly local-first entity persisted in `mod_prayer` (§14, §15).
class PrayerLogEntry extends Equatable {
  final DateTime date; // YYYY-MM-DD
  final PrayerType prayerType;
  final PrayerTrackingStatus status;
  final DateTime recordedAtUtc;
  final String? notes;

  const PrayerLogEntry({
    required this.date,
    required this.prayerType,
    required this.status,
    required this.recordedAtUtc,
    this.notes,
  });

  String get dateKey => '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Map<String, dynamic> toMap() => {
        'date': dateKey,
        'prayerType': prayerType.name,
        'status': status.name,
        'recordedAtUtc': recordedAtUtc.toIso8601String(),
        'notes': notes,
      };

  factory PrayerLogEntry.fromMap(Map<String, dynamic> map) {
    return PrayerLogEntry(
      date: DateTime.parse(map['date'] as String),
      prayerType: PrayerType.values.byName(map['prayerType'] as String),
      status: PrayerTrackingStatus.values.byName(map['status'] as String),
      recordedAtUtc: DateTime.parse(map['recordedAtUtc'] as String),
      notes: map['notes'] as String?,
    );
  }

  PrayerLogEntry copyWith({
    PrayerTrackingStatus? status,
    DateTime? recordedAtUtc,
    String? notes,
  }) {
    return PrayerLogEntry(
      date: date,
      prayerType: prayerType,
      status: status ?? this.status,
      recordedAtUtc: recordedAtUtc ?? this.recordedAtUtc,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [date, prayerType, status, recordedAtUtc, notes];
}
