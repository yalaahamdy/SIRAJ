import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/config/app_config.dart';
import 'package:siraj/core/i18n/locale_manager.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/siraj_app.dart';
import 'package:siraj/shell/v1_app_shell.dart';
import 'package:siraj/shell/widgets/state_views.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 0: App Shell & 5-Tab Navigation Suite (§6, §13, §14, §56)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('V1AppShell bootstraps cleanly with all 5 navigation tabs', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: storage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify all 5 tab labels in bottom navigation bar
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الصلاة'), findsOneWidget);
      expect(find.text('المصحف'), findsOneWidget);
      expect(find.text('الأذكار'), findsOneWidget);
      expect(find.text('المزيد'), findsOneWidget);

      // Verify top offline state banner is present and active
      expect(find.byType(OfflineStateBanner), findsOneWidget);

      // Verify default home dashboard is visible (Index 0)
      expect(find.text('الروتين اليومي المتوازن'), findsOneWidget);
    });

    testWidgets('Tapping bottom tabs switches between Prayer, Quran, Adhkar, and More views', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: storage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Tab 1: Prayer
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.access_time_filled_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('الصلاة القادمة'), findsWidgets);

      // Switch to Tab 2: Quran
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.menu_book_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('السور'), findsOneWidget);
      expect(find.text('الأجزاء'), findsOneWidget);

      // Switch to Tab 3: Adhkar
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.auto_stories_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('الأذكار والأدعية'), findsWidgets);
      expect(find.text('المناسبة الحالية'), findsOneWidget);

      // Switch to Tab 4: More
      await tester.tap(
        find.descendant(
          of: find.byType(BottomNavigationBar),
          matching: find.byIcon(Icons.grid_view_rounded),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('منظومة المعرفة الإسلامية'), findsOneWidget);
      expect(find.text('مسارات التعلم المنهجي'), findsOneWidget);
    });

    testWidgets('SirajApp root bootstrapping connects directly to V1AppShell', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final config = AppConfig.test();
      final localeManager = LocaleManager();

      await tester.pumpWidget(
        SirajApp(
          config: config,
          localeManager: localeManager,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(V1AppShell), findsOneWidget);
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الصلاة'), findsOneWidget);
    });
  });
}
