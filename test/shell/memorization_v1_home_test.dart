import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/domain/review_quality.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/memorization/memorization_dashboard_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 10: Memorization Home Hub Suite (§3..§6, §95)', () {
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
        home: child,
      );
    }

    testWidgets('Home 1: Dashboard loads metrics, plan card, and start session button', (tester) async {
      bool sessionStarted = false;
      bool planSetupOpened = false;

      await tester.pumpWidget(
        createTestApp(
          MemorizationDashboardScreen(
            memorizationModule: memorizationModule,
            onStartSession: () => sessionStarted = true,
            onOpenPlanSetup: () => planSetupOpened = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('حفظ ومراجعة القرآن الكريم'), findsOneWidget);
      expect(find.text('مستحق للمراجعة'), findsOneWidget);
      expect(find.text('جديد اليوم'), findsOneWidget);
      expect(find.text('المحفوظ والمتقن'), findsOneWidget);
      expect(find.text('درجة الإتقان'), findsOneWidget);
      expect(find.text('الخطة المستهدفة'), findsOneWidget);

      // Start Session button
      final startBtn = find.textContaining('بدء جلسة');
      expect(startBtn, findsOneWidget);
      await tester.ensureVisible(startBtn);
      await tester.pumpAndSettle();
      await tester.tap(startBtn);
      await tester.pumpAndSettle();
      expect(sessionStarted, isTrue);

      // Open Plan Setup icon
      final planIcon = find.byTooltip('إعدادات الخطة');
      expect(planIcon, findsOneWidget);
      await tester.tap(planIcon);
      await tester.pumpAndSettle();
      expect(planSetupOpened, isTrue);
    });

    testWidgets('Home 2: Partially completed session displays continue button (§4)', (tester) async {
      // Create session and submit 1 review
      final sessionRes = await memorizationModule.getOrCreateTodaySession();
      final session = sessionRes.valueOrNull!;
      await memorizationModule.submitReview(
        session: session,
        ayahKey: const AyahKey(surahNumber: 114, ayahNumber: 1),
        quality: ReviewQuality.good,
      );

      await tester.pumpWidget(
        createTestApp(
          MemorizationDashboardScreen(
            memorizationModule: memorizationModule,
            onStartSession: () {},
            onOpenPlanSetup: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('استئناف جلسة اليوم'), findsOneWidget);
    });
  });
}
