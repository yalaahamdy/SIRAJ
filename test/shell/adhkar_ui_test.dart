import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import 'package:siraj/shell/adhkar/widgets/interactive_counter_view.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('L4 Adhkar Shell UI & Interactive Counter Tests (§34, §35, §36)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() async {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(
        storageRegistry: storage,
        customClock: TestClock(DateTime.utc(2026, 8, 31, 7, 0)), // 07:00 Morning
      );
      await module.initialize();
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
    });

    testWidgets('AdhkarHomeScreen renders search bar, hero occasion card, and categories grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AdhkarHomeScreen(module: module),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('الأذكار والأدعية'), findsOneWidget);
      expect(find.text('أذكار الصباح'), findsWidgets); // In hero and in grid
      expect(find.byType(TextField), findsOneWidget);

      // Search interaction
      await tester.enterText(find.byType(TextField), 'اصبحنا');
      await tester.pumpAndSettle();

      expect(find.textContaining('أَصْبَحْنَا'), findsOneWidget);
    });

    testWidgets('DhikrDetailScreen displays Arabic text, provenance disclosure, and interacts with counter', (tester) async {
      final item = module.getItemById('dhikr_morning_001').valueOrNull!;

      await tester.pumpWidget(
        MaterialApp(
          home: DhikrDetailScreen(item: item, module: module),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('أَصْبَحْنَا'), findsOneWidget);
      expect(find.text('صحيح مسلم'), findsOneWidget);
      expect(find.text('الإمام مسلم بن الحجاج'), findsOneWidget);
      expect(find.byType(InteractiveCounterView), findsOneWidget);

      // Tap counter to increment
      await tester.tap(find.byType(InteractiveCounterView));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}
