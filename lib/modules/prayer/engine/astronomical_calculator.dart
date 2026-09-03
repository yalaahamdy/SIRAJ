import 'dart:math' as math;
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/location/location_models.dart';
import '../domain/calculation_parameters.dart';
import '../domain/calculation_status.dart';
import '../domain/methodology_disclosure.dart';
import '../domain/prayer_adjustments.dart';
import '../domain/prayer_schedule.dart';
import '../domain/prayer_time_entry.dart';
import '../domain/prayer_type.dart';
import 'prayer_calculation_engine.dart';

/// Pure, deterministic astronomical calculation engine for Islamic prayer times.
/// Based on standard celestial mechanics equations and spherical solar trigonometry.
class AstronomicalPrayerCalculator implements PrayerCalculationEngine {
  const AstronomicalPrayerCalculator();

  static const double _d2r = math.pi / 180.0;
  static const double _r2d = 180.0 / math.pi;

  @override
  Result<PrayerSchedule, Failure> calculateSchedule({
    required DateTime date,
    required GeoCoordinates location,
    required CalculationParameters parameters,
    Duration? timezoneOffset,
    PrayerAdjustments adjustments = PrayerAdjustments.zero,
  }) {
    // 1. Determine Timezone Offset
    final tzOffset = timezoneOffset ?? (date.isUtc ? Duration.zero : date.timeZoneOffset);
    final tzHours = tzOffset.inMilliseconds / 3600000.0;

    // 2. Validate Coordinate Boundaries
    if (location.latitude.abs() > 90.0 || location.longitude.abs() > 180.0) {
      return Result.err(
        const TimeFailure(
          message: 'Invalid coordinates for prayer calculation',
          code: 'INVALID_COORDINATES',
        ),
      );
    }

    // 3. Compute Julian Day for local midnight
    final julianDay = _julianDay(date.year, date.month, date.day);

    // 4. Compute Solar Coordinates at Transit (Noon)
    final sunTransitT = (julianDay - 2451545.0) / 36525.0;
    final eqOfTime = _equationOfTime(sunTransitT); // in minutes
    final declination = _sunDeclination(sunTransitT); // in degrees

    // 5. Local Solar Noon (Dhuhr) in local decimal hours
    // Dhuhr is transit time + slight safe margin (1-2 minutes) or exact transit
    final transitHours = 12.0 + tzHours - (location.longitude / 15.0) - (eqOfTime / 60.0);

    // 6. Hour Angles for transitions
    var calcStatus = CalculationStatus.normal;

    // Sunrise & Sunset: Standard atmospheric refraction zenith = 90.8333°
    final sunriseHourAngle = _hourAngle(location.latitude, declination, 90.833333);
    if (sunriseHourAngle == null) {
      // Polar day or polar night (Sun does not rise or set)
      return Result.ok(
        PrayerSchedule(
          date: date,
          location: location,
          entries: const {},
          disclosure: MethodologyDisclosure(
            methodName: parameters.methodProfileName,
            fajrAngle: parameters.fajrAngle,
            ishaAngle: parameters.ishaAngle,
            ishaIntervalMinutes: parameters.ishaIntervalMinutes,
            asrMethod: parameters.asrJuristicMethod,
            highLatitudeRule: parameters.highLatitudeRule,
            location: location,
            timezoneOffset: tzOffset,
            adjustments: adjustments,
            sourceReference: parameters.sourceReference,
          ),
          status: CalculationStatus.requiresConfig,
        ),
      );
    }

    final sunriseHours = transitHours - sunriseHourAngle;
    final sunsetHours = transitHours + sunriseHourAngle;
    final maghribHours = sunsetHours; // Base Maghrib equals sunset

    // 7. Asr Calculation (Shadow Ratio based)
    final shadowMultiplier = parameters.asrJuristicMethod == AsrJuristicMethod.hanafi ? 2.0 : 1.0;
    final asrAltitude = _arccot(shadowMultiplier + math.tan((location.latitude - declination).abs() * _d2r));
    final asrZenith = 90.0 - asrAltitude;
    final asrHourAngle = _hourAngle(location.latitude, declination, asrZenith);
    final asrHours = asrHourAngle != null ? (transitHours + asrHourAngle) : (transitHours + 3.0);

    // 8. Fajr Calculation
    double fajrHours;
    final fajrHourAngle = _hourAngle(location.latitude, declination, 90.0 + parameters.fajrAngle);
    if (fajrHourAngle != null) {
      fajrHours = transitHours - fajrHourAngle;
    } else {
      // High Latitude Fallback for Fajr
      calcStatus = CalculationStatus.highLatitudeRuleApplied;
      final nightDurationHours = (24.0 - (sunsetHours - sunriseHours)).clamp(1.0, 24.0);
      final portion = _highLatitudePortion(parameters.highLatitudeRule, parameters.fajrAngle, nightDurationHours);
      fajrHours = sunriseHours - portion;
    }

    // 9. Isha Calculation
    double ishaHours;
    if (parameters.ishaIntervalMinutes != null) {
      // Fixed Interval from Maghrib (e.g. Umm al-Qura 90 min)
      ishaHours = maghribHours + (parameters.ishaIntervalMinutes! / 60.0);
    } else {
      final ishaAngle = parameters.ishaAngle ?? 17.5;
      final ishaHourAngle = _hourAngle(location.latitude, declination, 90.0 + ishaAngle);
      if (ishaHourAngle != null) {
        ishaHours = transitHours + ishaHourAngle;
      } else {
        // High Latitude Fallback for Isha
        calcStatus = CalculationStatus.highLatitudeRuleApplied;
        final nightDurationHours = (24.0 - (sunsetHours - sunriseHours)).clamp(1.0, 24.0);
        final portion = _highLatitudePortion(parameters.highLatitudeRule, ishaAngle, nightDurationHours);
        ishaHours = sunsetHours + portion;
      }
    }

    // 10. Secondary Times: Midnight & Last Third of Night
    final nightHours = (24.0 - (sunsetHours - sunriseHours));
    final midnightHours = sunsetHours + (nightHours / 2.0);
    final lastThirdHours = sunriseHours - (nightHours / 3.0);

    // 11. Convert decimal hours to local DateTimes & apply user adjustments
    final entries = <PrayerType, PrayerTimeEntry>{};

    void addEntry(PrayerType type, double decimalHours) {
      final original = _decimalHoursToDateTime(date, decimalHours, tzOffset);
      final adjMinutes = adjustments.getFor(type);
      final adjusted = original.add(Duration(minutes: adjMinutes));

      entries[type] = PrayerTimeEntry(
        type: type,
        time: adjusted,
        originalTime: original,
        adjustmentMinutes: adjMinutes,
      );
    }

    addEntry(PrayerType.fajr, fajrHours);
    addEntry(PrayerType.sunrise, sunriseHours);
    addEntry(PrayerType.dhuhr, transitHours);
    addEntry(PrayerType.asr, asrHours);
    addEntry(PrayerType.sunset, sunsetHours);
    addEntry(PrayerType.maghrib, maghribHours);
    addEntry(PrayerType.isha, ishaHours);
    addEntry(PrayerType.midnight, midnightHours);
    addEntry(PrayerType.lastThirdOfNight, lastThirdHours);

    final disclosure = MethodologyDisclosure(
      methodName: parameters.methodProfileName,
      fajrAngle: parameters.fajrAngle,
      ishaAngle: parameters.ishaAngle,
      ishaIntervalMinutes: parameters.ishaIntervalMinutes,
      asrMethod: parameters.asrJuristicMethod,
      highLatitudeRule: parameters.highLatitudeRule,
      location: location,
      timezoneOffset: tzOffset,
      adjustments: adjustments,
      sourceReference: parameters.sourceReference,
    );

    return Result.ok(
      PrayerSchedule(
        date: date,
        location: location,
        entries: entries,
        disclosure: disclosure,
        status: calcStatus,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Astronomical Helper Functions
  // -------------------------------------------------------------------------

  static double _julianDay(int year, int month, int day) {
    var y = year;
    var m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100.0).floor();
    final b = 2 - a + (a / 4.0).floor();
    return (365.25 * (y + 4716.0)).floor() + (30.6001 * (m + 1.0)).floor() + day + b - 1524.5;
  }

  static double _sunDeclination(double t) {
    final l0 = 280.46646 + 36000.76983 * t;
    final m = 357.52911 + 35999.05029 * t;
    final c = (1.914602 - 0.004817 * t) * math.sin(m * _d2r) +
        (0.019993 - 0.000101 * t) * math.sin(2.0 * m * _d2r) +
        0.000289 * math.sin(3.0 * m * _d2r);
    final sunTrueLon = l0 + c;
    final obliquity = 23.439291 - 0.0130042 * t;
    final sinDeclination = math.sin(obliquity * _d2r) * math.sin(sunTrueLon * _d2r);
    return math.asin(sinDeclination) * _r2d;
  }

  static double _equationOfTime(double t) {
    final l0 = (280.46646 + 36000.76983 * t) % 360.0;
    final m = (357.52911 + 35999.05029 * t) % 360.0;
    final obliquity = 23.439291 - 0.0130042 * t;
    final y = math.pow(math.tan((obliquity / 2.0) * _d2r), 2);

    final sin2L0 = math.sin(2.0 * l0 * _d2r);
    final sinM = math.sin(m * _d2r);
    final cos2L0 = math.cos(2.0 * l0 * _d2r);
    final sin4L0 = math.sin(4.0 * l0 * _d2r);
    final sin2M = math.sin(2.0 * m * _d2r);

    final eotRad = y * sin2L0 -
        2.0 * 0.016708634 * sinM +
        4.0 * 0.016708634 * y * sinM * cos2L0 -
        0.5 * y * y * sin4L0 -
        1.25 * math.pow(0.016708634, 2) * sin2M;

    return (eotRad * _r2d) * 4.0; // returns minutes
  }

  /// Calculates hour angle in hours for given latitude, declination, and target zenith.
  /// Returns null if sun does not reach the specified zenith (polar/extreme conditions).
  static double? _hourAngle(double lat, double decl, double zenith) {
    final latRad = lat * _d2r;
    final declRad = decl * _d2r;
    final zenithRad = zenith * _d2r;

    final cosH = (math.cos(zenithRad) - (math.sin(latRad) * math.sin(declRad))) /
        (math.cos(latRad) * math.cos(declRad));

    if (cosH > 1.0 || cosH < -1.0) {
      return null;
    }

    final hRad = math.acos(cosH);
    return (hRad * _r2d) / 15.0; // in hours
  }

  static double _arccot(double x) {
    return (math.pi / 2.0 - math.atan(x)) * _r2d;
  }

  static double _highLatitudePortion(HighLatitudeRule rule, double angle, double nightHours) {
    switch (rule) {
      case HighLatitudeRule.middleOfTheNight:
        return nightHours / 2.0;
      case HighLatitudeRule.seventhOfTheNight:
        return nightHours / 7.0;
      case HighLatitudeRule.angleBased:
        return (angle / 60.0) * nightHours;
      case HighLatitudeRule.none:
        return nightHours / 2.0;
    }
  }

  static DateTime _decimalHoursToDateTime(DateTime date, double decimalHours, Duration tzOffset) {
    var hours = decimalHours;
    var dayOffset = 0;

    while (hours < 0.0) {
      hours += 24.0;
      dayOffset -= 1;
    }
    while (hours >= 24.0) {
      hours -= 24.0;
      dayOffset += 1;
    }

    final totalSeconds = (hours * 3600.0).round();
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;

    final baseDate = DateTime(date.year, date.month, date.day).add(Duration(days: dayOffset));
    if (date.isUtc) {
      return DateTime.utc(baseDate.year, baseDate.month, baseDate.day, h, m, s);
    } else {
      return DateTime(baseDate.year, baseDate.month, baseDate.day, h, m, s);
    }
  }
}
