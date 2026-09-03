import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/memorization/study_session_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Study Session Walkthrough & Rating Suite (§9..§15, §100)', () {
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
      await memorizationModule.savePlan(MemorizationPlan(
        id: 'test_plan_fatihah',
        title: 'خطة سورة الفاتحة',
        targetSurahs: const [1],
        startAyah: const AyahKey(surahNumber: 1, ayahNumber: 1),
        endAyah: const AyahKey(surahNumber: 1, ayahNumber: 2),
        dailyNewAyahs: 2,
        dailyReviewTarget: 5,
        createdAt: DateTime.utc(2026, 9, 1),
      ));
      await memorizationModule.addAyahToPlan(const AyahKey(surahNumber: 1, ayahNumber: 1));
      await memorizationModule.addAyahToPlan(const AyahKey(surahNumber: 1, ayahNumber: 2));
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

    testWidgets('Session 1: Walkthrough lifecycle (Recall -> Reveal -> Rate -> Next -> Summary)', (tester) async {
      bool finished = false;

      await tester.pumpWidget(
        createTestApp(
          StudySessionScreen(
            memorizationModule: memorizationModule,
            onFinish: () => finished = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Card 1 is hidden
      expect(find.text('استدعِ الآية في ذاكرتك ثم اضغط للتحقق'), findsOneWidget);
      expect(find.text('إظهار الآية والتحقق'), findsOneWidget);

      // Tap Reveal
      await tester.tap(find.text('إظهار الآية والتحقق'));
      await tester.pumpAndSettle();

      // Assessment buttons appear
      expect(find.text('جيد'), findsOneWidget);
      expect(find.text('سهل'), findsOneWidget);

      // Rate "جيد" (Good)
      await tester.tap(find.text('جيد'));
      await tester.pumpAndSettle();

      // Card 2 appears or advances
      if (find.text('إظهار الآية والتحقق').evaluate().isNotEmpty) {
        await tester.tap(find.text('إظهار الآية والتحقق'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('سهل'));
        await tester.pumpAndSettle();
      }

      // Summary screen is displayed
      expect(find.text('اكتملت جلسة اليوم'), findsOneWidget);
      expect(find.text('العودة للوحة التحكم'), findsOneWidget);

      await tester.tap(find.text('العودة للوحة التحكم'));
      expect(finished, isTrue);
    });
  });
}
