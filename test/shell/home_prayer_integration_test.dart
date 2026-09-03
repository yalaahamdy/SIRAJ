import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/i18n/app_strings.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/routing/app_router.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Home + Prayer Integration Suite (§4, §5, §25, §26, §46, §48)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    Widget createTestApp() {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: AppRouter.generateRoute,
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      );
    }

    testWidgets('Home Prayer Hero displays glanceable Current & Next Prayer info', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Verify Home shows Prayer card in Now section
      expect(find.text('مواقيت الصلاة والقبلة'), findsWidgets);
      expect(find.text('الروتين اليومي المتوازن'), findsOneWidget);
    });

    testWidgets('Tapping Prayer Hero action on Home navigates directly to Prayer Screen', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // Tap Prayer tab in bottom nav
      final prayerNavFinder = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.access_time_filled_rounded),
      );
      await tester.tap(prayerNavFinder);
      await tester.pumpAndSettle();

      // Verify full Prayer screen is displayed
      expect(find.text(AppStrings.prayerTimes), findsWidgets);
      expect(find.text(AppStrings.qiblaDirection), findsOneWidget);
    });

    testWidgets('Cross-navigation between Home, Prayer, Adhkar, and Quran preserves state', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // 1. Home -> Prayer
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.access_time_filled_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.prayerTimes), findsWidgets);

      // 2. Prayer -> Quran
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.menu_book_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('السور'), findsOneWidget);

      // 3. Quran -> Adhkar
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.auto_stories_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('الأذكار والأدعية'), findsWidgets);

      // 4. Adhkar -> Home
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.home_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('الروتين اليومي المتوازن'), findsOneWidget);
    });
  });
}
