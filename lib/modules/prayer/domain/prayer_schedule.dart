import 'package:equatable/equatable.dart';
import '../../../core/location/location_models.dart';
import 'calculation_status.dart';
import 'methodology_disclosure.dart';
import 'prayer_time_entry.dart';
import 'prayer_type.dart';

/// Full day prayer schedule with complete provenance and status.
class PrayerSchedule extends Equatable {
  final DateTime date;
  final GeoCoordinates location;
  final Map<PrayerType, PrayerTimeEntry> entries;
  final MethodologyDisclosure disclosure;
  final CalculationStatus status;

  const PrayerSchedule({
    required this.date,
    required this.location,
    required this.entries,
    required this.disclosure,
    this.status = CalculationStatus.normal,
  });

  PrayerTimeEntry? get fajr => entries[PrayerType.fajr];
  PrayerTimeEntry? get sunrise => entries[PrayerType.sunrise];
  PrayerTimeEntry? get dhuhr => entries[PrayerType.dhuhr];
  PrayerTimeEntry? get asr => entries[PrayerType.asr];
  PrayerTimeEntry? get sunset => entries[PrayerType.sunset];
  PrayerTimeEntry? get maghrib => entries[PrayerType.maghrib];
  PrayerTimeEntry? get isha => entries[PrayerType.isha];
  PrayerTimeEntry? get midnight => entries[PrayerType.midnight];
  PrayerTimeEntry? get lastThirdOfNight => entries[PrayerType.lastThirdOfNight];

  PrayerTimeEntry? forType(PrayerType type) => entries[type];

  /// List of the 5 primary obligatory prayer entries ordered chronologically.
  List<PrayerTimeEntry> get obligatoryPrayers => [
        ?fajr,
        ?dhuhr,
        ?asr,
        ?maghrib,
        ?isha,
      ];

  /// List of all standard daily transitions (Fajr, Sunrise, Dhuhr, Asr, Maghrib, Isha).
  List<PrayerTimeEntry> get dailyScheduleList => [
        ?fajr,
        ?sunrise,
        ?dhuhr,
        ?asr,
        ?maghrib,
        ?isha,
      ];

  @override
  List<Object?> get props => [date, location, entries, disclosure, status];
}
