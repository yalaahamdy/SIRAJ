import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';
import 'location_models.dart';

/// Contract for device compass / orientation sensor readings.
abstract class SensorCompassService {
  /// Stream of live compass heading events.
  Stream<CompassHeading> get headingStream;

  /// Checks if device has a physical magnetometer / compass sensor available.
  Future<bool> checkSensorAvailability();

  /// Closes any active streams / listeners.
  void dispose();
}

/// Production implementation of SensorCompassService using device hardware sensors.
class DeviceSensorCompassService implements SensorCompassService {
  StreamController<CompassHeading>? _controller;
  StreamSubscription<MagnetometerEvent>? _subscription;
  bool _hasSensor = true;

  @override
  Stream<CompassHeading> get headingStream {
    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<CompassHeading>.broadcast(
        onListen: _startListening,
        onCancel: _stopListening,
      );
    }
    return _controller!.stream;
  }

  void _startListening() {
    try {
      _subscription = magnetometerEventStream().listen(
        (event) {
          _hasSensor = true;
          // Calculate heading in horizontal plane from magnetometer vector
          // atan2(-y, x) yields heading in radians clockwise from north
          double headingRad = math.atan2(-event.y, event.x);
          double headingDeg = (headingRad * 180.0 / math.pi) % 360.0;
          if (headingDeg < 0.0) {
            headingDeg += 360.0;
          }

          if (!_controller!.isClosed) {
            _controller!.add(
              CompassHeading(
                degrees: headingDeg,
                accuracy: 5.0, // Typical hardware magnetometer accuracy
                hasSensor: true,
                timestamp: DateTime.now(),
              ),
            );
          }
        },
        onError: (_) {
          _hasSensor = false;
          if (!_controller!.isClosed) {
            _controller!.add(
              CompassHeading(
                degrees: 0.0,
                hasSensor: false,
                timestamp: DateTime.now(),
              ),
            );
          }
        },
      );
    } catch (_) {
      _hasSensor = false;
    }
  }

  void _stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Future<bool> checkSensorAvailability() async {
    // In automated widget testing environments without physical hardware sensors,
    // immediately return false to avoid lingering fake async timers.
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      _hasSensor = false;
      return false;
    }
    // If we've already detected sensor absence, return immediately
    if (!_hasSensor) return false;
    try {
      // Test first event with 1-second timeout
      final event = await magnetometerEventStream().first.timeout(
        const Duration(milliseconds: 1200),
      );
      // Valid reading received
      _hasSensor = (event.x != 0.0 || event.y != 0.0 || event.z != 0.0);
      return _hasSensor;
    } catch (_) {
      _hasSensor = false;
      return false;
    }
  }

  @override
  void dispose() {
    _stopListening();
    _controller?.close();
    _controller = null;
  }
}

/// Deterministic test mock for SensorCompassService to test both sensor-available and sensor-absent modes.
class MockSensorCompassService implements SensorCompassService {
  final bool initialSensorAvailable;
  final StreamController<CompassHeading> _mockController = StreamController<CompassHeading>.broadcast();

  MockSensorCompassService({this.initialSensorAvailable = true});

  void emitHeading(double degrees, {double accuracy = 1.0}) {
    if (initialSensorAvailable) {
      _mockController.add(
        CompassHeading(
          degrees: degrees % 360.0,
          accuracy: accuracy,
          hasSensor: true,
          timestamp: DateTime.now(),
        ),
      );
    } else {
      _mockController.add(
        CompassHeading(
          degrees: 0.0,
          hasSensor: false,
          timestamp: DateTime.now(),
        ),
      );
    }
  }

  @override
  Stream<CompassHeading> get headingStream => _mockController.stream;

  @override
  Future<bool> checkSensorAvailability() async {
    return initialSensorAvailable;
  }

  @override
  void dispose() {
    _mockController.close();
  }
}
