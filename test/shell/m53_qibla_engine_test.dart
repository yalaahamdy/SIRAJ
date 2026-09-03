import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/location/sensor_compass_service.dart';
import 'package:siraj/modules/prayer/domain/qibla_result.dart';
import 'package:siraj/modules/prayer/services/qibla_service.dart';
import 'package:siraj/shell/prayer/widgets/qibla_compass_view.dart';

class MockSensorCompassService implements SensorCompassService {
  final bool available;
  final StreamController<CompassHeading> _controller = StreamController<CompassHeading>.broadcast();

  MockSensorCompassService({this.available = true});

  @override
  Stream<CompassHeading> get headingStream => _controller.stream;

  @override
  Future<bool> checkSensorAvailability() async => available;

  @override
  void dispose() {
    _controller.close();
  }

  void emitHeading(double degrees) {
    _controller.add(CompassHeading(degrees: degrees, accuracy: 1.0, hasSensor: available));
  }
}

void main() {
  group('M53: SIRAJ v1.0 — Sensor-Aware Qibla Engine & Spherical Trig Suite (§16, §21, §22)', () {
    const qiblaService = QiblaService();

    test('Spherical Trig Calculation: Verifies exact mathematical bearing and distances across continents', () {
      // 1. Cairo, Egypt (approx 30.0444° N, 31.2357° E) -> Qibla ~136° (SE)
      const cairo = GeoCoordinates(latitude: 30.0444, longitude: 31.2357);
      final cairoRes = qiblaService.calculateQibla(cairo);
      expect(cairoRes.isSuccess, isTrue);
      final cairoQibla = cairoRes.valueOrNull!;
      expect(cairoQibla.directionDegrees, inInclusiveRange(134.0, 138.0));
      expect(cairoQibla.distanceKilometers, inInclusiveRange(1200.0, 1400.0));

      // 2. London, UK (approx 51.5074° N, -0.1278° W) -> Qibla ~119° (ESE)
      const london = GeoCoordinates(latitude: 51.5074, longitude: -0.1278);
      final londonRes = qiblaService.calculateQibla(london);
      expect(londonRes.isSuccess, isTrue);
      final londonQibla = londonRes.valueOrNull!;
      expect(londonQibla.directionDegrees, inInclusiveRange(117.0, 121.0));
      expect(londonQibla.distanceKilometers, inInclusiveRange(4700.0, 4900.0));

      // 3. New York, USA (approx 40.7128° N, -74.0060° W) -> Qibla ~58.5° (ENE along great-circle)
      const newYork = GeoCoordinates(latitude: 40.7128, longitude: -74.0060);
      final nyRes = qiblaService.calculateQibla(newYork);
      expect(nyRes.isSuccess, isTrue);
      final nyQibla = nyRes.valueOrNull!;
      expect(nyQibla.directionDegrees, inInclusiveRange(57.0, 60.0));
      expect(nyQibla.distanceKilometers, inInclusiveRange(10100.0, 10400.0));

      // 4. Jakarta, Indonesia (approx -6.2088° S, 106.8456° E) -> Qibla ~295° (WNW)
      const jakarta = GeoCoordinates(latitude: -6.2088, longitude: 106.8456);
      final jakartaRes = qiblaService.calculateQibla(jakarta);
      expect(jakartaRes.isSuccess, isTrue);
      final jakartaQibla = jakartaRes.valueOrNull!;
      expect(jakartaQibla.directionDegrees, inInclusiveRange(293.0, 297.0));
      expect(jakartaQibla.distanceKilometers, inInclusiveRange(7800.0, 8100.0));
    });

    test('Boundary Limits: Validates extreme geographical boundary coordinates correctly', () {
      final northPole = qiblaService.calculateQibla(const GeoCoordinates(latitude: 90.0, longitude: 0.0));
      expect(northPole.isSuccess, isTrue);

      final southPole = qiblaService.calculateQibla(const GeoCoordinates(latitude: -90.0, longitude: 0.0));
      expect(southPole.isSuccess, isTrue);
    });

    testWidgets('Sensor Transparency: Discloses missing compass sensor honestly without fake needle', (tester) async {
      const qibla = QiblaResult(
        directionDegrees: 136.2,
        distanceKilometers: 1280.0,
        origin: GeoCoordinates(latitude: 30.0444, longitude: 31.2357),
      );

      final mockCompass = MockSensorCompassService(available: false);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QiblaCompassView(
              qibla: qibla,
              isDark: false,
              compassService: mockCompass,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify honest disclosure notice
      expect(find.text('المستشعر المغناطيسي غير متاح'), findsOneWidget);
      expect(find.textContaining('هاتفك لا يحتوي على مستشعر اتجاه'), findsOneWidget);
      expect(find.text('رسم توضيحي للزاوية الجغرافية من الشمال (وليس بوصلة حية)'), findsOneWidget);
      expect(find.text('136.2°'), findsWidgets);
    });

    testWidgets('Live Sensor: Displays interactive live compass when sensor is available and active', (tester) async {
      const qibla = QiblaResult(
        directionDegrees: 136.0,
        distanceKilometers: 1280.0,
        origin: GeoCoordinates(latitude: 30.0444, longitude: 31.2357),
      );

      final mockCompass = MockSensorCompassService(available: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QiblaCompassView(
              qibla: qibla,
              isDark: false,
              compassService: mockCompass,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Emit phone heading pointing at 136 degrees (facing Kaaba directly)
      mockCompass.emitHeading(136.0);
      await tester.pumpAndSettle();

      // Expect facing Qibla confirmation
      expect(find.text('أنت باتجاه القبلة المشرفة الآن 🕋'), findsOneWidget);
    });
  });
}
