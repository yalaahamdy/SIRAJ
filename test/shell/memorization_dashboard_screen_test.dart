import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/memorization/memorization_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/shell/memorization/memorization_dashboard_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L4 Memorization Dashboard Screen UI Tests (§38, §40)', () {
    late MemoryStorageRegistry storage;
    late ReadOnlyCanonicalQuranStore quranStore;
    late MemorizationModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranStore = ReadOnlyCanonicalQuranStore();
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranStore.mountPackage(package);

      module = MemorizationModule(
        storageRegistry: storage,
        quranStore: quranStore,
        customClock: TestClock(DateTime.utc(2026, 8, 31, 12, 0)),
      );
    });

    testWidgets('Renders dashboard components: metrics, streak, plan, and start button', (tester) async {
      var started = false;
      var setupOpened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MemorizationDashboardScreen(
            memorizationModule: module,
            onStartSession: () => started = true,
            onOpenPlanSetup: () => setupOpened = true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check title
      expect(find.text('حفظ ومراجعة القرآن الكريم'), findsOneWidget);

      // Check metrics
      expect(find.text('مستحق للمراجعة'), findsOneWidget);
      expect(find.text('جديد اليوم'), findsOneWidget);
      expect(find.text('المحفوظ والمتقن'), findsOneWidget);
      expect(find.text('درجة الإتقان'), findsOneWidget);

      // Check Start button
      final startBtnFinder = find.byType(ElevatedButton);
      expect(startBtnFinder, findsWidgets);

      await tester.ensureVisible(startBtnFinder.first);
      await tester.tap(startBtnFinder.first);
      await tester.pumpAndSettle();
      expect(started, isTrue);

      // Check Plan Settings action button
      final planIconFinder = find.byIcon(Icons.tune_rounded);
      expect(planIconFinder, findsOneWidget);

      await tester.tap(planIconFinder);
      await tester.pumpAndSettle();
      expect(setupOpened, isTrue);
    });
  });
}
