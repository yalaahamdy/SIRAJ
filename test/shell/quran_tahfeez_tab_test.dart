import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/memorization/past_memorization_exam_screen.dart';
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

    testWidgets('QuranTahfeezTab renders header banner, metrics grid, plan card, and past exam card', (tester) async {
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

      // Header Banner
      expect(find.text('برنامج تحفيظ وتثبيت القرآن الكريم'), findsOneWidget);

      // Metrics Grid (Stat cards)
      expect(find.text('ورد جديد اليوم'), findsOneWidget);
      expect(find.text('مستحق للمراجعة'), findsOneWidget);
      expect(find.text('المحفوظ والمتقن'), findsOneWidget);
      expect(find.text('تمكين حفظ الماضي'), findsOneWidget);

      // Plan Card
      expect(find.text('خطة التحفيظ المستهدفة'), findsOneWidget);
      expect(find.text('تخصيص الخطة'), findsOneWidget);

      // Past Memorization Card
      expect(find.text('نظام تسميع واختبار (الماضي) — لتأكيد الحفظ'), findsOneWidget);
      expect(find.text('بدء اختبار وتسميع الماضي الآن 🌟'), findsOneWidget);

      // Daily Wird Section
      expect(find.text('أوراد الحفظ والمراجعة لليوم'), findsOneWidget);
      expect(find.text('1. ورد الحفظ الجديد (السبق)'), findsOneWidget);
      expect(find.text('2. ورد المراجعة الصغرى (مراجعة القريب)'), findsOneWidget);
    });

    testWidgets('Tapping on past exam button navigates to PastMemorizationExamScreen', (tester) async {
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

      // Tap on past exam button
      final pastExamBtn = find.text('بدء اختبار وتسميع الماضي الآن 🌟');
      expect(pastExamBtn, findsOneWidget);
      await tester.ensureVisible(pastExamBtn);
      await tester.pumpAndSettle();
      await tester.tap(pastExamBtn);
      await tester.pumpAndSettle();

      // Verify PastMemorizationExamScreen is pushed
      expect(find.byType(PastMemorizationExamScreen), findsOneWidget);
      expect(find.text('تسميع واختبار الماضي (تأكيد الحفظ)'), findsOneWidget);
    });
  });
}
