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
  group('SIRAJ v1.0 — Sprint 9: Zakat Responsive Multi-Form Factor Suite (§85, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    Widget createResponsiveApp(Widget child, Size size) {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: child,
        ),
      );
    }

    final sizes = [
      const Size(360, 640), // Small Phone
      const Size(412, 915), // Large Phone
      const Size(1024, 768), // Tablet
    ];

    for (final size in sizes) {
      testWidgets('Responsive: Screens render without overflow on size ${size.width}x${size.height}', (tester) async {
        await zakatModule.addOrUpdateAsset(
          SyntheticZakatFixtures.createCashAsset(amount: 50000.0),
        );
        final calcRes = await zakatModule.calculateZakat();

        // 1. Dashboard
        await tester.pumpWidget(createResponsiveApp(ZakatDashboardScreen(module: zakatModule), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // 2. Asset Entry
        await tester.pumpWidget(createResponsiveApp(AssetEntryScreen(module: zakatModule), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // 3. Breakdown
        await tester.pumpWidget(createResponsiveApp(
          ZakatBreakdownScreen(result: calcRes.valueOrNull!, module: zakatModule),
          size,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        // 4. Policy
        await tester.pumpWidget(createResponsiveApp(ZakatPolicyScreen(module: zakatModule), size));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });
}
