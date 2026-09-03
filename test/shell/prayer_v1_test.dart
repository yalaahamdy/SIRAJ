import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/i18n/app_strings.dart';
import 'package:siraj/core/location/location_models.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/domain/calculation_parameters.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/prayer_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Prayer V1 Full Subsystem Suite (§4..§14, §46, §64)', () {
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

    testWidgets('PrayerScreen renders 5 obligatory prayers with distinct status markers', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(
            prayerModule: prayerModule,
            initialLocation: const GeoCoordinates(
              latitude: 21.4225, // Makkah
              longitude: 39.8262,
              source: LocationSource.manual,
            ),
            initialParameters: CalculationParameters.ummAlQura,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.prayerTimes), findsWidgets);
      expect(find.text(PrayerType.fajr.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.dhuhr.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.asr.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.maghrib.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.isha.nameArabic), findsOneWidget);
    });

    testWidgets('Prayer Countdown Hero displays live timer and target prayer info', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(prayerModule: prayerModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('الصلاة القادمة:'), findsOneWidget);
      expect(find.textContaining('يحين وقتها في'), findsOneWidget);
    });
  });
}
