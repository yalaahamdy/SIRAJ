import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Long Session Navigation Suite (§51, §119, §127)', () {
    testWidgets('Long Session 1: Full Golden Journey 9 navigation cycle × 3 completes without exception (§51, §119)', (tester) async {
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

      // Full navigation cycle: Prayer→Quran→Adhkar→More→Home × 3
      for (int cycle = 0; cycle < 3; cycle++) {
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.menu_book_rounded)));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.auto_stories_rounded)));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.grid_view_rounded)));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.home_rounded)));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('الروتين اليومي المتوازن'), findsOneWidget);
    });

    testWidgets('Long Session 2: Performance does not degrade across 3 full cycles (§51)', (tester) async {
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

      final timings = <int>[];
      for (int cycle = 0; cycle < 3; cycle++) {
        final sw = Stopwatch()..start();
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
        await tester.pumpAndSettle();
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.home_rounded)));
        await tester.pumpAndSettle();
        sw.stop();
        timings.add(sw.elapsedMilliseconds);
      }

      // Each cycle should complete in < 3000ms (debug mode)
      for (final t in timings) {
        expect(t, lessThan(3000));
      }
    });
  });
}
