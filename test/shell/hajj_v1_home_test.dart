import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/hajj_home_screen.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Hajj Home Hub Suite (§3..§8, §107)', () {
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

    testWidgets('Hajj Home 1: Displays Title, Journey Types, and Guidance Guides', (tester) async {
      await tester.pumpWidget(createTestApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(find.text('الحج والعمرة — دليل ومناسك النسك'), findsOneWidget);
      expect(find.text('مناسك العمرة المفردة'), findsOneWidget);
      expect(find.text('حج التمتع (الأفضل للآفاقي)'), findsOneWidget);
      expect(find.text('حج القِران'), findsOneWidget);
      expect(find.text('حج الإفراد'), findsOneWidget);

      // Scroll to guidance section
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('حقيبة واستعداد الحاج والمعتمر'), findsOneWidget);
      expect(find.text('دليل المواقيت المكانية الخمسة'), findsOneWidget);
      expect(find.text('المشاعر والمواقع المقدسة'), findsOneWidget);
    });

    testWidgets('Hajj Home 2: Displays Continue Active Journey card when steps are completed', (tester) async {
      await hajjModule.setJourneyType(JourneyType.umrah);
      await hajjModule.markStepCompleted('step_umrah_ihram');

      await tester.pumpWidget(createTestApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(find.text('متابعة رحلة النسك الحالية'), findsOneWidget);
      expect(find.textContaining('العمرة'), findsWidgets);
      expect(find.textContaining('تم إنجاز 1 خطوة'), findsOneWidget);
    });

    testWidgets('Hajj Home 3: Reset data dialog resets user journey data locally', (tester) async {
      await hajjModule.setJourneyType(JourneyType.umrah);
      await hajjModule.markStepCompleted('step_umrah_ihram');

      await tester.pumpWidget(createTestApp(HajjHomeScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(find.text('متابعة رحلة النسك الحالية'), findsOneWidget);

      // Tap Reset action in AppBar
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(find.text('إعادة ضبط بيانات الحج والعمرة'), findsOneWidget);

      // Confirm reset
      await tester.tap(find.text('إعادة الضبط'));
      await tester.pumpAndSettle();

      // Card should be gone
      expect(find.text('متابعة رحلة النسك الحالية'), findsNothing);
    });
  });
}
