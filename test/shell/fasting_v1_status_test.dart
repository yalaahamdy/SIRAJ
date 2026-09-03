import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/fasting_dashboard_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Today Fasting Status & Toggle Suite (§4..§11, §100)', () {
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

    testWidgets('Status 1: Toggling today fasting updates status and saves local record', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          FastingDashboardScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state: not marked
      final toggleBtn = find.text('تسجيل صيام اليوم');
      expect(toggleBtn, findsOneWidget);

      await tester.tap(toggleBtn);
      await tester.pumpAndSettle();

      // Marked as fasted
      expect(find.text('تم تسجيل صيام اليوم بنجاح'), findsOneWidget);

      final recordsRes = await fastingModule.getDayRecords();
      expect(recordsRes.isSuccess, isTrue);
      expect(recordsRes.valueOrNull!.length, equals(1));
      expect(recordsRes.valueOrNull!.first.status, equals(FastingStatus.fasted));
    });
  });
}
