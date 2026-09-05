import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/routing/app_router.dart';
import 'package:siraj/shell/zakat/currency_picker_bottom_sheet.dart';
import 'package:siraj/shell/zakat/zakat_calculator_workflow_screen.dart';
import 'package:siraj/shell/zakat/zakat_dashboard_screen.dart';
import 'package:siraj/shell/zakat/zakat_history_screen.dart';
import 'package:siraj/shell/zakat/zakat_settings_screen.dart';

void main() {
  group('Zakat Shell & Screens Integration Tests (§3, §37)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule module;

    setUp(() {
      registry = MemoryStorageRegistry();
      module = ZakatModule(storageRegistry: registry);
      AppRouter.defaultZakatModule = module;
    });

    Widget createTestApp(Widget home) {
      return MaterialApp(
        home: home,
        locale: const Locale('ar'),
      );
    }

    testWidgets('ZakatDashboardScreen renders title "زكاتي" and EGP badge', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatDashboardScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('زكاتي'), findsOneWidget);
      expect(find.text('الجنيه المصري (ج.م)'), findsOneWidget);
      expect(find.text('حاسبة الزكاة'), findsOneWidget);
      expect(find.text('إعدادات النصاب'), findsOneWidget);
      expect(find.text('السجل'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('تقسيم الثروة والأموال'), 100);
      expect(find.text('تقسيم الثروة والأموال'), findsOneWidget);
    });

    testWidgets('ZakatSettingsScreen displays EGP as default currency and Nisab options', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatSettingsScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('إعدادات الزكاة والعملة'), findsOneWidget);
      expect(find.text('عملة الحساب والعرض'), findsOneWidget);
      expect(find.text('الجنيه المصري'), findsOneWidget);
      expect(find.text('الافتراضية'), findsOneWidget);
      expect(find.text('طريقة ومعيار النصاب الشرعي'), findsOneWidget);
      expect(find.text('الذهب (85 جرام)'), findsOneWidget);
      expect(find.text('الفضة (595 جرام)'), findsOneWidget);
    });

    testWidgets('CurrencyPickerBottomSheet filters and displays 11 currencies', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Scaffold(
            body: CurrencyPickerBottomSheet(
              selectedCurrencyCode: 'EGP',
              onCurrencySelected: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('اختر عملة الحساب والعرض'), findsOneWidget);
      expect(find.text('الجنيه المصري'), findsOneWidget);
      expect(find.text('الريال السعودي'), findsOneWidget);
      expect(find.text('الدولار الأمريكي'), findsOneWidget);

      // Search filter
      await tester.enterText(find.byType(TextField), 'كويتي');
      await tester.pumpAndSettle();

      expect(find.text('الدينار الكويتي'), findsOneWidget);
      expect(find.text('الجنيه المصري'), findsNothing);
    });

    testWidgets('ZakatCalculatorWorkflowScreen navigates between steps', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatCalculatorWorkflowScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('حاسبة الزكاة المنظمة'), findsOneWidget);
      expect(find.text('معايير الحساب الحالية'), findsOneWidget);

      // Tap Next Step
      await tester.tap(find.text('المتابعة للخطوة التالية'));
      await tester.pumpAndSettle();

      expect(find.textContaining('الأصول المسجلة'), findsOneWidget);
    });

    testWidgets('ZakatHistoryScreen renders empty state when no snapshots exist', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatHistoryScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('سجل حسابات الزكاة السابقة'), findsOneWidget);
      expect(find.text('لا توجد عمليات زكوية محفوظة في السجل'), findsOneWidget);
    });

    testWidgets('AppRouter deep links route to new Zakat screens', (tester) async {
      final app = MaterialApp(
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.zakatSettings,
      );

      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      expect(find.byType(ZakatSettingsScreen), findsOneWidget);
    });
  });
}
