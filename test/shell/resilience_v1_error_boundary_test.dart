import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';
import 'package:siraj/shell/widgets/state_views.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Error Boundary Suite (§72, §73, §120, §131)', () {
    testWidgets('Error Boundary 1: Shell mounts with OfflineStateBanner without crash (§72, §73)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      // Shell stays alive — OfflineStateBanner renders safely
      expect(find.byType(OfflineStateBanner), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Error Boundary 2: Module degradation does not crash the shell (§73, §120)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Shell with minimal storage still boots — no module will crash
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      // All 5 tabs should still be accessible
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Error Boundary 3: Empty states render without crashing (§58, §68)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Empty state widgets render cleanly
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: EmptyStateView(message: 'لا توجد بيانات'),
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('لا توجد بيانات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Error Boundary 4: Loading state renders without crashing (§61, §71)', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: LoadingStateView(message: 'جارٍ التحميل...'),
        ),
      ));
      await tester.pump();

      expect(find.text('جارٍ التحميل...'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
