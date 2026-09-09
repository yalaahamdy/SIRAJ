import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/memorization/past_memorization_exam_screen.dart';
import 'package:siraj/shell/memorization/plan_setup_screen.dart';
import 'package:siraj/shell/quran/widgets/quran_tahfeez_tab.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('QuranTahfeezTab Widget Test Suite (§38, §50, §55)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();
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
        home: Scaffold(body: child),
      );
    }

    testWidgets('QuranTahfeezTab renders plan hero card, today wird card, and plan surahs', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QuranTahfeezTab(
            quranModule: quranModule,
            memorizationModule: memorizationModule,
            onOpenSurah: (sNum, {targetAyah, targetPage}) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Header Plan Card
      expect(find.textContaining('خطة'), findsWidgets);
      expect(find.text('المحفوظ'), findsOneWidget);
      expect(find.text('المتبقي'), findsOneWidget);
      expect(find.text('نسبة الإنجاز'), findsOneWidget);

      // Today's Wird Card
      expect(find.text('ورد الحفظ لليوم'), findsOneWidget);
      expect(find.text('ابدأ الحفظ والتسميع في المصحف 📖🎙️'), findsOneWidget);

      // Plan Surahs Section
      expect(find.text('سور الخطة المقررة:'), findsOneWidget);
    });

    testWidgets('Tapping on plan edit button navigates to PlanSetupScreen', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QuranTahfeezTab(
            quranModule: quranModule,
            memorizationModule: memorizationModule,
            onOpenSurah: (sNum, {targetAyah, targetPage}) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      final editBtn = find.byTooltip('تعديل أو إعادة ضبط الخطة');
      expect(editBtn, findsOneWidget);
      await tester.tap(editBtn);
      await tester.pumpAndSettle();

      // Verify PlanSetupScreen is pushed
      expect(find.byType(PlanSetupScreen), findsOneWidget);
      expect(find.text('تخصيص خطة التحفيظ'), findsOneWidget);
    });
  });
}
