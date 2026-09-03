import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Dark Mode Fidelity Suite (§18, §19, §77, §115, §124)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Dark Mode 1: Shell renders in Dark theme without exception (§18)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Dark Mode 2: Dark mode does not hide navigation tabs (§18, §77)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Dark Mode 3: Prayer tab renders in Dark mode without exception (§18, §115)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      // Use .first to disambiguate when icon appears in multiple places (IndexedStack)
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Dark Mode 4: Quran tab renders in Dark mode without exception (§18, §19)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.menu_book_rounded)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Dark Mode 5: Adhkar tab renders in Dark mode without exception (§18, §115)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.auto_stories_rounded)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
