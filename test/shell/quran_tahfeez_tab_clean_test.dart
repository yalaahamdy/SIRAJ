import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/widgets/quran_tahfeez_tab.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('QuranTahfeezTab Clean Architecture & Responsive Suite', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late MemorizationModule memorizationModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      memorizationModule = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranModule.store,
      );
      await memorizationModule.initialize();
      await memorizationModule.savePlan(MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)));
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

    testWidgets('Tahfeez Tab 1: Directly displays plan, wird target card and surahs with zero overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          QuranTahfeezTab(
            quranModule: quranModule,
            memorizationModule: memorizationModule,
            onOpenSurah: (sNum, {targetPage, targetAyah}) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Plan Hero Card
      expect(find.textContaining('جزء عم'), findsOneWidget);
      expect(find.text('المحفوظ'), findsOneWidget);
      expect(find.text('المتبقي'), findsOneWidget);
      expect(find.text('نسبة الإنجاز'), findsOneWidget);

      // Check Today's Wird Section
      expect(find.text('ورد الحفظ لليوم'), findsOneWidget);
      expect(find.text('ابدأ الحفظ والتسميع في المصحف 📖🎙️'), findsOneWidget);

      // Check Plan Surahs List
      expect(find.text('سور الخطة المقررة:'), findsOneWidget);
    });

    testWidgets('Tahfeez Tab 2: Tapping "ابدأ الحفظ والتسميع في المصحف" navigates to reader with target', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QuranTahfeezTab(
            quranModule: quranModule,
            memorizationModule: memorizationModule,
            onOpenSurah: (sNum, {targetPage, targetAyah}) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final startBtn = find.text('ابدأ الحفظ والتسميع في المصحف 📖🎙️');
      expect(startBtn, findsOneWidget);
      await tester.tap(startBtn);
      await tester.pumpAndSettle();

      // In reader in memorization mode: header card should be visible
      expect(find.textContaining('ورد الحفظ المقرر لليوم'), findsOneWidget);
      expect(find.text('بدء التسميع الآلي 🎙️'), findsOneWidget);
      expect(find.text('استماع وترديد 🎧'), findsOneWidget);
    });
  });
}
