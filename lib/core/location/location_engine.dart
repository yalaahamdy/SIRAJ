import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';
import '../storage/storage_contract.dart';
import 'city_presets.dart';
import 'location_models.dart';

/// Detailed result of location acquisition sequence.
class LocationAcquisitionReport {
  final GeoCoordinates coordinates;
  final LocationPermissionStatus permissionStatus;
  final LocationServiceStatus serviceStatus;
  final bool isAutomatic;
  final String statusMessageArabic;
  final DateTime timestamp;

  const LocationAcquisitionReport({
    required this.coordinates,
    required this.permissionStatus,
    required this.serviceStatus,
    required this.isAutomatic,
    required this.statusMessageArabic,
    required this.timestamp,
  });
}

/// Robust, sensor-aware, transparent Location Engine (§10, §11, §39, §40).
class LocationEngine {
  static const String _storageKey = 'saved_location';

  final KeyValueStore? _store;
  GeoCoordinates? _manualLocation;
  GeoCoordinates? _lastResolvedLocation;
  LocationAcquisitionReport? _lastReport;
  final StreamController<GeoCoordinates> _locationController =
      StreamController<GeoCoordinates>.broadcast();

  LocationEngine({
    GeoCoordinates? defaultLocation,
    StorageRegistry? storageRegistry,
  }) : _store = storageRegistry?.getStoreForModule('mod_location') {
    _manualLocation = defaultLocation ?? CanonicalCityPreset.canonicalPresets.first.coordinates;
    _lastResolvedLocation = _manualLocation;
    initFromStorage();
  }

  Stream<GeoCoordinates> get locationStream => _locationController.stream;

  GeoCoordinates get currentEffectiveLocation =>
      _lastResolvedLocation ?? _manualLocation ?? CanonicalCityPreset.canonicalPresets.first.coordinates;

  LocationAcquisitionReport? get lastReport => _lastReport;

  /// Loads saved location from local persistent storage on startup.
  Future<void> initFromStorage() async {
    if (_store == null) return;
    try {
      final res = await _store.getString(_storageKey);
      if (res.isSuccess && res.valueOrNull != null) {
        final json = jsonDecode(res.valueOrNull!) as Map<String, dynamic>;
        final saved = GeoCoordinates.fromJson(json);
        _lastResolvedLocation = saved;
        _manualLocation = saved;
        _locationController.add(saved);
      }
    } catch (_) {}
  }

  Future<void> _persistLocation(GeoCoordinates coords) async {
    if (_store == null) return;
    try {
      final jsonStr = jsonEncode(coords.toJson());
      await _store.setString(_storageKey, jsonStr);
    } catch (_) {}
  }

  /// Sets manual location fallback.
  void setManualLocation(GeoCoordinates location) {
    _manualLocation = location.copyWith(source: LocationSource.manual, timestamp: DateTime.now());
    _lastResolvedLocation = _manualLocation;
    _persistLocation(_manualLocation!);
    _locationController.add(_manualLocation!);
    _lastReport = LocationAcquisitionReport(
      coordinates: _manualLocation!,
      permissionStatus: LocationPermissionStatus.unknown,
      serviceStatus: LocationServiceStatus.enabled,
      isAutomatic: false,
      statusMessageArabic: 'تم تحديد الموقع يدوياً: ${_manualLocation!.cityName ?? "موقع مخصص"}',
      timestamp: DateTime.now(),
    );
  }

  /// Attempts high-quality automatic location acquisition with graceful fallbacks.
  Future<Result<LocationAcquisitionReport, SystemFailure>> acquireLocation({
    Duration timeout = const Duration(seconds: 10),
    bool allowFallbackToManual = true,
  }) async {
    final now = DateTime.now();

    // 1. Verify Location Services are enabled on device
    bool serviceEnabled;
    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    } catch (_) {
      serviceEnabled = false;
    }

    if (!serviceEnabled) {
      final fallback = _manualLocation ?? CanonicalCityPreset.canonicalPresets.first.coordinates;
      final report = LocationAcquisitionReport(
        coordinates: fallback,
        permissionStatus: LocationPermissionStatus.unknown,
        serviceStatus: LocationServiceStatus.disabled,
        isAutomatic: false,
        statusMessageArabic: 'خدمات الموقع الجغرافي (GPS) معطلة على الجهاز. يرجى تفعيلها أو استخدام الموقع اليدوي.',
        timestamp: now,
      );
      _lastReport = report;
      _lastResolvedLocation = fallback;
      return allowFallbackToManual ? Result.ok(report) : Result.err(const SystemFailure(message: 'خدمة الموقع معطلة'));
    }

