import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import 'package:siraj/shell/adhkar/widgets/interactive_counter_view.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Interactive Dhikr Counter Suite (§17..§25, §68..§72, §92)', () {
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

    testWidgets('Counter Flow 1: Tapping counter increments count and persists progress', (tester) async {
      // Find item with target 3 (afterPrayer)
      final itemsRes = module.getAllItems();
      final item3 = itemsRes.valueOrNull!.firstWhere((i) => i.repetition.count == 3);

      await tester.pumpWidget(createTestApp(DhikrDetailScreen(item: item3, module: module)));
      await tester.pumpAndSettle();

      // Initial count 0
      expect(find.text('0'), findsOneWidget);
      expect(find.text('من 3'), findsOneWidget);

      // Tap counter circle
      final counterFinder = find.byType(InteractiveCounterView);
      await tester.tap(counterFinder);
      await tester.pumpAndSettle();

      // Count becomes 1
      expect(find.text('1'), findsOneWidget);

      // Tap again -> count 2
      await tester.tap(counterFinder);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // Tap 3rd time -> completed state
      await tester.tap(counterFinder);
      await tester.pumpAndSettle();
      expect(find.text('اكتمل'), findsOneWidget);
    });

    testWidgets('Counter Flow 2: Undo action decrements count to correct accidental tap', (tester) async {
      final itemsRes = module.getAllItems();
      final item3 = itemsRes.valueOrNull!.firstWhere((i) => i.repetition.count == 3);

      await tester.pumpWidget(createTestApp(DhikrDetailScreen(item: item3, module: module)));
      await tester.pumpAndSettle();

      // Increment to 2
      final counterFinder = find.byType(InteractiveCounterView);
      await tester.tap(counterFinder);
      await tester.pumpAndSettle();
      await tester.tap(counterFinder);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);

      // Tap Undo button
      await tester.tap(find.text('تراجع عن آخر عدة'));
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('Counter Flow 3: Reset action resets count to 0', (tester) async {
      final itemsRes = module.getAllItems();
      final item3 = itemsRes.valueOrNull!.firstWhere((i) => i.repetition.count == 3);

      await tester.pumpWidget(createTestApp(DhikrDetailScreen(item: item3, module: module)));
      await tester.pumpAndSettle();

      final counterFinder = find.byType(InteractiveCounterView);
      await tester.tap(counterFinder);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      // Tap Reset button
      await tester.tap(find.text('إعادة ضبط'));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
    });
  });
}
