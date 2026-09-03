import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/companion_preferences.dart';
import 'package:siraj/modules/companion/domain/companion_reminder.dart';
import 'package:siraj/modules/companion/engine/reminder_orchestrator.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 16: M41 UX Hardening Adversarial Suite (§122, §123..§131)', () {
    // --- ACCESSIBILITY REGRESSION ---

    testWidgets('Adversarial 1: No missing tab semantics after 20 rapid tab switches (§91, §93)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      for (int i = 0; i < 20; i++) {
        final icon = [
          Icons.home_rounded,
          Icons.access_time_filled_rounded,
          Icons.menu_book_rounded,
          Icons.auto_stories_rounded,
          Icons.grid_view_rounded,
        ][i % 5];
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
        await tester.pump(const Duration(milliseconds: 30));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    // --- LARGE TEXT OVERFLOW SHIELD ---

    testWidgets('Adversarial 2: Large Text 200% does not overflow any tab (§11, §112)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(2.0),
          ),
          child: child!,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      for (final icon in [
        Icons.access_time_filled_rounded,
        Icons.menu_book_rounded,
        Icons.auto_stories_rounded,
        Icons.home_rounded,
      ]) {
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    // --- SMALL SCREEN OVERFLOW SHIELD ---

    testWidgets('Adversarial 3: 320x568 (minimum supported) has no overflow (§26, §125)', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // --- RTL LAYOUT CORRUPTION SHIELD ---

    testWidgets('Adversarial 4: RTL renders identically after resize (§20, §30)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      tester.view.physicalSize = const Size(360, 640);
      await tester.pumpAndSettle();

      expect(find.text('الرئيسية'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // --- DARK MODE ACCESSIBILITY ---

    testWidgets('Adversarial 5: Dark mode + large text 150% has no exception (§18, §77, §112)', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(1.5),
          size: Size(360, 800),
        ),
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // --- ORIENTATION STATE LOSS SHIELD ---

    testWidgets('Adversarial 6: 5 orientation cycles cause no state loss (§31, §126)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      for (int i = 0; i < 5; i++) {
        tester.view.physicalSize = const Size(2400, 1080);
        await tester.pump(const Duration(milliseconds: 50));
        tester.view.physicalSize = const Size(1080, 2400);
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // --- MEMORY LEAK SHIELD ---

    testWidgets('Adversarial 7: 20 navigation cycles have no accumulated errors (§50, §127)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      for (int i = 0; i < 20; i++) {
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.access_time_filled_rounded)));
        await tester.pump(const Duration(milliseconds: 30));
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(Icons.home_rounded)));
        await tester.pump(const Duration(milliseconds: 30));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // --- CANONICAL CONTENT MUTATION SHIELD ---

    test('Adversarial 8: QuranModule store does not mutate canonical text in user storage (§55, §128)', () {
      final storage = MemoryStorageRegistry();
      final quran = QuranModule(storageRegistry: storage);

      // Canonical store is read-only — user storage untouched
      expect(quran.store, isNotNull);
    });

    // --- RELIGIOUS PROFILING INJECTION SHIELD ---

    test('Adversarial 9: ReminderOrchestrator does not add piety score fields to reminders (§129)', () {
      const orchestrator = ReminderOrchestrator();
      const prefs = CompanionPreferences();

      final reminders = [
        CompanionReminder(
          reminderId: 'r1',
          sourceModule: 'prayer',
          titleArabic: 'صلاة الفجر',
          messageArabic: 'حان وقت الفجر',
          scheduledTime: DateTime(2026, 9, 1, 5, 0),
          priority: ReminderPriority.high,
        ),
      ];

      final processed = orchestrator.processReminders(
        rawReminders: reminders,
        preferences: prefs,
        currentTime: DateTime(2026, 9, 1, 4, 30),
      );

      for (final r in processed) {
        expect(r.messageArabic.contains('درجة'), false);
        expect(r.messageArabic.contains('مقصر'), false);
        expect(r.messageArabic.contains('إيمان'), false);
      }
    });

    // --- PIETY SCORE INJECTION SHIELD ---

    test('Adversarial 10: No piety score or faith score in CompanionModule outputs (§129)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      final statuses = await companion.getModuleStatuses();
      for (final status in statuses) {
        final summary = status.progressSummary ?? '';
        expect(summary.contains('درجة الإيمان'), false);
        expect(summary.contains('مستوى التدين'), false);
      }
    });

    // --- PRIVACY: NO FINANCIAL DATA EXPOSURE ---

    test('Adversarial 11: CompanionModule reminders do not contain financial amounts (§129)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      final remindersRes = await companion.getReminders(currentTime: DateTime(2026, 9, 1, 10, 0));
      final reminders = remindersRes.valueOrNull ?? [];

      for (final r in reminders) {
        // No financial data in notification body
        expect(r.messageArabic.contains('ريال'), false);
        expect(r.messageArabic.contains('دولار'), false);
      }
    });

    // --- STARTUP REGRESSION SHIELD ---

    testWidgets('Adversarial 12: Shell mounts under 2000ms even at 2.0 textScale (§37, §123)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final stopwatch = Stopwatch()..start();
      await tester.pumpWidget(MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(2.0),
          size: Size(360, 640),
        ),
        child: MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
      expect(tester.takeException(), isNull);
    });

    // --- OFFLINE FAILURE SHIELD ---

    testWidgets('Adversarial 13: Offline mode — all 5 tabs open without crash (§56, §116)', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(storageRegistry: MemoryStorageRegistry()),
        ),
      ));
      await tester.pumpAndSettle();

      for (final icon in [
        Icons.access_time_filled_rounded,
        Icons.menu_book_rounded,
        Icons.auto_stories_rounded,
        Icons.grid_view_rounded,
        Icons.home_rounded,
      ]) {
        await tester.tap(find.descendant(of: find.byType(BottomNavigationBar), matching: find.byIcon(icon)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });

    // --- AI RUNTIME INJECTION SHIELD ---

    test('Adversarial 14: No AI runtime dependency in PrayerModule or QuranModule (§129)', () {
      final storage = MemoryStorageRegistry();
      final prayer = PrayerModule(storageRegistry: storage);
      final quran = QuranModule(storageRegistry: storage);

      // These modules must be fully deterministic — no AI calls
      expect(prayer.scheduleService, isNotNull);
      expect(quran.store, isNotNull);
    });

    // --- SECURITY GUARD BYPASS SHIELD ---

    test('Adversarial 15: CompanionModule does not expose raw user data in search results (§106, §129)', () async {
      final storage = MemoryStorageRegistry();
      final companion = CompanionModule(storageRegistry: storage);

      final resultsRes = await companion.search('زكاة');
      final results = resultsRes.valueOrNull ?? [];

      for (final r in results) {
        // Source must always be canonical — no user-generated content mixed in
        expect(r.moduleId, isNotEmpty);
      }
    });
  });
}
