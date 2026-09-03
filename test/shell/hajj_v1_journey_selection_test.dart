import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/hajj_home_screen.dart';
import 'package:siraj/shell/hajj/journey_dashboard_screen.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Journey Selection Suite (§4..§8, §118)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
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
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      );
    }

    testWidgets('Journey Selection 1: Tapping Umrah opens Umrah Dashboard', (tester) async {
      await tester.pumpWidget(createTestApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('مناسك العمرة المفردة'));
      await tester.pumpAndSettle();

      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
      expect(find.text('العمرة المفردة'), findsOneWidget);
    });

    testWidgets('Journey Selection 2: Tapping Tamattu opens Tamattu Dashboard', (tester) async {
      await tester.pumpWidget(createTestApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('حج التمتع (الأفضل للآفاقي)'));
      await tester.pumpAndSettle();

      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
      expect(find.textContaining('حج التمتع'), findsWidgets);
    });

    testWidgets('Journey Selection 3: Tapping Qiran opens Qiran Dashboard', (tester) async {
      await tester.pumpWidget(createTestApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('حج القِران'));
      await tester.pumpAndSettle();

      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
      expect(find.textContaining('حج القِران'), findsWidgets);
    });

    testWidgets('Journey Selection 4: Tapping Ifrad opens Ifrad Dashboard', (tester) async {
      await tester.pumpWidget(createTestApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('حج الإفراد'));
      await tester.pumpAndSettle();

      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
      expect(find.textContaining('حج الإفراد'), findsWidgets);
    });
  });
}
