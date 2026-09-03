import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Landscape Orientation Suite (§24, §117, §125)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Landscape 1: Shell renders in landscape 812x375 without overflow (§24)', (tester) async {
      tester.view.physicalSize = const Size(812, 375);
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
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Landscape 2: Prayer tab renders in landscape without overflow (§24)', (tester) async {
      tester.view.physicalSize = const Size(812, 375);
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

      expect(tester.takeException(), isNull);
    });

    testWidgets('Landscape 3: Quran tab renders in landscape without overflow (§24)', (tester) async {
      tester.view.physicalSize = const Size(812, 375);
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

      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.menu_book_rounded)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Landscape 4: Adhkar tab renders in landscape without overflow (§24)', (tester) async {
      tester.view.physicalSize = const Size(812, 375);
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

      expect(tester.takeException(), isNull);
    });
  });
}
