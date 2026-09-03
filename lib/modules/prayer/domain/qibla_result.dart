import 'package:equatable/equatable.dart';
import '../../../core/location/location_models.dart';

/// Qibla calculation result from origin coordinates to the Holy Kaaba in Makkah.
class QiblaResult extends Equatable {
  /// Normalized bearing in degrees clockwise from True North (0.0 to 359.99°).
  final double directionDegrees;

  /// Great-circle distance to Makkah in kilometers.
  final double distanceKilometers;

  /// User origin coordinates.
  final GeoCoordinates origin;

  /// Holy Kaaba coordinates in Makkah (21.4225° N, 39.8262° E).
  static const GeoCoordinates kaabaCoordinates = GeoCoordinates(
    latitude: 21.4225,
    longitude: 39.8262,
    source: LocationSource.manual,
  );

  const QiblaResult({
    required this.directionDegrees,
    required this.distanceKilometers,
    required this.origin,
  }) : assert(
          directionDegrees >= 0.0 && directionDegrees < 360.0,
          'Direction must be normalized between 0.0 and 359.99 degrees',
        );

  /// True if the user is located directly at or adjacent to the Kaaba (< 0.5 km).
  bool get isAtKaaba => distanceKilometers < 0.5;

  @override
  List<Object?> get props => [directionDegrees, distanceKilometers, origin];

  @override
  String toString() => 'QiblaResult(${directionDegrees.toStringAsFixed(1)}°, distance: ${distanceKilometers.toStringAsFixed(0)} km)';
}
