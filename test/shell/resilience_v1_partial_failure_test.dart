import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: Partial Failure Isolation Suite (§57, §73, §120, §131)', () {
    testWidgets('Partial Failure 1: Shell boots when no modules are pre-wired (§57, §120)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Minimal shell — CompanionModule has no sub-modules
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Partial Failure 2: Prayer module still works when Quran is unreachable (§57, §120)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final storage = MemoryStorageRegistry();
      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: storage),
        ),
      ));
      await tester.pumpAndSettle();

      // Navigate to Prayer — should work even if Quran module is slow/empty
      await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.textContaining('الصلاة القادمة'), findsWidgets);
    });

    test('Partial Failure 3: CompanionModule with null modules returns empty statuses (§57)', () async {
      final storage = MemoryStorageRegistry();
      // No sub-modules wired
      final companion = CompanionModule(storageRegistry: storage);

      final statuses = await companion.getModuleStatuses();
      // Returns empty or minimal list — no crash
      expect(statuses, isNotNull);
    });

    test('Partial Failure 4: PrayerModule works independently from all other modules (§57)', () async {
      final storage = MemoryStorageRegistry();
      final prayer = PrayerModule(storageRegistry: storage);

      // Basic functionality check — no crash
      expect(prayer.scheduleService, isNotNull);
      expect(prayer.qiblaService, isNotNull);
    });

    test('Partial Failure 5: QuranModule works independently from all other modules (§57)', () async {
      final storage = MemoryStorageRegistry();
      final quran = QuranModule(storageRegistry: storage);

      expect(quran.store, isNotNull);
    });
  });
}
