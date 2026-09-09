import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
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

      // In reader in memorization mode: slim compact bar should be visible
      expect(find.textContaining('ورد:'), findsOneWidget);
      expect(find.text('تسميع 🎙️'), findsOneWidget);
      expect(find.text('استماع 🎧'), findsOneWidget);
    });

    test('Tahfeez Reverse Order: Plan from Surah 114 down to Surah 112 starts reciting with An-Nas', () async {
      final now = DateTime.utc(2026, 9, 9);
      final reverseSurahs = [114, 113, 112];
      final reversePlan = MemorizationPlan(
        id: 'test_reverse_plan',
        title: 'خطة حفظ تنازلية',
        targetSurahs: reverseSurahs,
        startAyah: const AyahKey(surahNumber: 114, ayahNumber: 1),
        endAyah: const AyahKey(surahNumber: 112, ayahNumber: 4),
        dailyNewAyahs: 5,
        dailyReviewTarget: 20,
        createdAt: now,
      );

      final planAyahsRes = memorizationModule.getPlanAyahs(reversePlan);
      expect(planAyahsRes.isSuccess, isTrue);
      final planAyahs = planAyahsRes.valueOrNull!;
      expect(planAyahs.isNotEmpty, isTrue);

      // Must start with Surah 114 (An-Nas) and end with Surah 112 (Al-Ikhlas)
      expect(planAyahs.first.surahNumber, equals(114));
      expect(planAyahs.first.ayahNumber, equals(1));
      expect(planAyahs.last.surahNumber, equals(112));

      // Today's wird must also start from Surah 114
      final todayWirdRes = await memorizationModule.getTodayWirdAyahs(reversePlan);
      expect(todayWirdRes.isSuccess, isTrue);
      final todayWird = todayWirdRes.valueOrNull!;
      expect(todayWird.first.surahNumber, equals(114));
      expect(todayWird.length, equals(5));
    });
  });
}
