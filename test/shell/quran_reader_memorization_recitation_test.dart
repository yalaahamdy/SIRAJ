import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('QuranReaderScreen Memorization Mode & Speech Recognition Evaluation', () {
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
      await memorizationModule.savePlan(
        MemorizationPlan.createDefaultJuzAmma(DateTime.utc(2026, 9, 1)),
      );
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

    testWidgets('Reader in memorization mode filters to target ayahs and renders header card', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            memorizationModule: memorizationModule,
            initialSurahNumber: 1,
            isMemorizationMode: true,
            memorizationStartAyah: 1,
            memorizationEndAyah: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check header card
      expect(find.textContaining('ورد الحفظ المقرر لليوم'), findsOneWidget);
      expect(find.textContaining('سورة الفاتحة'), findsWidgets);
      expect(find.textContaining('الآيات (1 إلى 3)'), findsOneWidget);
      expect(find.text('استماع وترديد 🎧'), findsOneWidget);
      expect(find.text('بدء التسميع الآلي 🎙️'), findsOneWidget);
    });

    testWidgets('Starting in-place recitation launches recognition mode and allows word reveal', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            memorizationModule: memorizationModule,
            initialSurahNumber: 1,
            isMemorizationMode: true,
            memorizationStartAyah: 1,
            memorizationEndAyah: 2,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap "بدء التسميع الآلي"
      final startTasmeeBtn = find.text('بدء التسميع الآلي 🎙️');
      await tester.tap(startTasmeeBtn);
      await tester.pumpAndSettle();

      // Recognition bar should be visible with "إظهار كلمة"
      expect(find.text('إظهار كلمة'), findsOneWidget);
      expect(find.byTooltip('إنهاء التسميع'), findsOneWidget);

      // Finish recitation with 0 reveals (100% mastery <= 5% assistance)
      final finishBtn = find.byTooltip('إنهاء التسميع');
      await tester.tap(finishBtn);
      await tester.pumpAndSettle();

      // Should show celebratory dialog
      expect(find.textContaining('مبارك! أتقنت التسميع'), findsOneWidget);

      // Ayahs should now be marked as memorized in memorizationModule
      final isMem = await memorizationModule.isAyahMemorized(
        const AyahKey(surahNumber: 1, ayahNumber: 1),
      );
      expect(isMem, isTrue);
    });
  });
}
