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
  group('SIRAJ v1.0 — Sprint 8: Hajj Accessibility Suite (§83..§85, §107)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
    });

    Widget createAccessibleApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child,
          ),
        ),
      );
    }

    testWidgets('Accessibility 1: HajjHomeScreen renders cleanly at 1.5x font scale', (tester) async {
      await tester.pumpWidget(createAccessibleApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الحج والعمرة — دليل ومناسك النسك'), findsOneWidget);
    });

    testWidgets('Accessibility 2: JourneyDashboardScreen renders cleanly at 1.5x font scale', (tester) async {
      await tester.pumpWidget(
        createAccessibleApp(
          JourneyDashboardScreen(
            module: hajjModule,
            journeyType: JourneyType.umrah,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
    });

    testWidgets('Accessibility 3: RitualStepDetailScreen renders cleanly at 1.5x font scale', (tester) async {
      final step = hajjModule.getStep('step_umrah_tawaf').valueOrNull!;
      await tester.pumpWidget(
        createAccessibleApp(
          RitualStepDetailScreen(
            step: step,
            module: hajjModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('طواف العمرة (سبعة أشواط)'), findsWidgets);
    });

    testWidgets('Accessibility 4: MiqatGuideScreen renders cleanly at 1.5x font scale', (tester) async {
      await tester.pumpWidget(createAccessibleApp(MiqatGuideScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('دليل المواقيت المكانية الخمسة'), findsOneWidget);
    });

    testWidgets('Accessibility 5: SacredLocationsScreen renders cleanly at 1.5x font scale', (tester) async {
      await tester.pumpWidget(createAccessibleApp(SacredLocationsScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المشاعر والمواقع المقدسة'), findsOneWidget);
    });

    testWidgets('Accessibility 6: PreparationChecklistScreen renders cleanly at 1.5x font scale', (tester) async {
      await tester.pumpWidget(createAccessibleApp(PreparationChecklistScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('حقيبة واستعداد الحاج والمعتمر'), findsOneWidget);
    });
  });
}
