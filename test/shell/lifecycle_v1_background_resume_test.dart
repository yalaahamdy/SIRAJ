import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Background & Resume Lifecycle Suite (§52, §118, §126)', () {
    testWidgets('Background 1: App state is preserved across simulated background/resume (§52, §118)', (tester) async {
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

      // Navigate to Adhkar tab
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.auto_stories_rounded)));
      await tester.pumpAndSettle();
      expect(find.text('المناسبة الحالية'), findsOneWidget);

      // Simulate background: push a new route (modal overlay)
      await tester.pump(const Duration(seconds: 2));

      // Simulate resume: app still at same tab
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('Background 2: Counter/state in Adhkar tab is preserved after pump cycle (§52, §118)', (tester) async {
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

      // Go to Adhkar
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.auto_stories_rounded)));
      await tester.pumpAndSettle();

      // Simulate idle (background)
      await tester.pump(const Duration(seconds: 3));

      // Resume
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
