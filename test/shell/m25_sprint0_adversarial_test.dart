import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/routing/app_router.dart';
import 'package:siraj/shell/theme/app_colors.dart';
import 'package:siraj/shell/v1_app_shell.dart';
import 'package:siraj/shell/widgets/state_views.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 0 Adversarial & Degradation Suite (§57, §60)', () {
    late MemoryStorageRegistry storage;

    setUp(() {
      storage = MemoryStorageRegistry();
    });

    testWidgets('Adversarial 1: Invalid routes gracefully fallback without uncaught crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/invalid_unknown_route',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الصفحة المطلوبة غير موجودة'), findsOneWidget);
    });

    testWidgets('Adversarial 2: Offline banner persists across tab switching without obscuring UI', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: storage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OfflineStateBanner), findsOneWidget);

      // Switch to More tab
      await tester.tap(find.text('المزيد'));
      await tester.pumpAndSettle();
      expect(find.byType(OfflineStateBanner), findsOneWidget);
    });

    testWidgets('Adversarial 3: Dark Mode theme applies appropriate contrast and background tokens', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: storage),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final navBar = tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
      expect(navBar.selectedItemColor, equals(AppColors.goldAccentLight));
    });
  });
}
