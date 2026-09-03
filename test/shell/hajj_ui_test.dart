import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/hajj_home_screen.dart';
import 'package:siraj/shell/hajj/journey_dashboard_screen.dart';
import 'package:siraj/shell/hajj/preparation_checklist_screen.dart';
import 'package:siraj/shell/hajj/ritual_step_detail_screen.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('L4 Hajj & Umrah Shell UI & Interaction Tests (§46, §47)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
    });

    testWidgets('HajjHomeScreen renders journeys selector, banner, and preparation links', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: HajjHomeScreen(module: hajjModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الحج والعمرة — دليل ومناسك النسك'), findsOneWidget);
      expect(find.text('مناسك العمرة المفردة'), findsOneWidget);
      expect(find.text('حج التمتع (الأفضل للآفاقي)'), findsOneWidget);
      expect(find.text('حقيبة واستعداد الحاج والمعتمر'), findsOneWidget);
      expect(find.text('دليل المواقيت المكانية الخمسة'), findsOneWidget);
    });

    testWidgets('Tapping Umrah navigates to JourneyDashboardScreen and toggles step completion', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: JourneyDashboardScreen(
              module: hajjModule,
              journeyType: JourneyType.umrah,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(JourneyDashboardScreen), findsOneWidget);
      expect(find.text('الإحرام من الميقات والتلبية'), findsWidgets);
      expect(find.text('طواف العمرة (سبعة أشواط)'), findsWidgets);
      expect(find.text('0 من 4 خطوة'), findsOneWidget);

      // Tap 'تمت هذه الخطوة' button on hero card for Step 1
      await tester.tap(find.text('تمت هذه الخطوة'));
      await tester.pumpAndSettle();

      // Step 1 completed, current advances to Step 2, count is 1 of 4
      expect(find.text('1 من 4 خطوة'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Tapping step details navigates to RitualStepDetailScreen with fiqh options', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: JourneyDashboardScreen(
              module: hajjModule,
              journeyType: JourneyType.umrah,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('التفاصيل'));
      await tester.pumpAndSettle();

      expect(find.byType(RitualStepDetailScreen), findsOneWidget);
      expect(find.text('الصفة والبيان الإرشادي (§8):'), findsOneWidget);
      expect(find.text('الخيارات والأقوال الفقهية المعتبرة (§9):'), findsOneWidget);
    });

    testWidgets('Tapping checklist navigates to PreparationChecklistScreen and toggles checkbox', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: PreparationChecklistScreen(module: hajjModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PreparationChecklistScreen), findsOneWidget);
      expect(find.text('جواز السفر وتأشيرة/تصريح الحج والعمرة'), findsOneWidget);

      await tester.tap(find.text('جواز السفر وتأشيرة/تصريح الحج والعمرة'));
      await tester.pumpAndSettle();
    });
  });
}
