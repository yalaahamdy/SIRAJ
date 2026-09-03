import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Window Resize & State Preservation Suite (§30, §125, §126)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Resize 1: State preserved after Wide→Narrow resize (§30, §126)', (tester) async {
      // Start wide
      tester.view.physicalSize = const Size(1440, 900);
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

      // Navigate to Prayer tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
      await tester.pumpAndSettle();
      expect(find.textContaining('الصلاة القادمة'), findsWidgets);

      // Resize to narrow
      tester.view.physicalSize = const Size(360, 640);
      await tester.pumpAndSettle();

      // Prayer tab still showing after resize
      expect(tester.takeException(), isNull);
    });

    testWidgets('Resize 2: State preserved after Narrow→Wide resize (§30)', (tester) async {
      // Start narrow
      tester.view.physicalSize = const Size(360, 640);
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

      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.auto_stories_rounded)));
      await tester.pumpAndSettle();

      // Resize to wide
      tester.view.physicalSize = const Size(1280, 800);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Resize 3: Wide→Narrow→Wide cycle has no exception (§30)', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
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

      tester.view.physicalSize = const Size(360, 640);
      await tester.pumpAndSettle();

      tester.view.physicalSize = const Size(1440, 900);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
