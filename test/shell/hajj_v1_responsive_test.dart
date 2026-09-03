import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/hajj_home_screen.dart';
import 'package:siraj/shell/hajj/journey_dashboard_screen.dart';
import 'package:siraj/shell/hajj/miqat_guide_screen.dart';
import 'package:siraj/shell/hajj/preparation_checklist_screen.dart';
import 'package:siraj/shell/hajj/ritual_step_detail_screen.dart';
import 'package:siraj/shell/hajj/sacred_locations_screen.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Hajj Responsive Form Factors Suite (§85, §86, §107)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
    });

    Widget createResponsiveApp(Widget child, Size size) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: child,
            ),
          ),
        ),
      );
    }

    const smallSize = Size(360, 640);

    testWidgets('Responsive 1.1: Small Phone (360x640) - HajjHomeScreen', (tester) async {
      tester.view.physicalSize = smallSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createResponsiveApp(HajjHomeScreen(module: hajjModule), smallSize));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 1.2: Small Phone (360x640) - JourneyDashboardScreen', (tester) async {
      tester.view.physicalSize = smallSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createResponsiveApp(
          JourneyDashboardScreen(module: hajjModule, journeyType: JourneyType.umrah),
          smallSize,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 1.3: Small Phone (360x640) - RitualStepDetailScreen', (tester) async {
      tester.view.physicalSize = smallSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final step = hajjModule.getStep('step_umrah_tawaf').valueOrNull!;
      await tester.pumpWidget(
        createResponsiveApp(
          RitualStepDetailScreen(step: step, module: hajjModule),
          smallSize,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 1.4: Small Phone (360x640) - MiqatGuideScreen', (tester) async {
      tester.view.physicalSize = smallSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createResponsiveApp(MiqatGuideScreen(module: hajjModule), smallSize));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 1.5: Small Phone (360x640) - SacredLocationsScreen', (tester) async {
      tester.view.physicalSize = smallSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createResponsiveApp(SacredLocationsScreen(module: hajjModule), smallSize));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 1.6: Small Phone (360x640) - PreparationChecklistScreen', (tester) async {
      tester.view.physicalSize = smallSize;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createResponsiveApp(PreparationChecklistScreen(module: hajjModule), smallSize));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 2: Large Phone (412x915) renders cleanly', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const size = Size(412, 915);

      await tester.pumpWidget(createResponsiveApp(HajjHomeScreen(module: hajjModule), size));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 3: Tablet/Desktop (1024x768) renders cleanly', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const size = Size(1024, 768);

      await tester.pumpWidget(createResponsiveApp(HajjHomeScreen(module: hajjModule), size));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
