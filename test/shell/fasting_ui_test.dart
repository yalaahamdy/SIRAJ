import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/fasting_calendar_screen.dart';
import 'package:siraj/shell/fasting/fasting_dashboard_screen.dart';
import 'package:siraj/shell/fasting/fasting_settings_screen.dart';
import 'package:siraj/shell/fasting/qada_planner_screen.dart';
import 'package:siraj/shell/fasting/widgets/qada_balance_card.dart';
import 'package:siraj/shell/fasting/widgets/today_fasting_hero_card.dart';

void main() {
  group('L4 Fasting Shell UI & Interaction Tests (§40, §41)', () {
    late MemoryStorageRegistry registry;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: registry);
      fastingModule = FastingModule(storageRegistry: registry, prayerModule: prayerModule);
    });

    testWidgets('FastingDashboardScreen renders hero card and Qada card', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FastingDashboardScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الصيام ورمضان المبارك'), findsOneWidget);
      expect(find.byType(TodayFastingHeroCard), findsOneWidget);
      expect(find.byType(QadaBalanceCard), findsOneWidget);
      expect(find.text('سجل الأيام الأخيرة'), findsOneWidget);
    });

    testWidgets('Tapping Fasting action button records today fast status', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FastingDashboardScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      final fastButton = find.text('تسجيل صيام اليوم');
      expect(fastButton, findsOneWidget);
      await tester.tap(fastButton);
      await tester.pumpAndSettle();

      expect(find.text('تم تسجيل صيام اليوم بنجاح'), findsOneWidget);

      final records = await fastingModule.getDayRecords();
      expect(records.valueOrNull!.length, equals(1));
      expect(records.valueOrNull!.first.status, equals(FastingStatus.fasted));
    });

    testWidgets('QadaPlannerScreen updates and saves Qada plan', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QadaPlannerScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مخطط قضاء الصيام'), findsOneWidget);

      // Enter total days
      final totalField = find.widgetWithText(TextFormField, 'إجمالي عدد أيام القضاء');
      await tester.enterText(totalField, '10');

      // Submit
      final submitButton = find.widgetWithText(ElevatedButton, 'حفظ خطة القضاء');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      final plan = await fastingModule.getQadaPlan();
      expect(plan.valueOrNull!.totalDays, equals(10));
    });

    testWidgets('FastingCalendarScreen renders records list', (tester) async {
      await fastingModule.markTodayStatus(
        type: FastingType.voluntary,
        status: FastingStatus.fasted,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: FastingCalendarScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سجل وتقويم الصيام'), findsOneWidget);
      expect(find.textContaining('صيام تطوع'), findsOneWidget);
      expect(find.text('تم الصيام'), findsOneWidget);
    });

    testWidgets('FastingSettingsScreen allows switching policy', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FastingSettingsScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('إعدادات وسياسات الصيام'), findsOneWidget);
      expect(find.textContaining('السياسة القياسية'), findsOneWidget);
      expect(find.textContaining('سياسة الإمساك الاحتياطي'), findsOneWidget);
    });
  });
}
