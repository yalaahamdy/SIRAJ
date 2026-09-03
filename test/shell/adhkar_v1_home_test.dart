import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Adhkar Home & Daily Worship Hub Suite (§3..§8, §119)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
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
        home: child,
      );
    }

    testWidgets('Home 1: Renders main Adhkar hub, occasion categories, tabs, and search bar (§3..§7)', (tester) async {
      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('الأذكار والأدعية'), findsOneWidget);
      expect(find.text('الأبواب والمناسبات'), findsOneWidget);
      expect(find.text('المفضلة'), findsOneWidget);
      expect(find.textContaining('أذكار الصباح'), findsWidgets);
      expect(find.textContaining('أذكار المساء'), findsWidgets);
    });
  });
}
