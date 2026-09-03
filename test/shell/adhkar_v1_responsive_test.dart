import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Responsive Form Factors Suite (§61, §97)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      );
    }

    testWidgets('Responsive 1: Small Phone (360x640) renders DhikrDetailScreen without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final item = module.getAllItems().valueOrNull!.first;
      await tester.pumpWidget(createTestApp(DhikrDetailScreen(item: item, module: module)));
      await tester.pumpAndSettle();

      expect(find.text('توثيق وتخريج الذكر'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 2: Large Tablet (800x1280) centers content cleanly', (tester) async {
      tester.view.physicalSize = const Size(800, 1280);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('الأبواب والمناسبات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Responsive 3: Desktop Landscape (1200x800) renders grid gracefully', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('الأبواب والمناسبات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
