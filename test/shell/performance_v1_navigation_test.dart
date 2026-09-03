import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Navigation Performance Suite (§95, §119, §123)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Navigation Perf 1: Full 5-tab round trip completes without exception (§95, §119)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      for (final icon in [
        Icons.access_time_filled_rounded,
        Icons.menu_book_rounded,
        Icons.auto_stories_rounded,
        Icons.grid_view_rounded,
        Icons.home_rounded,
      ]) {
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
        await tester.pumpAndSettle();
      }

      stopwatch.stop();

      // 5-tab round trip in test env must complete under 30000ms in debug test runner
      expect(stopwatch.elapsedMilliseconds, lessThan(30000));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Navigation Perf 2: Repeated tab switching 10 times is stable (§95, §96)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
        await tester.pumpAndSettle();
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.home_rounded)));
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
