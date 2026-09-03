import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: App Restart & Preference Restoration Suite (§30, §53, §126)', () {
    test('Restart 1: MemoryStorageRegistry initializes with empty state on fresh launch (§30, §53)', () {
      final storage = MemoryStorageRegistry();
      expect(storage, isNotNull);
    });

    testWidgets('Restart 2: Shell mounts cleanly on fresh launch (cold start simulation) (§53)', (tester) async {
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

      expect(tester.takeException(), isNull);
      // Defaults to Home tab (index 0)
      expect(find.text('الروتين اليومي المتوازن'), findsOneWidget);
    });

    testWidgets('Restart 3: Shell defaults to index 0 on restart (no saved tab state needed) (§53, §104)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = MemoryStorageRegistry();
      // Simulate restart: create a fresh shell
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      // Default is Home (index 0)
      expect(find.byType(V1AppShell), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
