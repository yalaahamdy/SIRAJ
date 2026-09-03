import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/fasting_dashboard_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: State Interruption & Resume Suite (§68..§70, §100)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;
    late FastingModule fastingModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
      fastingModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);

      await fastingModule.markTodayStatus(
        type: FastingType.voluntary,
        status: FastingStatus.fasted,
      );
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

    testWidgets('Resume 1: App launch after process restart retains recorded status', (tester) async {
      // First mount
      await tester.pumpWidget(
        createTestApp(
          FastingDashboardScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تم تسجيل صيام اليوم بنجاح'), findsOneWidget);

      // Simulate restart with new module instance on same storage
      final newModule = FastingModule(storageRegistry: storage, prayerModule: prayerModule);

      await tester.pumpWidget(
        createTestApp(
          FastingDashboardScreen(module: newModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تم تسجيل صيام اليوم بنجاح'), findsOneWidget);
    });
  });
}
