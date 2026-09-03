import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/fasting_dashboard_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting Responsive Suite (§60, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);

      await fastingModule.updateQadaPlan(QadaPlan(
        totalDays: 14,
        completedDays: 4,
        preferredWeekdays: const [1, 4],
        updatedAt: DateTime.utc(2026, 9, 1),
      ));
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
            child: child,
          ),
        ),
      );
    }

    testWidgets('Responsive 1: Small Phone (360x640) renders without layout overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          FastingDashboardScreen(module: fastingModule),
          const Size(360, 640),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الصيام ورمضان المبارك'), findsOneWidget);
    });

    testWidgets('Responsive 2: Large Phone (412x915) renders without layout overflow', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          FastingDashboardScreen(module: fastingModule),
          const Size(412, 915),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الصيام ورمضان المبارك'), findsOneWidget);
    });

    testWidgets('Responsive 3: Tablet/Desktop (1024x768) renders cleanly', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          FastingDashboardScreen(module: fastingModule),
          const Size(1024, 768),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الصيام ورمضان المبارك'), findsOneWidget);
    });
  });
}
