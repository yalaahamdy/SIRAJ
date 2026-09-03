import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/i18n/app_strings.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/routing/app_router.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Golden Journeys Vertical Slice Suite (§45, §46, §47, §48, §56)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Golden Journey 1: Home Command Center -> Prayer Full Schedule', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.generateRoute,
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: storage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Home shows Prayer chip in Quick Modules
      expect(find.text('الصلاة والقبلة'), findsWidgets);

      // Tap Prayer Tab in bottom nav
      final prayerNavFinder = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.access_time_filled_rounded),
      );
      await tester.tap(prayerNavFinder);
      await tester.pumpAndSettle();

      // Verified Prayer Screen Schedule is loaded
      expect(find.textContaining('الصلاة القادمة'), findsWidgets);
      expect(find.text(AppStrings.prayerTimes), findsWidgets);
      expect(find.text(AppStrings.qiblaDirection), findsOneWidget);
    });

    testWidgets('Golden Journey 2: Home -> Quran Surah List & Reader Entry', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.generateRoute,
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: storage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Quran tab in bottom nav
      final quranNavFinder = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.menu_book_rounded),
      );
      await tester.tap(quranNavFinder);
      await tester.pumpAndSettle();

      expect(find.text('السور'), findsOneWidget);
      expect(find.text('الأجزاء'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget); // Search bar
    });

    testWidgets('Golden Journey 3: Home -> Adhkar Categories & Counter Door', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.generateRoute,
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: storage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Adhkar tab in bottom nav
      final adhkarNavFinder = find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.auto_stories_rounded),
      );
      await tester.tap(adhkarNavFinder);
      await tester.pumpAndSettle();

      expect(find.text('الأذكار والأدعية'), findsWidgets);
      expect(find.text('المناسبة الحالية'), findsOneWidget);
      expect(find.text('أبواب الأذكار والمناسبات'), findsOneWidget);
    });
  });
}
