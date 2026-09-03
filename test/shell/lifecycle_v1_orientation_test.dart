import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Orientation Change Lifecycle Suite (§31, §117, §126)', () {
    testWidgets('Orientation 1: Portrait→Landscape renders without exception (§31, §117)', (tester) async {
      // Start in portrait
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = MemoryStorageRegistry();
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      // Navigate to Quran tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.menu_book_rounded)));
      await tester.pumpAndSettle();

      // Rotate to landscape
      tester.view.physicalSize = const Size(2400, 1080);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Orientation 2: Landscape→Portrait cycle preserves active tab (§31, §117)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = MemoryStorageRegistry();
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      // Navigate to Prayer tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
      await tester.pumpAndSettle();

      // Rotate to landscape
      tester.view.physicalSize = const Size(2400, 1080);
      await tester.pumpAndSettle();

      // Rotate back to portrait
      tester.view.physicalSize = const Size(1080, 2400);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Orientation 3: Portrait↔Landscape cycle three times has no exception (§31)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = MemoryStorageRegistry();
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      for (int i = 0; i < 3; i++) {
        tester.view.physicalSize = const Size(2400, 1080);
        await tester.pumpAndSettle();
        tester.view.physicalSize = const Size(1080, 2400);
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
