import 'package:equatable/equatable.dart';

/// Base class for all domain events in SIRAJ.
/// Strictly follows naming convention: `<module>.<domain>.<action>`.
abstract class AppEvent extends Equatable {
  final String eventName;
  final DateTime timestamp;

  AppEvent({
    required this.eventName,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().toUtc();

  @override
  List<Object?> get props => [eventName, timestamp];

  @override
  String toString() => '$eventName at $timestamp';
}

// ---------------------------------------------------------------------------
// L0 Core Events
// ---------------------------------------------------------------------------

class DayChangedEvent extends AppEvent {
  final DateTime newDay;

  DayChangedEvent(this.newDay) : super(eventName: 'core.time.dayChanged');

  @override
  List<Object?> get props => [...super.props, newDay];
}

class TimezoneChangedEvent extends AppEvent {
  final String newTimezone;

  TimezoneChangedEvent(this.newTimezone) : super(eventName: 'core.time.timezoneChanged');

  @override
  List<Object?> get props => [...super.props, newTimezone];
}

// ---------------------------------------------------------------------------
// L1 Content Events
// ---------------------------------------------------------------------------

class PackageInstalledEvent extends AppEvent {
  final String packageId;
  final String version;

  PackageInstalledEvent({required this.packageId, required this.version})
      : super(eventName: 'content.package.installed');

  @override
  List<Object?> get props => [...super.props, packageId, version];
}

class PackageUpdatedEvent extends AppEvent {
  final String packageId;
  final String previousVersion;
  final String newVersion;

  PackageUpdatedEvent({
    required this.packageId,
    required this.previousVersion,
    required this.newVersion,
  }) : super(eventName: 'content.package.updated');

  @override
  List<Object?> get props => [...super.props, packageId, previousVersion, newVersion];
}

class PackageRejectedEvent extends AppEvent {
  final String packageId;
  final String reason;
  final String? version;

  PackageRejectedEvent({
    required this.packageId,
    required this.reason,
    this.version,
  }) : super(eventName: 'content.package.rejected');

  @override
  List<Object?> get props => [...super.props, packageId, reason, version];
}

// ---------------------------------------------------------------------------
// L2 Prayer Events
// ---------------------------------------------------------------------------

class PrayerTimeUpdatedEvent extends AppEvent {
  final DateTime date;
  final String calculationMethod;

  PrayerTimeUpdatedEvent({
    required this.date,
    required this.calculationMethod,
  }) : super(eventName: 'prayer.time.updated');

  @override
  List<Object?> get props => [...super.props, date, calculationMethod];
}

class PrayerTimeEnteredEvent extends AppEvent {
  final String prayerName;
  final DateTime time;

  PrayerTimeEnteredEvent({
    required this.prayerName,
    required this.time,
  }) : super(eventName: 'prayer.time.entered');

  @override
  List<Object?> get props => [...super.props, prayerName, time];
}

class PrayerLoggedEvent extends AppEvent {
  final String prayerName;
  final DateTime date;
  final String status;

  PrayerLoggedEvent({
    required this.prayerName,
    required this.date,
    required this.status,
  }) : super(eventName: 'prayer.logged');

  @override
  List<Object?> get props => [...super.props, prayerName, date, status];
}
