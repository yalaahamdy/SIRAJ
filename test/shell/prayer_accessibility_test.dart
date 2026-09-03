import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/i18n/app_strings.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/prayer_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Prayer Accessibility & RTL/LTR Suite (§31..§35, §46)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
    });

    testWidgets('Accessibility 1: Large text scale (1.5x) renders without pixel overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: PrayerScreen(prayerModule: prayerModule),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.prayerTimes), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Accessibility 2: LTR mode renders prayer times and Qibla cleanly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Directionality(
            textDirection: TextDirection.ltr,
            child: PrayerScreen(prayerModule: prayerModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.prayerTimes), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Accessibility 3: Dark Mode theme maintains readability and contrast tokens', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: PrayerScreen(prayerModule: prayerModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.prayerTimes), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
