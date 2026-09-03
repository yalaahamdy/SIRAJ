import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/fasting_dashboard_screen.dart';
import 'package:siraj/shell/fasting/widgets/qada_balance_card.dart';
import 'package:siraj/shell/fasting/widgets/today_fasting_hero_card.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting Dashboard Suite (§3..§14, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);
      await fastingModule.updateQadaPlan(QadaPlan(
        totalDays: 7,
        completedDays: 2,
        preferredWeekdays: const [1, 4],
        updatedAt: DateTime.utc(2026, 9, 1),
      ));
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

    testWidgets('Dashboard 1: Renders Today Hijri header, schedule boundary countdown, Qada card, and actions', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          FastingDashboardScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الصيام ورمضان المبارك'), findsOneWidget);
      expect(find.byType(TodayFastingHeroCard), findsOneWidget);
      expect(find.byType(QadaBalanceCard), findsOneWidget);
      expect(find.text('سجل الأيام الأخيرة'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });
}
