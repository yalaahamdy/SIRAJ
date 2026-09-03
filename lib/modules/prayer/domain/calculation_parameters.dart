import 'package:equatable/equatable.dart';

/// Juristic shadow multiplier rule for calculating Asr time.
enum AsrJuristicMethod {
  /// Majority (Shafi'i, Maliki, Hanbali): shadow length equals object length (1x) + noon shadow.
  shafii,

  /// Hanafi: shadow length equals twice the object length (2x) + noon shadow.
  hanafi,
}

/// Fallback policy for high latitude regions where twilight does not occur normally.
enum HighLatitudeRule {
  none,

  /// Twilight duration is capped at half of the night (Fajr = midnight - night/2).
  middleOfTheNight,

  /// Twilight duration is capped at 1/7th of the night.
  seventhOfTheNight,

  /// Twilight duration is proportioned based on the angle / 60 degrees of the night.
  angleBased,
}

/// Explicit calculation configuration profile.
class CalculationParameters extends Equatable {
  final String methodProfileName;
  final double fajrAngle;
  final double? ishaAngle;
  final int? ishaIntervalMinutes;
  final double? maghribAngle;
  final int? maghribIntervalMinutes;
  final AsrJuristicMethod asrJuristicMethod;
  final HighLatitudeRule highLatitudeRule;
  final String? sourceReference;

  const CalculationParameters({
    required this.methodProfileName,
    required this.fajrAngle,
    this.ishaAngle,
    this.ishaIntervalMinutes,
    this.maghribAngle,
    this.maghribIntervalMinutes,
    this.asrJuristicMethod = AsrJuristicMethod.shafii,
    this.highLatitudeRule = HighLatitudeRule.middleOfTheNight,
    this.sourceReference,
  }) : assert(
          ishaAngle != null || ishaIntervalMinutes != null,
          'Either ishaAngle or ishaIntervalMinutes must be provided',
        );

  // -------------------------------------------------------------------------
  // Preset Configuration Profiles (Explicit options, not unannounced defaults)
  // -------------------------------------------------------------------------

  /// Muslim World League (رابطة العالم الإسلامي)
  static const CalculationParameters muslimWorldLeague = CalculationParameters(
    methodProfileName: 'Muslim World League (رابطة العالم الإسلامي)',
    fajrAngle: 18.0,
    ishaAngle: 17.0,
    sourceReference: 'Muslim World League resolution, Makkah',
  );

  /// Egyptian General Authority of Survey (الهيئة المصرية العامة للمساحة)
  static const CalculationParameters egyptian = CalculationParameters(
    methodProfileName: 'Egyptian General Authority of Survey (الهيئة المصرية العامة للمساحة)',
    fajrAngle: 19.5,
    ishaAngle: 17.5,
    sourceReference: 'Egyptian General Authority of Survey',
  );

  /// Umm al-Qura University, Makkah (جامعة أم القرى)
  static const CalculationParameters ummAlQura = CalculationParameters(
    methodProfileName: 'Umm al-Qura University (جامعة أم القرى)',
    fajrAngle: 18.5,
    ishaIntervalMinutes: 90,
    sourceReference: 'Institute of Astronomical & Geophysical Research, KACST',
  );

  /// University of Islamic Sciences, Karachi (جامعة العلوم الإسلامية بكراتشي)
  static const CalculationParameters karachi = CalculationParameters(
    methodProfileName: 'University of Islamic Sciences, Karachi (جامعة العلوم الإسلامية بكراتشي)',
    fajrAngle: 18.0,
    ishaAngle: 18.0,
    sourceReference: 'University of Islamic Sciences, Karachi',
  );

  /// Islamic Society of North America (ISNA)
  static const CalculationParameters isna = CalculationParameters(
    methodProfileName: 'Islamic Society of North America (ISNA)',
    fajrAngle: 15.0,
    ishaAngle: 15.0,
    sourceReference: 'ISNA Fiqh Council',
  );

  CalculationParameters copyWith({
    String? methodProfileName,
    double? fajrAngle,
    double? ishaAngle,
    int? ishaIntervalMinutes,
    double? maghribAngle,
    int? maghribIntervalMinutes,
    AsrJuristicMethod? asrJuristicMethod,
    HighLatitudeRule? highLatitudeRule,
    String? sourceReference,
  }) {
    return CalculationParameters(
      methodProfileName: methodProfileName ?? this.methodProfileName,
      fajrAngle: fajrAngle ?? this.fajrAngle,
      ishaAngle: ishaAngle ?? this.ishaAngle,
      ishaIntervalMinutes: ishaIntervalMinutes ?? this.ishaIntervalMinutes,
      maghribAngle: maghribAngle ?? this.maghribAngle,
      maghribIntervalMinutes: maghribIntervalMinutes ?? this.maghribIntervalMinutes,
      asrJuristicMethod: asrJuristicMethod ?? this.asrJuristicMethod,
      highLatitudeRule: highLatitudeRule ?? this.highLatitudeRule,
      sourceReference: sourceReference ?? this.sourceReference,
    );
  }

  @override
  List<Object?> get props => [
        methodProfileName,
        fajrAngle,
        ishaAngle,
        ishaIntervalMinutes,
        maghribAngle,
        maghribIntervalMinutes,
        asrJuristicMethod,
        highLatitudeRule,
        sourceReference,
      ];
}
