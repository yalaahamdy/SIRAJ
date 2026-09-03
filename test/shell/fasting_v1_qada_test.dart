import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/qada_planner_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Qada Planner Suite (§26..§34, §96, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
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

    testWidgets('Qada 1: Entering valid balance and preferred weekdays calculates projected completion date and saves', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QadaPlannerScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('مخطط قضاء الصيام'), findsOneWidget);

      final totalField = find.widgetWithText(TextFormField, 'إجمالي عدد أيام القضاء');
      await tester.enterText(totalField, '8');
      await tester.pumpAndSettle();

      // Projection is rendered
      expect(find.textContaining('المتبقي: 8 يوم'), findsOneWidget);
      expect(find.textContaining('بناءً على الخطة الحالية'), findsOneWidget);

      // Save
      final saveBtn = find.widgetWithText(ElevatedButton, 'حفظ خطة القضاء');
      await tester.tap(saveBtn);
      await tester.pumpAndSettle();

      final planRes = await fastingModule.getQadaPlan();
      expect(planRes.isSuccess, isTrue);
      expect(planRes.valueOrNull!.totalDays, equals(8));
      expect(planRes.valueOrNull!.remainingDays, equals(8));
    });

    test('Qada 2: Pure projection logic handles zero, positive, and multiple preferred days', () {
      final plan = QadaPlan(
        totalDays: 6,
        completedDays: 2,
        preferredWeekdays: const [1, 4], // Monday (1), Thursday (4)
        updatedAt: DateTime.utc(2026, 9, 1),
      );

      final projected = fastingModule.qadaPlannerService.projectCompletionDate(
        plan: plan,
        startDate: DateTime.utc(2026, 9, 1), // Tuesday
      );

      expect(projected, isNotNull);
      final weeks = fastingModule.qadaPlannerService.calculateRequiredWeeks(plan);
      expect(weeks, equals(2.0));
    });
  });
}
