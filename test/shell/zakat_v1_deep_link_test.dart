import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/routing/app_router.dart';
import 'package:siraj/shell/zakat/asset_entry_screen.dart';
import 'package:siraj/shell/zakat/zakat_dashboard_screen.dart';
import 'package:siraj/shell/zakat/zakat_policy_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Deep Linking & Safe Routing Suite (§70, §71, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
      AppRouter.defaultZakatModule = zakatModule;
    });

    Widget createTestApp(String initialRoute) {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.generateRoute,
      );
    }

    testWidgets('Deep Link 1: /zakat opens ZakatDashboardScreen', (tester) async {
      await tester.pumpWidget(createTestApp(AppRouter.zakat));
      await tester.pumpAndSettle();

      expect(find.byType(ZakatDashboardScreen), findsOneWidget);
    });

    testWidgets('Deep Link 2: /zakat/assets opens AssetEntryScreen', (tester) async {
      await tester.pumpWidget(createTestApp(AppRouter.zakatAssets));
      await tester.pumpAndSettle();

      expect(find.byType(AssetEntryScreen), findsOneWidget);
    });

    testWidgets('Deep Link 3: /zakat/policy opens ZakatPolicyScreen', (tester) async {
      await tester.pumpWidget(createTestApp(AppRouter.zakatPolicy));
      await tester.pumpAndSettle();

      expect(find.byType(ZakatPolicyScreen), findsOneWidget);
    });

    testWidgets('Deep Link 4: Invalid deep link /zakat/invalid_route displays safe fallback screen', (tester) async {
      await tester.pumpWidget(createTestApp('/zakat/unknown_route_123'));
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.text('الرابط المطلوب لحساب الزكاة غير صالح.'), findsOneWidget);
      expect(find.text('العودة للزكاة'), findsOneWidget);
    });
  });
}
