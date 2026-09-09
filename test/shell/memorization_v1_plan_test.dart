import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/memorization/domain/memorization_plan.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/memorization/plan_setup_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 4: Memorization Plan Setup & Range Selection Suite (§22..§25, §100)', () {
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

    testWidgets('Plan 1: Editing plan title and targets saves properly', (tester) async {
      bool saved = false;

      await tester.pumpWidget(
        createTestApp(
          PlanSetupScreen(
            memorizationModule: memorizationModule,
            onSaved: () => saved = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final titleField = find.byType(TextField).first;
      await tester.enterText(titleField, 'خطة سورة الكهف');
      await tester.pumpAndSettle();

      final saveBtn = find.text('حفظ وتطبيق خطة الحفظ');
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(saved, isTrue);
      final planRes = await memorizationModule.getPlan();
      expect(planRes.valueOrNull?.title, equals('خطة سورة الكهف'));
    });

    testWidgets('Plan 2: Selecting By Pages and applying Juz populates memorization items', (tester) async {
      bool saved = false;

      await tester.pumpWidget(
        createTestApp(
          PlanSetupScreen(
            memorizationModule: memorizationModule,
            onSaved: () => saved = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to By Pages mode
      await tester.tap(find.text('بالصفحات والأجزاء'));
      await tester.pumpAndSettle();

      // Save plan
      final saveBtn = find.text('حفظ وتطبيق خطة الحفظ');
      await tester.ensureVisible(saveBtn);
      await tester.pumpAndSettle();
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      expect(saved, isTrue);
      final itemsRes = await memorizationModule.getAllItems();
      expect(itemsRes.valueOrNull!.isNotEmpty, isTrue);
    });

    testWidgets('Plan 3: Passing initialTargetAyahKey links Ayah to plan', (tester) async {
      const target = AyahKey(surahNumber: 1, ayahNumber: 7);

      await tester.pumpWidget(
        createTestApp(
          PlanSetupScreen(
            memorizationModule: memorizationModule,
            initialTargetAyahKey: target,
            onSaved: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('تم ربط الآية 7'), findsOneWidget);
    });

    testWidgets('Plan 4: Smart Khatma Estimator displays calculations', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PlanSetupScreen(
            memorizationModule: memorizationModule,
            onSaved: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الحاسبة الذكية للختم والإنجاز'), findsOneWidget);
      expect(find.text('إجمالي الآيات'), findsOneWidget);
      expect(find.text('المدة المقدرة'), findsOneWidget);
    });
  });
}
