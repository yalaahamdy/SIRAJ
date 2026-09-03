import 'package:equatable/equatable.dart';
import '../../../core/location/location_models.dart';
import 'calculation_parameters.dart';
import 'prayer_adjustments.dart';

/// Explicit transparency record documenting all calculation parameters and assumptions (§10, §19).
class MethodologyDisclosure extends Equatable {
  final String methodName;
  final double fajrAngle;
  final double? ishaAngle;
  final int? ishaIntervalMinutes;
  final AsrJuristicMethod asrMethod;
  final HighLatitudeRule highLatitudeRule;
  final GeoCoordinates location;
  final Duration timezoneOffset;
  final PrayerAdjustments adjustments;
  final String? sourceReference;
  final String calculationEngineVersion;

  const MethodologyDisclosure({
    required this.methodName,
    required this.fajrAngle,
    this.ishaAngle,
    this.ishaIntervalMinutes,
    required this.asrMethod,
    required this.highLatitudeRule,
    required this.location,
    required this.timezoneOffset,
    required this.adjustments,
    this.sourceReference,
    this.calculationEngineVersion = '1.0.0-phase2',
  });

  @override
  List<Object?> get props => [
        methodName,
        fajrAngle,
        ishaAngle,
        ishaIntervalMinutes,
        asrMethod,
        highLatitudeRule,
        location,
        timezoneOffset,
        adjustments,
        sourceReference,
        calculationEngineVersion,
      ];
}
