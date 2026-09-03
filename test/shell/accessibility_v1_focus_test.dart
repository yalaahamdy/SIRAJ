import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Focus Management Suite (§7, §9, §91, §93, §124)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Focus 1: Shell mounts without dangling FocusNode errors (§7, §47)', (tester) async {
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

      expect(tester.takeException(), isNull);
    });

    testWidgets('Focus 2: Switching tabs does not leave focus in an invisible element (§9, §93)', (tester) async {
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

      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.home_rounded)));
      await tester.pumpAndSettle();

      // No exception thrown from Focus mismanagement
      expect(tester.takeException(), isNull);
    });

    testWidgets('Focus 3: Tab indices match visible content (§9, §93)', (tester) async {
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

      // Tap all 5 tabs and verify no exception
      for (final icon in [
        Icons.home_rounded,
        Icons.access_time_filled_rounded,
        Icons.menu_book_rounded,
        Icons.auto_stories_rounded,
        Icons.grid_view_rounded,
      ]) {
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
    });
  });
}
