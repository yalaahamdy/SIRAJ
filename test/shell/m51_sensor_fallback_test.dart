import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/location/sensor_compass_service.dart';
import 'package:siraj/modules/prayer/domain/qibla_result.dart';
import 'package:siraj/shell/prayer/widgets/qibla_compass_view.dart';

void main() {
  group('M51: SIRAJ v1.0 — Sensor Awareness & Honest Fallback Suite (§15, §16, §31)', () {
    const qiblaSample = QiblaResult(
      directionDegrees: 136.5,
      distanceKilometers: 1300.0,
      origin: GeoCoordinates(latitude: 30.0444, longitude: 31.2357),
    );

    testWidgets('Layer 1: Displays explicit true-north bearing regardless of sensor presence', (tester) async {
      final mockService = MockSensorCompassService(initialSensorAvailable: false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QiblaCompassView(
            qibla: qiblaSample,
            isDark: false,
            compassService: mockService,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.textContaining('136.5° من الشمال الحقيقي'), findsOneWidget);
    });

    testWidgets('Layer 2 (No Sensor): Displays honest unsupported notice and refuses fake compass animation', (tester) async {
      final mockService = MockSensorCompassService(initialSensorAvailable: false);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QiblaCompassView(
            qibla: qiblaSample,
            isDark: false,
            compassService: mockService,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('المستشعر المغناطيسي غير متاح'), findsOneWidget);
      expect(find.textContaining('هاتفك لا يحتوي على مستشعر اتجاه'), findsOneWidget);
      expect(find.textContaining('رسم توضيحي للزاوية الجغرافية'), findsOneWidget);
    });

    testWidgets('Layer 2 (Sensor Available): Live compass dial updates and detects alignment with Qibla', (tester) async {
      final mockService = MockSensorCompassService(initialSensorAvailable: true);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: QiblaCompassView(
            qibla: qiblaSample,
            isDark: false,
            compassService: mockService,
          ),
        ),
      ));
      await tester.pumpAndSettle(); // Allow async _initCompass to finish checkSensorAvailability

      // Emit heading far from Qibla
      mockService.emitHeading(0.0); // Facing North, Qibla is 136.5°
      await tester.pumpAndSettle();

      expect(find.text('وجّه هاتفك نحو رمز الكعبة المشرفة'), findsOneWidget);

      // Emit heading facing Qibla (within 3 degrees)
      mockService.emitHeading(136.0);
      await tester.pumpAndSettle();

      expect(find.textContaining('أنت باتجاه القبلة المشرفة الآن'), findsOneWidget);
    });
  });
}
