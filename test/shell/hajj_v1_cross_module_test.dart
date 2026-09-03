import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/shell/hajj/hajj_home_screen.dart';
import 'package:siraj/shell/hajj/journey_dashboard_screen.dart';
import 'package:siraj/shell/hajj/miqat_guide_screen.dart';
import 'package:siraj/shell/hajj/preparation_checklist_screen.dart';
import 'package:siraj/shell/hajj/ritual_step_detail_screen.dart';
import 'package:siraj/shell/hajj/sacred_locations_screen.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Hajj Cross-Module & Deep Linking Suite (§53..§56, §125)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      adhkarModule = AdhkarModule(storageRegistry: registry);
      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      hajjModule = HajjModule(
        storageRegistry: registry,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
      AppRouter.defaultHajjModule = hajjModule;
    });

    Widget createTestApp({required String initialRoute}) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: initialRoute,
      );
    }

    testWidgets('Deep Link 1: /hajj opens HajjHomeScreen directly', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj'));
      await tester.pumpAndSettle();

      expect(find.byType(HajjHomeScreen), findsOneWidget);
    });

    testWidgets('Deep Link 2: /hajj/umrah opens JourneyDashboardScreen for Umrah', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj/umrah'));
      await tester.pumpAndSettle();

      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
      expect(find.text('العمرة المفردة'), findsOneWidget);
    });

    testWidgets('Deep Link 3: /hajj/miqat opens MiqatGuideScreen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj/miqat'));
      await tester.pumpAndSettle();

      expect(find.byType(MiqatGuideScreen), findsOneWidget);
    });

    testWidgets('Deep Link 4: /hajj/locations opens SacredLocationsScreen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj/locations'));
      await tester.pumpAndSettle();

      expect(find.byType(SacredLocationsScreen), findsOneWidget);
    });

    testWidgets('Deep Link 5: /hajj/preparation opens PreparationChecklistScreen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj/preparation'));
      await tester.pumpAndSettle();

      expect(find.byType(PreparationChecklistScreen), findsOneWidget);
    });

    testWidgets('Deep Link 6: /hajj/step/step_umrah_tawaf opens RitualStepDetailScreen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj/step/step_umrah_tawaf'));
      await tester.pumpAndSettle();

      expect(find.byType(RitualStepDetailScreen), findsOneWidget);
      expect(find.text('طواف العمرة (سبعة أشواط)'), findsWidgets);
    });
  });
}
