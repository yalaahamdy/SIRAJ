import '../errors/app_failure.dart';
import '../errors/result.dart';
import 'city_presets.dart';
import 'location_engine.dart';
import 'location_models.dart';

/// Contract for obtaining device / manual location.
abstract class LocationService {
  /// Gets current location (GPS or fallback).
  Future<Result<GeoCoordinates, SystemFailure>> getCurrentLocation();

  /// Gets manually selected location.
  Future<Result<GeoCoordinates?, SystemFailure>> getManualLocation();

  /// Sets manually selected location.
  Future<Result<void, SystemFailure>> setManualLocation(GeoCoordinates coordinates);
}

/// Production implementation of LocationService backed by the robust LocationEngine.
class ProductionLocationService implements LocationService {
  final LocationEngine engine;

  ProductionLocationService({LocationEngine? engine})
      : engine = engine ?? LocationEngine(defaultLocation: CanonicalCityPreset.canonicalPresets.first.coordinates);

  @override
  Future<Result<GeoCoordinates, SystemFailure>> getCurrentLocation() async {
    final reportResult = await engine.acquireLocation();
    if (reportResult.isSuccess) {
      return Result.ok(reportResult.valueOrNull!.coordinates);
    }
    // Always fallback to current effective location to guarantee usability (§10, §11)
    return Result.ok(engine.currentEffectiveLocation);
  }

  @override
  Future<Result<GeoCoordinates?, SystemFailure>> getManualLocation() async {
    return Result.ok(engine.currentEffectiveLocation);
  }

  @override
  Future<Result<void, SystemFailure>> setManualLocation(GeoCoordinates coordinates) async {
    engine.setManualLocation(coordinates);
    return Result.ok(null);
  }
}

/// In-memory test implementation of LocationService.
class TestLocationService implements LocationService {
  GeoCoordinates? _current;
  GeoCoordinates? _manual;

  TestLocationService({GeoCoordinates? initialLocation})
      : _current = initialLocation ??
            const GeoCoordinates(
              latitude: 21.4225,
              longitude: 39.8262,
              source: LocationSource.manual,
            );

  void setLocation(GeoCoordinates location) {
    _current = location;
  }

  @override
  Future<Result<GeoCoordinates, SystemFailure>> getCurrentLocation() async {
    if (_current != null) {
      return Result.ok(_current!);
    }
    return Result.err(const SystemFailure(message: 'Location unavailable'));
  }

  @override
  Future<Result<GeoCoordinates?, SystemFailure>> getManualLocation() async {
    return Result.ok(_manual);
  }

  @override
  Future<Result<void, SystemFailure>> setManualLocation(GeoCoordinates coordinates) async {
    _manual = coordinates;
    _current = coordinates;
    return Result.ok(null);
  }
}
