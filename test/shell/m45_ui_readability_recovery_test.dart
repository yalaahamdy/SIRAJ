import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/theme/app_colors.dart';
import 'package:siraj/shell/theme/app_typography.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('M45: UI Readability, Contrast & Responsive Recovery Tests (§20)', () {
    testWidgets('AppColors provides high-contrast semantic roles for light and dark themes', (tester) async {
      await tester.pumpWidget(
        Theme(
          data: ThemeData(brightness: Brightness.light),
          child: Builder(
            builder: (context) {
              // Light Mode verification
              expect(AppColors.primaryText(context), equals(AppColors.textPrimaryLight));
              expect(AppColors.secondaryText(context), equals(AppColors.textSecondaryLight));
              expect(AppColors.surface(context), equals(AppColors.surfaceLight));
              expect(AppColors.cardBackground(context), equals(AppColors.surfaceLight));
              expect(AppColors.primaryAction(context), equals(AppColors.primary));
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        Theme(
          data: ThemeData(brightness: Brightness.dark),
          child: Builder(
            builder: (context) {
              // Dark Mode verification
              expect(AppColors.primaryText(context), equals(AppColors.textPrimaryDark));
              expect(AppColors.secondaryText(context), equals(AppColors.textSecondaryDark));
              expect(AppColors.surface(context), equals(AppColors.surfaceDark));
              expect(AppColors.cardBackground(context), equals(AppColors.surfaceDark));
              expect(AppColors.primaryAction(context), equals(AppColors.goldAccentLight));
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    test('AppTypography maintains strict separation between generic Arabic and Quran font', () {
      expect(AppTypography.arabicFontFamily, equals('Cairo'));
      expect(AppTypography.quranFontFamily, equals('Amiri'));

      final display = AppTypography.displayLarge(false);
      final sacred = AppTypography.sacredText(false);

      expect(display.fontFamily, equals('Cairo'));
      expect(sacred.fontFamily, equals('Amiri'));
      expect(sacred.height, greaterThanOrEqualTo(1.5));
    });

    testWidgets('V1AppShell renders smoothly without overflow at 360x800 in Light Mode', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('الصلاة'), findsOneWidget);
      expect(find.text('المصحف'), findsOneWidget);
      expect(find.text('الأذكار'), findsOneWidget);
      expect(find.text('المزيد'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('V1AppShell renders smoothly in Dark Mode without color conflicts', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(navBar.selectedItemColor, equals(AppColors.goldAccentLight));
      expect(tester.takeException(), isNull);
    });

    testWidgets('V1AppShell handles 200% large accessibility text scaling without RenderFlex overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