    // 2. Check and request location permissions
    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } catch (e) {
      permission = LocationPermission.denied;
    }

    final permStatus = _mapPermission(permission);

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      final fallback = _manualLocation ?? CanonicalCityPreset.canonicalPresets.first.coordinates;
      final msg = permission == LocationPermission.deniedForever
          ? 'تم رفض إذن الموقع بشكل دائم من إعدادات الجهاز. يمكنك تحديده يدوياً من قائمة المدن.'
          : 'لم يتم منح إذن الوصول إلى الموقع. تم التراجع إلى الموقع اليدوي المختار.';
      final report = LocationAcquisitionReport(
        coordinates: fallback,
        permissionStatus: permStatus,
        serviceStatus: LocationServiceStatus.unavailable,
        isAutomatic: false,
        statusMessageArabic: msg,
        timestamp: now,
      );
      _lastReport = report;
      _lastResolvedLocation = fallback;
      return allowFallbackToManual ? Result.ok(report) : Result.err(SystemFailure(message: msg));
    }

    // 3. Attempt to acquire fresh GPS position
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeout,
        ),
      );

      final accuracy = position.accuracy;
      final isLowAccuracy = accuracy > 5000.0; // > 5km is considered low accuracy
      final matched = _matchNearestCity(position.latitude, position.longitude);

      final coords = GeoCoordinates(
        latitude: position.latitude,
        longitude: position.longitude,
        altitude: position.altitude,
        accuracy: accuracy,
        cityName: matched?.key,
        countryName: matched?.value,
        source: LocationSource.gps,
        timestamp: position.timestamp,
        isMocked: position.isMocked,
      );

      final report = LocationAcquisitionReport(
        coordinates: coords,
        permissionStatus: permStatus,
        serviceStatus: isLowAccuracy ? LocationServiceStatus.lowAccuracy : LocationServiceStatus.enabled,
        isAutomatic: true,
        statusMessageArabic: isLowAccuracy
            ? 'تم تحديد الموقع التلقائي بدقة تقريبية (±${(accuracy / 1000).toStringAsFixed(1)} كم).'
            : 'تم تحديد الموقع الجغرافي التلقائي بدقة عالية بنجاح.',
        timestamp: now,
      );

      _lastReport = report;
      _lastResolvedLocation = coords;
      _persistLocation(coords);
      _locationController.add(coords);
      return Result.ok(report);
    } on TimeoutException {
      // 4. Timeout fallback: attempt last known position
      try {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          final matched = _matchNearestCity(lastKnown.latitude, lastKnown.longitude);
          final coords = GeoCoordinates(
            latitude: lastKnown.latitude,
            longitude: lastKnown.longitude,
            altitude: lastKnown.altitude,
            accuracy: lastKnown.accuracy,
            cityName: matched?.key,
            countryName: matched?.value,
            source: LocationSource.gps,
            timestamp: lastKnown.timestamp,
            isMocked: lastKnown.isMocked,
          );
          final report = LocationAcquisitionReport(
            coordinates: coords,
            permissionStatus: permStatus,
            serviceStatus: LocationServiceStatus.stale,
            isAutomatic: true,
            statusMessageArabic: 'انتهت مهلة انتظار الإشارة الطازجة؛ تم استخدام آخر موقع معروف للجهاز.',
            timestamp: now,
          );
          _lastReport = report;
          _lastResolvedLocation = coords;
          _persistLocation(coords);
          _locationController.add(coords);
          return Result.ok(report);
        }
      } catch (_) {}

      // Fallback to manual
      final fallback = _manualLocation ?? CanonicalCityPreset.canonicalPresets.first.coordinates;
      final report = LocationAcquisitionReport(
        coordinates: fallback,
        permissionStatus: permStatus,
        serviceStatus: LocationServiceStatus.timeout,
        isAutomatic: false,
        statusMessageArabic: 'تعذر استقبال إشارة الأقمار الصناعية (GPS). تم استخدام الموقع اليدوي.',
        timestamp: now,
      );
      _lastReport = report;
      _lastResolvedLocation = fallback;
      return allowFallbackToManual ? Result.ok(report) : Result.err(const SystemFailure(message: 'انتهت مهلة استقبال الموقع'));
    } catch (e) {
      final fallback = _manualLocation ?? CanonicalCityPreset.canonicalPresets.first.coordinates;
      final report = LocationAcquisitionReport(
        coordinates: fallback,
        permissionStatus: permStatus,
        serviceStatus: LocationServiceStatus.unavailable,
        isAutomatic: false,
        statusMessageArabic: 'حدث خطأ أثناء محاولة جلب الموقع التلقائي. تم التراجع للموقع اليدوي.',
        timestamp: now,
      );
      _lastReport = report;
      _lastResolvedLocation = fallback;
      return allowFallbackToManual ? Result.ok(report) : Result.err(SystemFailure(message: e.toString()));
    }
  }

  void dispose() {
    _locationController.close();
  }

  static LocationPermissionStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.grantedPrecise;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unknown;
    }
  }

  static MapEntry<String, String>? _matchNearestCity(double lat, double lng) {
    double minDistance = double.infinity;
    CanonicalCityPreset? closest;
    for (final p in CanonicalCityPreset.canonicalPresets) {
      final d = Geolocator.distanceBetween(
        lat,
        lng,
        p.coordinates.latitude,
        p.coordinates.longitude,
      );
      if (d < minDistance) {
        minDistance = d;
        closest = p;
      }
    }
    if (closest != null && minDistance < 100000) {
      return MapEntry(closest.cityNameArabic, closest.countryNameArabic);
    }
    return null;
  }
}
