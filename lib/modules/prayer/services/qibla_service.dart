import 'dart:math' as math;
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/location/location_models.dart';
import '../domain/qibla_result.dart';

/// Independent Qibla calculation service using spherical trigonometry (§16).
class QiblaService {
  const QiblaService();

  static const double _d2r = math.pi / 180.0;
  static const double _r2d = 180.0 / math.pi;

  // Earth's mean radius in kilometers
  static const double _earthRadiusKm = 6371.0;

  /// Calculates the true bearing to the Holy Kaaba and great-circle distance.
  Result<QiblaResult, Failure> calculateQibla(GeoCoordinates location) {
    // 1. Validate coordinate boundaries
    if (location.latitude.abs() > 90.0 || location.longitude.abs() > 180.0) {
      return Result.err(
        const SystemFailure(
          message: 'Coordinates out of valid geographical bounds',
          code: 'INVALID_COORDINATES',
        ),
      );
    }

    final lat1 = location.latitude * _d2r;
    final lon1 = location.longitude * _d2r;
    final lat2 = QiblaResult.kaabaCoordinates.latitude * _d2r;
    final lon2 = QiblaResult.kaabaCoordinates.longitude * _d2r;

    final dLon = lon2 - lon1;

    // 2. Spherical Great-Circle Initial Bearing Equation
    final y = math.sin(dLon) * math.cos(lat2);
    final x = (math.cos(lat1) * math.sin(lat2)) -
        (math.sin(lat1) * math.cos(lat2) * math.cos(dLon));

    var bearingRad = math.atan2(y, x);
    var bearingDeg = (bearingRad * _r2d) % 360.0;
    if (bearingDeg < 0.0) {
      bearingDeg += 360.0;
    }

    // 3. Haversine Distance Equation
    final dLat = lat2 - lat1;
    final a = math.sin(dLat / 2.0) * math.sin(dLat / 2.0) +
        math.cos(lat1) * math.cos(lat2) * math.sin(dLon / 2.0) * math.sin(dLon / 2.0);
    final c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a));
    final distanceKm = _earthRadiusKm * c;

    return Result.ok(
      QiblaResult(
        directionDegrees: bearingDeg,
        distanceKilometers: distanceKm,
        origin: location,
      ),
    );
  }
}
