import 'package:equatable/equatable.dart';

enum LocationSource {
  gps,
  network,
  manual,
}

enum LocationPermissionStatus {
  grantedPrecise,
  grantedApproximate,
  denied,
  deniedForever,
  restricted,
  unknown,
}

enum LocationServiceStatus {
  enabled,
  disabled,
  unavailable,
  timeout,
  lowAccuracy,
  stale,
  mocked,
}

/// Geographic coordinate model with accuracy, timestamp, and metadata.
class GeoCoordinates extends Equatable {
  final double latitude;
  final double longitude;
  final double? altitude;
  final double? accuracy;
  final LocationSource source;
  final DateTime? timestamp;
  final String? cityName;
  final String? countryName;
  final bool isMocked;

  const GeoCoordinates({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.accuracy,
    this.source = LocationSource.manual,
    this.timestamp,
    this.cityName,
    this.countryName,
    this.isMocked = false,
  })  : assert(latitude >= -90.0 && latitude <= 90.0, 'Latitude must be -90..90'),
        assert(longitude >= -180.0 && longitude <= 180.0, 'Longitude must be -180..180');

  GeoCoordinates copyWith({
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracy,
    LocationSource? source,
    DateTime? timestamp,
    String? cityName,
    String? countryName,
    bool? isMocked,
  }) {
    return GeoCoordinates(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracy: accuracy ?? this.accuracy,
      source: source ?? this.source,
      timestamp: timestamp ?? this.timestamp,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      isMocked: isMocked ?? this.isMocked,
    );
  }

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        altitude,
        accuracy,
        source,
        timestamp,
        cityName,
        countryName,
        isMocked,
      ];

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'accuracy': accuracy,
        'source': source.name,
        'timestamp': timestamp?.toIso8601String(),
        'cityName': cityName,
        'countryName': countryName,
        'isMocked': isMocked,
      };

  factory GeoCoordinates.fromJson(Map<String, dynamic> json) {
    return GeoCoordinates(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      source: LocationSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => LocationSource.manual,
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String)
          : null,
      cityName: json['cityName'] as String?,
      countryName: json['countryName'] as String?,
      isMocked: json['isMocked'] as bool? ?? false,
    );
  }

  @override
  String toString() =>
      'GeoCoordinates($latitude, $longitude, source: $source, accuracy: $accuracy, city: $cityName)';
}

/// Compass heading model with sensor metadata.
class CompassHeading extends Equatable {
  final double degrees;
  final double? accuracy;
  final bool hasSensor;
  final DateTime? timestamp;

  const CompassHeading({
    required this.degrees,
    this.accuracy,
    this.hasSensor = true,
    this.timestamp,
  }) : assert(degrees >= 0.0 && degrees < 360.0, 'Heading must be 0..359.99');

  @override
  List<Object?> get props => [degrees, accuracy, hasSensor, timestamp];
}
