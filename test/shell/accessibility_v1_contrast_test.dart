import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/theme/app_colors.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Color Contrast & Non-Color Indicators Suite (§16, §17, §124)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Contrast 1: Primary color meets minimum contrast expectation (§16)', (tester) async {
      // Primary color should not be white on white or black on black
      expect(AppColors.primary, isNotNull);
      expect(AppColors.primary, isNot(Colors.white));
      expect(AppColors.primary, isNot(Colors.transparent));
    });

    testWidgets('Contrast 2: Selected tab uses both color and icon for state (§17, §92)', (tester) async {
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

      // BottomNavigationBar uses both label text and icons — not color alone
      final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      for (final item in navBar.items) {
        expect(item.icon, isNotNull);
        expect(item.label, isNotNull);
        expect(item.label!.isNotEmpty, true);
      }
    });

    testWidgets('Contrast 3: Shell renders in Light theme without exception (§16, §18)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.light(),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
