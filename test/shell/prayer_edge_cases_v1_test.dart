import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/prayer_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Edge Cases & High-Latitude Suite (§12, §13, §14, §24, §46, §49)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
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

    testWidgets('High Latitude location (e.g. Tromso 69.6°N) renders transparent alert banner', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(
            prayerModule: prayerModule,
            initialLocation: const GeoCoordinates(
              latitude: 69.6492, // Tromso, Norway
              longitude: 18.9553,
              source: LocationSource.manual,
            ),
            initialParameters: const CalculationParameters(
              methodProfileName: 'Muslim World League (MWL)',
              fajrAngle: 18.0,
              ishaAngle: 17.0,
              highLatitudeRule: HighLatitudeRule.middleOfTheNight,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify extreme/high latitude status alert is displayed
      expect(find.text('تنبيه خط العرض العالي أو الشروط القطبية'), findsOneWidget);
    });

    test('Midnight transition: After Isha, next prayer resolves seamlessly to tomorrow Fajr', () async {
      final nightTime = DateTime.utc(2026, 9, 1, 23, 30); // 11:30 PM (After Isha)
      final customModule = PrayerModule(
        storageRegistry: storage,
        clock: TestClock(nightTime),
      );

      final scheduleRes = await customModule.getSchedule(
        date: nightTime,
        location: const GeoCoordinates(
          latitude: 24.7136,
          longitude: 46.6753,
          source: LocationSource.manual,
        ),
        parameters: CalculationParameters.muslimWorldLeague,
      );
      expect(scheduleRes.isSuccess, isTrue);

      final sched = scheduleRes.valueOrNull!;
      final nextPrayer = customModule.scheduleService.getNextPrayer(
        currentTime: nightTime,
        todaySchedule: sched,
      );

      expect(nextPrayer, isNotNull);
      expect(nextPrayer!.type, equals(PrayerType.fajr));
    });
  });
}
