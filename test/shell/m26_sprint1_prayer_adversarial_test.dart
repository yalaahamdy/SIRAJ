import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/methodology_disclosure.dart';
import 'package:siraj/modules/prayer/domain/prayer_adjustments.dart';
import 'package:siraj/modules/prayer/domain/prayer_schedule.dart';
import 'package:siraj/modules/prayer/domain/prayer_time_entry.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/prayer_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Prayer Adversarial & Degradation Suite (§49, §65)', () {
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

    testWidgets('Adversarial 1: Invalid coordinates out of bounds throw assertion error safely', (tester) async {
      expect(
        () => GeoCoordinates(latitude: 999.0, longitude: 999.0),
        throwsAssertionError,
      );
    });

    testWidgets('Adversarial 2: Extreme prayer adjustments enforce -60..+60 boundaries', (tester) async {
      expect(
        () => PrayerAdjustments(fajr: 100),
        throwsAssertionError,
      );

      final validAdj = const PrayerAdjustments(
        fajr: 20,
        dhuhr: -15,
        asr: 0,
        maghrib: 10,
        isha: -5,
      );
      expect(validAdj.fajr, equals(20));
      expect(validAdj.hasAnyAdjustment, isTrue);
    });

    testWidgets('Adversarial 3: Location picker gracefully rejects invalid coordinate input without crash', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(
            prayerModule: prayerModule,
            initialLocation: const GeoCoordinates(
              latitude: 24.7136,
              longitude: 46.6753,
              source: LocationSource.manual,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open location dialog
      await tester.tap(find.byIcon(Icons.location_on_outlined));
      await tester.pumpAndSettle();

      // Switch to manual input mode
      await tester.tap(find.text('إدخال يدوي'));
      await tester.pumpAndSettle();

      // Enter invalid latitude > 90
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, '999');
      await tester.pumpAndSettle();

      // Tap apply coordinates
      await tester.tap(find.text('تطبيق الإحداثيات'));
      await tester.pumpAndSettle();

      // Verify snackbar error appears and dialog stays open safely
      expect(find.textContaining('يرجى إدخال إحداثيات جغرافية صحيحة'), findsOneWidget);
    });

    test('Adversarial 4: DST Transition / Clock jump forward 1 hour does not crash countdown', () async {
      final beforeDst = DateTime.utc(2026, 3, 29, 0, 59, 50);
      final scheduleRes = await prayerModule.getSchedule(
        date: beforeDst,
        location: const GeoCoordinates(
          latitude: 51.5074, // London
          longitude: -0.1278,
          source: LocationSource.manual,
        ),
        parameters: CalculationParameters.muslimWorldLeague,
      );
      expect(scheduleRes.isSuccess, isTrue);

      final sched = scheduleRes.valueOrNull!;
      final countdown = prayerModule.countdownService.getCountdownState(
        time: beforeDst.add(const Duration(hours: 1)), // 1 hour jump
        todaySchedule: sched,
      );

      expect(countdown, isNotNull);
      expect(countdown.formattedTimer.isNotEmpty, isTrue);
    });

    test('Adversarial 5: Countdown for upcoming prayer returns deterministic remaining duration', () {
      final now = DateTime.utc(2026, 9, 1, 4, 45);
      final fajrTime = DateTime.utc(2026, 9, 1, 5, 0);
      final mockSchedule = PrayerSchedule(
        date: now,
        location: const GeoCoordinates(latitude: 24.71, longitude: 46.67),
        entries: {
          PrayerType.fajr: PrayerTimeEntry(
            type: PrayerType.fajr,
            time: fajrTime,
            originalTime: fajrTime,
          ),
        },
        disclosure: const MethodologyDisclosure(
          methodName: 'MWL',
          fajrAngle: 18.0,
          ishaAngle: 17.0,
          asrMethod: AsrJuristicMethod.shafii,
          highLatitudeRule: HighLatitudeRule.middleOfTheNight,
          location: GeoCoordinates(latitude: 24.71, longitude: 46.67),
          timezoneOffset: Duration.zero,
          adjustments: PrayerAdjustments.zero,
        ),
      );

      final countdown = prayerModule.countdownService.getCountdownState(
        time: now,
        todaySchedule: mockSchedule,
      );

      expect(countdown.nextPrayer?.type, equals(PrayerType.fajr));
      expect(countdown.remainingDuration, equals(const Duration(minutes: 15)));
      expect(countdown.formattedTimer, equals('00:15:00'));
    });
  });
}
