import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/journey_dashboard_screen.dart';
import 'package:siraj/shell/hajj/widgets/ritual_step_card.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Journey Dashboard Suite (§20..§27, §107)', () {
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

    testWidgets('Journey Dashboard 1: Shows current step, next step, and toggles completion', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          JourneyDashboardScreen(
            module: hajjModule,
            journeyType: JourneyType.umrah,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
      expect(find.text('الخطوة الحالية الموصى بها:'), findsOneWidget);
      expect(find.text('الإحرام من الميقات والتلبية'), findsWidgets);
      expect(find.textContaining('ما يأتي بعد ذلك:'), findsOneWidget);
      expect(find.text('0 من 4 خطوة'), findsOneWidget);
      expect(find.byType(RitualStepCard), findsWidgets);

      // Mark first step completed
      await tester.tap(find.text('تمت هذه الخطوة'));
      await tester.pumpAndSettle();

      expect(find.text('1 من 4 خطوة'), findsOneWidget);
      expect(find.text('طواف العمرة (سبعة أشواط)'), findsWidgets);
    });

    testWidgets('Journey Dashboard 2: Completing all steps displays completion banner', (tester) async {
      await hajjModule.setJourneyType(JourneyType.umrah);
      await hajjModule.markStepCompleted('step_umrah_ihram');
      await hajjModule.markStepCompleted('step_umrah_tawaf');
      await hajjModule.markStepCompleted('step_umrah_sai');
      await hajjModule.markStepCompleted('step_umrah_tahallul');

      await tester.pumpWidget(
        createTestApp(
          JourneyDashboardScreen(
            module: hajjModule,
            journeyType: JourneyType.umrah,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('اكتملت خطوات الرحلة المسجلة'), findsOneWidget);
      expect(find.text('تم استكمال الخطوات المسجلة في الرحلة بحمد الله.'), findsOneWidget);
      expect(find.text('العودة للرئيسية'), findsOneWidget);
    });
  });
}
