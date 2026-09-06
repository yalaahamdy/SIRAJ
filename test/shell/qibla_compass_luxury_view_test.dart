import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/location/sensor_compass_service.dart';
import 'package:siraj/modules/prayer/domain/qibla_result.dart';
import 'package:siraj/shell/prayer/widgets/qibla_compass_painter.dart';
import 'package:siraj/shell/prayer/widgets/qibla_compass_view.dart';
import 'package:siraj/shell/prayer/widgets/qibla_full_screen_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Professional Qibla Compass Luxury View & Astrolabe Suite', () {
    const qibla = QiblaResult(
      directionDegrees: 136.2,
      distanceKilometers: 1280.0,
      origin: GeoCoordinates(latitude: 30.0444, longitude: 31.2357),
    );

    testWidgets('Renders CustomPaint with QiblaCompassPainter and full-screen expansion button', (tester) async {
      final mockCompass = MockSensorCompassService(initialSensorAvailable: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QiblaCompassView(
              qibla: qibla,
              isDark: true,
              compassService: mockCompass,
            ),
          ),
        ),
      );

      // Emit phone heading pointing North (0 degrees)
      mockCompass.emitHeading(0.0);
      await tester.pumpAndSettle();

      // Verify custom painter is present
      expect(find.byType(CustomPaint), findsWidgets);
      final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
      final hasAstrolabePainter = customPaints.any((cp) => cp.painter is QiblaCompassPainter);
      expect(hasAstrolabePainter, isTrue);

      // Verify full screen button is present
      final fullScreenBtn = find.byIcon(Icons.fullscreen_rounded);
      expect(fullScreenBtn, findsOneWidget);

      // Verify directional guidance when not facing Qibla (phone heading 0°, Qibla 136°)
      expect(find.textContaining('أدر هاتفك 136° يميناً ↻'), findsOneWidget);

      // Emit heading aligning with Qibla (136.2 degrees)
      mockCompass.emitHeading(136.2);
      await tester.pumpAndSettle();

      // Verify alignment confirmation
      expect(find.text('أنت باتجاه القبلة المشرفة الآن 🕋'), findsOneWidget);
    });

    testWidgets('Tapping full-screen button navigates to QiblaFullScreenView', (tester) async {
      final mockCompass = MockSensorCompassService(initialSensorAvailable: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QiblaCompassView(
              qibla: qibla,
              isDark: true,
              compassService: mockCompass,
            ),
          ),
        ),
      );
      mockCompass.emitHeading(90.0);
      await tester.pumpAndSettle();

      // Tap full screen button
      await tester.tap(find.byIcon(Icons.fullscreen_rounded));
      await tester.pumpAndSettle();

      // Expect QiblaFullScreenView to be rendered
      expect(find.byType(QiblaFullScreenView), findsOneWidget);
      expect(find.text('بوصلة القبلة المشرفة'), findsOneWidget);
      expect(find.text('زاوية الاتجاه'), findsOneWidget);
      expect(find.text('136.2°'), findsOneWidget);

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      // Back on compact view
      expect(find.byType(QiblaFullScreenView), findsNothing);
      expect(find.byType(QiblaCompassView), findsOneWidget);
    });
  });
}
