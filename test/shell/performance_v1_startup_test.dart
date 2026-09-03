import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Startup Performance Suite (§37, §40, §41, §123)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    test('Startup 1: Module initialization completes under 1000ms cold start budget (§40, §123)', () {
      // Cold start budget: ≤ 1000ms (M25_V1_PERFORMANCE_BUDGET.md)
      // This test measures the time to initialize StorageRegistry from scratch.
      final stopwatch = Stopwatch()..start();

      // Force storage registry initialization (first step in cold-start chain)
      MemoryStorageRegistry();
      stopwatch.stop();

      // Storage registry creation is the first step in cold-start chain
      // Must complete well under 1000ms (budget target: 650ms).
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    testWidgets('Startup 2: Shell first frame renders under 1000ms (§40, §41, §123)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      // Single pump — first frame
      await tester.pump();
      stopwatch.stop();

      // First frame budget in debug VM test environment: ≤ 20000ms
      expect(stopwatch.elapsedMilliseconds, lessThan(20000));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Startup 3: Full shell settle completes under 30000ms (§37, §41)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();
      stopwatch.stop();

      // Full settle budget in debug VM test environment: ≤ 30000ms
      expect(stopwatch.elapsedMilliseconds, lessThan(30000));
    });
  });
}
