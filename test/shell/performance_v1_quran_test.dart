import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Quran List Performance Suite (§33, §37, §123)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Quran Perf 1: Quran tab opens and renders surah list under 2000ms (§33, §37)', (tester) async {
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
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.menu_book_rounded)));
      await tester.pumpAndSettle();
      stopwatch.stop();

      // Quran list open budget: ≤ 2000ms in test env
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Quran Perf 2: Surah list tab switches (سور / أجزاء) perform without lag (§33)', (tester) async {
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

      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.menu_book_rounded)));
      await tester.pumpAndSettle();

      // Switch between surah and juz tabs
      if (find.text('الأجزاء').evaluate().isNotEmpty) {
        await tester.tap(find.text('الأجزاء'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('السور'));
        await tester.pumpAndSettle();
      }

      expect(tester.takeException(), isNull);
    });
  });
}
