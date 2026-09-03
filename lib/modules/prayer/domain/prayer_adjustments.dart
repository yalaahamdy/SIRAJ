import 'package:equatable/equatable.dart';
import 'prayer_type.dart';

/// User or local administrative minute adjustments for prayer times.
/// Enforces safe boundaries (-60 to +60 minutes) to prevent silent tampering (§18).
class PrayerAdjustments extends Equatable {
  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;

  const PrayerAdjustments({
    this.fajr = 0,
    this.sunrise = 0,
    this.dhuhr = 0,
    this.asr = 0,
    this.maghrib = 0,
    this.isha = 0,
  })  : assert(fajr >= -60 && fajr <= 60, 'Fajr adjustment must be between -60 and +60'),
        assert(sunrise >= -60 && sunrise <= 60, 'Sunrise adjustment must be between -60 and +60'),
        assert(dhuhr >= -60 && dhuhr <= 60, 'Dhuhr adjustment must be between -60 and +60'),
        assert(asr >= -60 && asr <= 60, 'Asr adjustment must be between -60 and +60'),
        assert(maghrib >= -60 && maghrib <= 60, 'Maghrib adjustment must be between -60 and +60'),
        assert(isha >= -60 && isha <= 60, 'Isha adjustment must be between -60 and +60');

  static const PrayerAdjustments zero = PrayerAdjustments();

  bool get hasAnyAdjustment =>
      fajr != 0 || sunrise != 0 || dhuhr != 0 || asr != 0 || maghrib != 0 || isha != 0;

  int getFor(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return fajr;
      case PrayerType.sunrise:
        return sunrise;
      case PrayerType.dhuhr:
        return dhuhr;
      case PrayerType.asr:
        return asr;
      case PrayerType.maghrib:
        return maghrib;
      case PrayerType.isha:
        return isha;
      default:
        return 0;
    }
  }

  Map<String, int> toMap() => {
        'fajr': fajr,
        'sunrise': sunrise,
        'dhuhr': dhuhr,
        'asr': asr,
        'maghrib': maghrib,
        'isha': isha,
      };

  factory PrayerAdjustments.fromMap(Map<String, dynamic> map) {
    return PrayerAdjustments(
      fajr: (map['fajr'] as num?)?.toInt() ?? 0,
      sunrise: (map['sunrise'] as num?)?.toInt() ?? 0,
      dhuhr: (map['dhuhr'] as num?)?.toInt() ?? 0,
      asr: (map['asr'] as num?)?.toInt() ?? 0,
      maghrib: (map['maghrib'] as num?)?.toInt() ?? 0,
      isha: (map['isha'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [fajr, sunrise, dhuhr, asr, maghrib, isha];
}
