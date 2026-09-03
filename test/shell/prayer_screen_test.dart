import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/i18n/app_strings.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/prayer_screen.dart';
import 'package:siraj/shell/prayer/prayer_settings_screen.dart';

void main() {
  group('L4 PrayerScreen Widget & Interaction Tests (§25, §26)', () {
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

    testWidgets('Renders all prayer components (Next Hero, Daily List, Qibla, Disclosure)', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(prayerModule: prayerModule),
        ),
      );
      await tester.pumpAndSettle();

      // Verify title & Hero
      expect(find.text(AppStrings.prayerTimes), findsWidgets);
      expect(find.textContaining('الصلاة القادمة:'), findsOneWidget);

      // Verify obligatory prayer names
      expect(find.text(PrayerType.fajr.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.dhuhr.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.asr.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.maghrib.nameArabic), findsOneWidget);
      expect(find.text(PrayerType.isha.nameArabic), findsOneWidget);

      // Verify Qibla & Disclosure
      expect(find.text(AppStrings.qiblaDirection), findsOneWidget);
      expect(find.text(AppStrings.assumptionsDisclosure), findsOneWidget);
    });

    testWidgets('Tapping tracking button logs prayer status locally', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(prayerModule: prayerModule),
        ),
      );
      await tester.pumpAndSettle();

      // Find check icon button for Fajr
      final checkIcons = find.byIcon(Icons.check_circle_outline);
      expect(checkIcons, findsWidgets);

      // Tap first check button
      await tester.tap(checkIcons.first);
      await tester.pumpAndSettle();

      // Icon should become solid check_circle
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Tapping settings icon opens PrayerSettingsScreen', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(prayerModule: prayerModule),
        ),
      );
      await tester.pumpAndSettle();

      // Tap tune icon in AppBar
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      // Verify settings screen is opened
      expect(find.byType(PrayerSettingsScreen), findsOneWidget);
      expect(find.text('إعدادات الصلاة والحساب'), findsOneWidget);
      expect(find.text('طريقة الحساب المعتمدة'), findsOneWidget);
    });
  });
}
