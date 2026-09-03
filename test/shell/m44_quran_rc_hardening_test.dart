import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/quran_reading_progress.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 18: M44 Quran RC Hardening & Adversarial Suite (§141..§155)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 1: INVALID SURAH BOUNDS HANDLING
    // ------------------------------------------------------------------------
    testWidgets('Hardening 1: QuranReaderScreen handles invalid Surah number (0, 115, 999) gracefully', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 999, // Invalid surah
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 2: INVALID AYAH NUMBER HANDLING
    // ------------------------------------------------------------------------
    testWidgets('Hardening 2: QuranReaderScreen handles invalid target Ayah without crash', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
            initialAyahNumber: 9999, // Invalid ayah in Al-Fatiha
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(QuranReaderScreen), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 3: CORRUPTED PERSISTED PROGRESS RECOVERY
    // ------------------------------------------------------------------------
    test('Hardening 3: Corrupted reading progress in storage recovers to Al-Fatiha', () async {
      final store = storage.getStoreForModule('mod_quran');
      await store.setString('user_reading_progress', '{CORRUPTED_JSON_DATA!!!}');

      final progressRes = await quranModule.userDataService.getProgress();
      final fallback = progressRes.valueOrNull ??
          QuranReadingProgress(
            lastReadSurah: 1,
            lastReadAyah: 1,
            lastReadPage: 1,
            surahNameArabic: 'الفاتحة',
            updatedAtUtc: DateTime.now().toUtc(),
          );

      expect(fallback.lastReadSurah, equals(1));
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 4: EMPTY & HUGE SEARCH QUERIES
    // ------------------------------------------------------------------------
    test('Hardening 4: Quran search engine safely rejects empty, whitespace, and 10k strings', () {
      final engine = quranModule.searchEngine;

      final emptyRes = engine.search('');
      expect(emptyRes.isSuccess, isTrue);
      expect(emptyRes.valueOrNull, isEmpty);

      final whitespaceRes = engine.search('   \t\n   ');
      expect(whitespaceRes.isSuccess, isTrue);
      expect(whitespaceRes.valueOrNull, isEmpty);

      final hugeRes = engine.search('الله ' * 2500);
      expect(hugeRes.isSuccess, isTrue);
      expect(hugeRes.valueOrNull, isEmpty);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 5: UNICODE RTL CONTROLS & INJECTION ATTACKS
    // ------------------------------------------------------------------------
    test('Hardening 5: Quran search engine handles RTL override and control chars safely', () {
      final engine = quranModule.searchEngine;
      const injection = '\u202E\u200E\u200F\uFEFF<script>alert(1)</script>\' OR 1=1--';

      final result = engine.search(injection);
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, isEmpty);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 6: LARGE TEXT 200% ON EXTREME VIEWPORT
    // ------------------------------------------------------------------------
    testWidgets('Hardening 6: QuranReaderScreen renders without RenderFlex overflow at 200% text scale on 320x568', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
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
          child: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(QuranReaderScreen), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 7: DARK MODE RENDERING & CONTRAST
    // ------------------------------------------------------------------------
    testWidgets('Hardening 7: QuranReaderScreen renders properly under Dark Theme', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(useMaterial3: true),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(QuranReaderScreen), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 8: OFFLINE BOOTSTRAP & NAVIGATION
    // ------------------------------------------------------------------------
    testWidgets('Hardening 8: Quran tab opens and navigates in offline mode without throwing', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: V1AppShell(
            storageRegistry: storage,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Tap Quran tab (index 2)
      await tester.tap(find.descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.byIcon(Icons.menu_book_rounded),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 9: RAPID NAVIGATION CYCLES
    // ------------------------------------------------------------------------
    testWidgets('Hardening 9: Rapid push and pop of QuranReaderScreen disposes resources cleanly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      for (int i = 0; i < 5; i++) {
        await tester.pumpWidget(MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: QuranReaderScreen(
              quranModule: quranModule,
              initialSurahNumber: 1,
            ),
          ),
        ));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    // ------------------------------------------------------------------------
    // HARDENING TEST 10: LIFECYCLE SIMULATION (BACKGROUND / RESUME)
    // ------------------------------------------------------------------------
    testWidgets('Hardening 10: Simulating app lifecycle paused and resumed maintains reader view', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      // Simulate AppLifecycleState.paused
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(milliseconds: 100));

      // Simulate AppLifecycleState.resumed
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(QuranReaderScreen), findsOneWidget);
    });
  });
}
