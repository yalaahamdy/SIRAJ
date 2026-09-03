import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Accessibility & Semantics Suite (§57..§60, §96)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());
    });

    testWidgets('Accessibility 1: 1.5x Text scaling renders cleanly in DhikrDetailScreen without overflow', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final item = module.getAllItems().valueOrNull!.first;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: DhikrDetailScreen(item: item, module: module),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('توثيق وتخريج الذكر'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Accessibility 2: Dark mode theme preserves contrast in AdhkarHomeScreen', (tester) async {
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
            child: AdhkarHomeScreen(module: module),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الأبواب والمناسبات'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
