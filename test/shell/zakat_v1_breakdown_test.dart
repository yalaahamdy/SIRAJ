import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/zakat/zakat_breakdown_screen.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Explainable Breakdown Suite (§47..§50, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        home: child,
      );
    }

    testWidgets('Breakdown 1: Renders complete itemized table and save snapshot action', (tester) async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0),
      );
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createDebtLiability(amount: 10000.0),
      );

      final calcRes = await zakatModule.calculateZakat();
      final result = calcRes.valueOrNull!;

      await tester.pumpWidget(createTestApp(
        ZakatBreakdownScreen(result: result, module: zakatModule),
      ));
      await tester.pumpAndSettle();

      expect(find.text('تفكيك وشرح حساب الزكاة'), findsOneWidget);
      expect(find.text('إجمالي الأصول المقومة'), findsOneWidget);
      expect(find.text('الديون والالتزامات المخصومة'), findsOneWidget);
      expect(find.text('الوعاء الزكوي الصافي'), findsOneWidget);
      expect(find.text('حد النصاب الشرعي المقوم'), findsOneWidget);
      expect(find.text('حالة الحول الزمني'), findsOneWidget);
      expect(find.text('مبلغ الزكاة المحسوبة'), findsOneWidget);

      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      final buttonFinder = find.text('حفظ لقطة الحساب في السجل التاريخي');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(find.text('تم حفظ لقطة الحساب في السجل التاريخي بنجاح'), findsOneWidget);
      final snapshots = (await zakatModule.getSnapshots()).valueOrNull!;
      expect(snapshots.length, 1);
    });
  });
}
