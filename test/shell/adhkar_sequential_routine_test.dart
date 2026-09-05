import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import 'package:siraj/shell/adhkar/occasion_adhkar_screen.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('SIRAJ v1.0 — Adhkar Continuous Routine & Sequential Flow Suite', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() async {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      await module.initialize();
      final package = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
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

    testWidgets('1. Occasion screen presents "بدء قراءة الورد كاملاً" hero card and launches sequential flow', (tester) async {
      await tester.pumpWidget(
        createTestApp(OccasionAdhkarScreen(occasion: DhikrOccasion.morning, module: module)),
      );
      await tester.pumpAndSettle();

      // Verify Routine Hero Card
      expect(find.text('بدء قراءة الورد كاملاً'), findsOneWidget);
      expect(find.text('ابدأ الورد'), findsOneWidget);

      // Tap "ابدأ الورد"
      await tester.tap(find.text('ابدأ الورد'));
      await tester.pumpAndSettle();

      // Verify we are in DhikrDetailScreen with sequential flow
      expect(find.byType(DhikrDetailScreen), findsOneWidget);
      expect(find.textContaining('أذكار الصباح (1 /'), findsOneWidget);
      expect(find.text('التالي'), findsOneWidget);
    });

    testWidgets('2. Next and Previous buttons navigate through routine without exiting screen', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final morningItems = module.getItemsByOccasion(DhikrOccasion.morning).valueOrNull!;

      await tester.pumpWidget(
        createTestApp(
          DhikrDetailScreen(items: morningItems, initialIndex: 0, module: module),
        ),
      );
      await tester.pumpAndSettle();

      // Starts at Dhikr 1
      expect(find.textContaining('1 / ${morningItems.length}'), findsWidgets);
      expect(find.text(morningItems[0].textArabic), findsOneWidget);

      // Tap Next button
      await tester.tap(find.text('التالي'));
      await tester.pumpAndSettle();

      // Now at Dhikr 2 without leaving screen!
      expect(find.textContaining('2 / ${morningItems.length}'), findsWidgets);
      expect(find.text(morningItems[1].textArabic), findsOneWidget);

      // Tap Previous button
      await tester.tap(find.text('السابق'));
      await tester.pumpAndSettle();

      // Back to Dhikr 1
      expect(find.textContaining('1 / ${morningItems.length}'), findsWidgets);
      expect(find.text(morningItems[0].textArabic), findsOneWidget);
    });

    testWidgets('3. Completing target count with Auto-Advance automatically moves to next Dhikr', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final items = module.getItemsByOccasion(DhikrOccasion.morning).valueOrNull!;
      // Find an item with count 1 for instant verification
      final singleCountIndex = items.indexWhere((i) => i.repetition.count == 1);
      expect(singleCountIndex, greaterThanOrEqualTo(0));

      await tester.pumpWidget(
        createTestApp(
          DhikrDetailScreen(items: items, initialIndex: singleCountIndex, module: module),
        ),
      );
      await tester.pumpAndSettle();

      final currentItem = items[singleCountIndex];
      expect(find.text(currentItem.textArabic), findsOneWidget);

      // Tap text card to increment counter
      await tester.tap(find.text(currentItem.textArabic));
      await tester.pump();
      // Wait for auto-advance delay (400ms + animation 350ms)
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Automatically advanced to next item!
      final nextItem = items[singleCountIndex + 1];
      expect(find.text(nextItem.textArabic), findsOneWidget);
      expect(find.textContaining('${singleCountIndex + 2} / ${items.length}'), findsWidgets);
    });
  });
}
