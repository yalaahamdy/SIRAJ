import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/zakat/asset_entry_screen.dart';
import 'package:siraj/shell/zakat/zakat_dashboard_screen.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Asset Management Flow Suite (§16..§36, §134)', () {
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

    testWidgets('Asset Flow 1: Add new cash asset successfully updates dashboard', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('أضف أموالك أو مدخراتك للبدء'));
      await tester.pumpAndSettle();

      expect(find.byType(AssetEntryScreen), findsOneWidget);

      // Fill form
      await tester.enterText(find.widgetWithText(TextFormField, 'اسم الأصل أو الحساب (اختياري)'), 'حساب التوفير');
      await tester.enterText(find.widgetWithText(TextFormField, 'القيمة النقدية (بالريال السعودي)'), '45000');

      await tester.tap(find.text('إضافة الأصل'));
      await tester.pumpAndSettle();

      expect(find.byType(ZakatDashboardScreen), findsOneWidget);
      expect(find.text('حساب التوفير'), findsOneWidget);
      final assets = (await zakatModule.getAssets()).valueOrNull!;
      expect(assets.length, 1);
      expect(assets.first.amount.units, 4500000);
    });

    testWidgets('Asset Flow 2: Edit existing asset updates details', (tester) async {
      final initialAsset = SyntheticZakatFixtures.createCashAsset(
        id: 'asset_001',
        title: 'مدخرات قديمة',
        amount: 20000.0,
      );
      await zakatModule.addOrUpdateAsset(initialAsset);

      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('مدخرات قديمة'));
      await tester.pumpAndSettle();

      expect(find.byType(AssetEntryScreen), findsOneWidget);
      expect(find.text('تعديل أصل مالي'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextFormField, 'القيمة النقدية (بالريال السعودي)'), '30000');
      await tester.tap(find.text('حفظ التعديلات'));
      await tester.pumpAndSettle();

      final assets = (await zakatModule.getAssets()).valueOrNull!;
      expect(assets.first.amount.units, 3000000);
    });

    testWidgets('Asset Flow 3: Delete asset requires confirmation and removes item', (tester) async {
      final asset = SyntheticZakatFixtures.createCashAsset(title: 'أصل سيتم حذفه');
      await zakatModule.addOrUpdateAsset(asset);

      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(find.text('أصل سيتم حذفه'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('حذف الأصل المالي'), findsOneWidget);
      await tester.tap(find.text('حذف'));
      await tester.pumpAndSettle();

      expect(find.text('أصل سيتم حذفه'), findsNothing);
      final assets = (await zakatModule.getAssets()).valueOrNull!;
      expect(assets.isEmpty, true);
    });
  });
}
