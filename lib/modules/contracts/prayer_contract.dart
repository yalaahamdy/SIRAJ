import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/location/location_models.dart';

/// Contract definition for Prayer times module (To be implemented in Phase 2 / M1).
abstract class PrayerModuleContract {
  /// Calculates prayer times for a given location and date with declared calculation method profile.
  Future<Result<Map<String, DateTime>, Failure>> getPrayerTimes({
    required GeoCoordinates location,
    required DateTime date,
    required String calculationMethod,
  });

  /// Calculates Qibla direction in degrees from North for a given location.
  Future<Result<double, Failure>> getQiblaDirection(GeoCoordinates location);
}
