import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/qada_plan.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/fasting_dashboard_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting Accessibility Suite (§59, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);

      await fastingModule.updateQadaPlan(QadaPlan(
        totalDays: 5,
        completedDays: 1,
        preferredWeekdays: const [1, 4],
        updatedAt: DateTime.utc(2026, 9, 1),
      ));
    });

    Widget createAccessibleApp(Widget child, {double textScale = 1.5}) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: child,
        ),
      );
    }

    testWidgets('Accessibility 1: Dashboard renders without overflow at 1.5x font scale', (tester) async {
      await tester.pumpWidget(
        createAccessibleApp(
          FastingDashboardScreen(module: fastingModule),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الصيام ورمضان المبارك'), findsOneWidget);
    });
  });
}
