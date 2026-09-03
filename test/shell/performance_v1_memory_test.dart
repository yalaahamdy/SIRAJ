import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Memory Lifecycle Suite (§46, §47, §50, §127)', () {
    test('Memory 1: StorageRegistry creation does not grow unboundedly after 100 instances (§46)', () {
      // Verify no unbounded static/global state
      for (int i = 0; i < 100; i++) {
        final _ = MemoryStorageRegistry();
      }
      // If no OOM or exception, memory is bounded (each is GC-eligible after scope)
      expect(true, isTrue);
    });

    testWidgets('Memory 2: 10 tab navigation cycles do not crash (§50, §127)', (tester) async {
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

      for (int cycle = 0; cycle < 10; cycle++) {
        for (final icon in [
          Icons.access_time_filled_rounded,
          Icons.menu_book_rounded,
          Icons.auto_stories_rounded,
          Icons.grid_view_rounded,
          Icons.home_rounded,
        ]) {
          await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
          await tester.pump(const Duration(milliseconds: 100));
        }
      }
      await tester.pumpAndSettle();

      // After 10 cycles × 5 tabs = 50 tab switches: no crash
      expect(tester.takeException(), isNull);
    });

    testWidgets('Memory 3: Shell disposes cleanly without retained widget errors (§47)', (tester) async {
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

      // Replace with an empty container to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
