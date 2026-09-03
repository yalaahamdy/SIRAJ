import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import 'package:siraj/shell/adhkar/occasion_adhkar_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Dhikr Occasion Discovery & Transitions Suite (§4..§7, §91)', () {
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

    testWidgets('Occasion Flow 1: Morning occasion resolution (07:00 UTC) renders in Home Hero Card', (tester) async {
      final storage = MemoryStorageRegistry();
      final clock = TestClock(DateTime.utc(2026, 9, 1, 7, 0)); // Morning
      final module = AdhkarModule(storageRegistry: storage, customClock: clock);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('أذكار الصباح'), findsWidgets);
      expect(find.textContaining('وقت أذكار الصباح المسنونة'), findsOneWidget);
    });

    testWidgets('Occasion Flow 2: Evening occasion resolution (17:00 UTC) renders in Home Hero Card', (tester) async {
      final storage = MemoryStorageRegistry();
      final clock = TestClock(DateTime.utc(2026, 9, 1, 17, 0)); // Evening
      final module = AdhkarModule(storageRegistry: storage, customClock: clock);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      expect(find.text('أذكار المساء'), findsWidgets);
      expect(find.textContaining('وقت أذكار المساء المسنونة'), findsOneWidget);
    });

    testWidgets('Occasion Flow 3: Tapping an occasion navigates to OccasionAdhkarScreen', (tester) async {
      final storage = MemoryStorageRegistry();
      final module = AdhkarModule(storageRegistry: storage);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      // Tap on Morning occasion card in grid
      await tester.tap(find.text('أذكار الصباح').last);
      await tester.pumpAndSettle();

      expect(find.byType(OccasionAdhkarScreen), findsOneWidget);
    });
  });
}
