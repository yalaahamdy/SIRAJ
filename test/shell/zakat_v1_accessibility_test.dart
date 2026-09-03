import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/zakat/asset_entry_screen.dart';
import 'package:siraj/shell/zakat/zakat_breakdown_screen.dart';
import 'package:siraj/shell/zakat/zakat_dashboard_screen.dart';
import 'package:siraj/shell/zakat/zakat_policy_screen.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Accessibility & 1.5x Dynamic Font Suite (§84, §134, §144)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    Widget createAccessibleApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        home: MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(1.5),
            size: Size(360, 640),
          ),
          child: child,
        ),
      );
    }

    testWidgets('A11y 1: ZakatDashboardScreen renders without overflow under 1.5x text scale', (tester) async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 50000.0),
      );

      await tester.pumpWidget(createAccessibleApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('حساب الزكاة الشرعية'), findsOneWidget);
    });

    testWidgets('A11y 2: AssetEntryScreen renders cleanly under 1.5x text scale', (tester) async {
      await tester.pumpWidget(createAccessibleApp(AssetEntryScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('إضافة أصل مالي'), findsOneWidget);
    });

    testWidgets('A11y 3: ZakatBreakdownScreen renders cleanly under 1.5x text scale', (tester) async {
      await zakatModule.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000.0),
      );
      final calcRes = await zakatModule.calculateZakat();

      await tester.pumpWidget(createAccessibleApp(
        ZakatBreakdownScreen(result: calcRes.valueOrNull!, module: zakatModule),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('تفكيك وشرح حساب الزكاة'), findsOneWidget);
    });

    testWidgets('A11y 4: ZakatPolicyScreen renders cleanly under 1.5x text scale', (tester) async {
      await tester.pumpWidget(createAccessibleApp(ZakatPolicyScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('السياسات الفقهية لحساب الزكاة'), findsOneWidget);
    });
  });
}
