import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/i18n/app_strings.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/prayer_screen.dart';
import 'package:siraj/shell/prayer/widgets/qibla_compass_view.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Qibla Compass & Calibration Suite (§15, §16, §46)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      );
    }

    testWidgets('Qibla Compass displays dial, Kaaba bearing, and distance to Makkah', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(
            prayerModule: prayerModule,
            initialLocation: const GeoCoordinates(
              latitude: 24.7136, // Riyadh
              longitude: 46.6753,
              source: LocationSource.manual,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QiblaCompassView), findsOneWidget);
      expect(find.text(AppStrings.qiblaDirection), findsOneWidget);
      expect(find.text('زاوية الاتجاه'), findsOneWidget);
      expect(find.text('المسافة إلى مكة المكرمة'), findsOneWidget);
      expect(find.textContaining('كم'), findsWidgets);
    });

    testWidgets('Tapping calibration button opens step-by-step guidance modal', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(prayerModule: prayerModule),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure visible and tap calibration button in Qibla card
      final calibrateFinder = find.text('المعايرة');
      await tester.ensureVisible(calibrateFinder);
      await tester.tap(calibrateFinder);
      await tester.pumpAndSettle();

      // Verify guidance dialog is visible
      expect(find.text('إرشادات معايرة البوصلة'), findsOneWidget);
      expect(find.textContaining('حرك الهاتف على شكل رقم (8)'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('حسناً، فهمت'));
      await tester.pumpAndSettle();
      expect(find.text('إرشادات معايرة البوصلة'), findsNothing);
    });
  });
}
