import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/zakat/zakat_dashboard_screen.dart';
import 'package:siraj/shell/zakat/widgets/zakat_hero_summary_card.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Home Hub Suite (§3..§9, §134)', () {
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

    testWidgets('Zakat Home 1: Displays empty state with prompt when no assets added', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(find.text('حساب الزكاة الشرعية'), findsOneWidget);
      expect(find.text('لم تقم بإضافة أي أصول مالية بعد'), findsOneWidget);
      expect(find.text('أضف أموالك أو مدخراتك للبدء'), findsOneWidget);
      expect(find.byType(ZakatHeroSummaryCard), findsOneWidget);
      expect(find.text('الوعاء الصافي'), findsOneWidget);
    });

    testWidgets('Zakat Home 2: Displays assets and calculated hero summary card when assets exist', (tester) async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0, title: 'محفظة استثمارية'),
      );

      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(find.text('محفظة استثمارية'), findsOneWidget);
      expect(find.byType(ZakatHeroSummaryCard), findsOneWidget);
      expect(find.text('الوعاء الصافي'), findsOneWidget);
      expect(find.text('حد النصاب'), findsOneWidget);
      expect(find.text('الحول'), findsOneWidget);
    });

    testWidgets('Zakat Home 3: Calendar switch updates between Hijri and Gregorian rates', (tester) async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0),
      );

      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(find.text('سنة هجرية (2.5%)'), findsOneWidget);

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(find.text('سنة ميلادية (2.577%)'), findsOneWidget);
    });
  });
}
