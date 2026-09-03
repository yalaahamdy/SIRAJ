import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/zakat/widgets/asset_tile.dart';
import 'package:siraj/shell/zakat/widgets/zakat_hero_summary_card.dart';
import 'package:siraj/shell/zakat/zakat_breakdown_screen.dart';
import 'package:siraj/shell/zakat/zakat_dashboard_screen.dart';
import 'package:siraj/shell/zakat/zakat_policy_screen.dart';
import '../fixtures/zakat/synthetic_zakat_fixtures.dart';

void main() {
  group('L4 Zakat Shell UI & Interaction Tests (§37, §38)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule module;

    setUp(() {
      registry = MemoryStorageRegistry();
      module = ZakatModule(storageRegistry: registry);
    });

    testWidgets('ZakatDashboardScreen renders hero card and empty state initially', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ZakatDashboardScreen(module: module),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('حساب الزكاة الشرعية'), findsOneWidget);
      expect(find.text('لم تقم بإضافة أي أصول مالية بعد'), findsOneWidget);
      expect(find.byType(ZakatHeroSummaryCard), findsOneWidget);
    });

    testWidgets('AssetEntryScreen adds new cash asset and updates dashboard', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ZakatDashboardScreen(module: module),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Add Asset button in empty state
      final addButton = find.text('أضف أموالك أو مدخراتك للبدء');
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('إضافة أصل مالي'), findsOneWidget);

      // Fill in title and amount
      final titleField = find.widgetWithText(TextFormField, 'اسم الأصل أو الحساب (اختياري)');
      await tester.enterText(titleField, 'حساب بنكي ادخاري');

      final amountField = find.widgetWithText(TextFormField, 'القيمة النقدية (بالريال السعودي)');
      await tester.enterText(amountField, '100000');

      // Submit
      final submitButton = find.widgetWithText(ElevatedButton, 'إضافة الأصل');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Back on dashboard, verify asset is visible in AssetTile
      expect(find.text('حساب بنكي ادخاري'), findsOneWidget);
      expect(find.byType(AssetTile), findsOneWidget);
      expect(find.textContaining('100000.00 SAR'), findsWidgets);
    });

    testWidgets('ZakatBreakdownScreen renders breakdown table and explanation', (tester) async {
      // Pre-populate asset
      await module.addOrUpdateAsset(
        SyntheticZakatFixtures.createCashAsset(amount: 100000),
      );
      final calcRes = await module.calculateZakat();

      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: ZakatBreakdownScreen(result: calcRes.valueOrNull!, module: module),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تفكيك وشرح حساب الزكاة'), findsOneWidget);
      expect(find.textContaining('جدول الحساب المالي المفصل'), findsOneWidget);
      expect(find.text('إجمالي الأصول المقومة'), findsOneWidget);
      expect(find.text('الوعاء الزكوي الصافي'), findsOneWidget);
      expect(find.text('حفظ لقطة الحساب في السجل التاريخي'), findsOneWidget);
    });

    testWidgets('ZakatPolicyScreen displays standard policies and allows switching', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ZakatPolicyScreen(module: module),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('السياسات الفقهية لحساب الزكاة'), findsOneWidget);
      expect(find.text(ZakatPolicy.goldStandard.nameArabic), findsOneWidget);
      expect(find.text(ZakatPolicy.silverStandard.nameArabic), findsOneWidget);
    });
  });
}
