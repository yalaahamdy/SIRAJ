import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/fasting/domain/fasting_status.dart';
import 'package:siraj/modules/fasting/domain/fasting_type.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/fasting/fasting_calendar_screen.dart';
import 'package:siraj/shell/fasting/widgets/fasting_day_tile.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 5: Fasting Calendar & Month Navigation Suite (§15..§25, §100)', () {
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
        note: 'صيام يوم الاثنين المبارك',
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

    testWidgets('Calendar 1: Renders Hijri month navigation, records list, and tiles', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          FastingCalendarScreen(module: fastingModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سجل وتقويم الصيام'), findsOneWidget);
      expect(find.byType(FastingDayTile), findsOneWidget);
      expect(find.textContaining('صيام تطوع'), findsOneWidget);
      expect(find.text('تم الصيام'), findsOneWidget);

      // Month navigation buttons exist
      expect(find.byTooltip('الشهر السابق'), findsOneWidget);
      expect(find.byTooltip('الشهر القادم'), findsOneWidget);

      await tester.tap(find.byTooltip('الشهر السابق'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('الشهر القادم'));
      await tester.pumpAndSettle();
    });
  });
}
