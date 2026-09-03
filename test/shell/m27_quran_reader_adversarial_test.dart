import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran Reader Adversarial & Degradation Suite (§92, §93, §94)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);
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

    testWidgets('Adversarial 1: Requesting invalid Surah (e.g. 999) fails closed with safe error view', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 999,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify error view with retry button is shown without crashing
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    test('Adversarial 2: Invalid AyahKey boundary enforcement (0, 115, negative)', () {
      expect(() => AyahKey(surahNumber: 0, ayahNumber: 1), throwsAssertionError);
      expect(() => AyahKey(surahNumber: 115, ayahNumber: 1), throwsAssertionError);
      expect(() => AyahKey(surahNumber: 1, ayahNumber: 0), throwsAssertionError);
    });

    testWidgets('Adversarial 3: Unmounted store renders fail-safe error and does not invent fake verses', (tester) async {
      final emptyStorage = MemoryStorageRegistry();
      final unmountedModule = QuranModule(storageRegistry: emptyStorage);

      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: unmountedModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify fail-safe error view
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.text('إعادة المحاولة'), findsOneWidget);
    });

    test('Adversarial 4: Corrupted bookmark record does not crash getBookmarks service', () async {
      final store = storage.getStoreForModule('mod_quran');
      await store.setString('quran_user_bookmarks', 'corrupted_non_json_string_xyz');

      final bookmarksRes = await quranModule.getBookmarks();
      expect(bookmarksRes.isSuccess, isTrue);
      expect(bookmarksRes.valueOrNull, isEmpty);
    });

    test('Adversarial 5: Corrupted reading progress recovers safely with default baseline', () async {
      final store = storage.getStoreForModule('mod_quran');
      await store.setString('quran_reading_progress', 'invalid_json_progress');

      final progressRes = await quranModule.getReadingProgress();
      expect(progressRes.isSuccess, isTrue);
      final progress = progressRes.valueOrNull!;
      expect(progress.lastReadSurah, equals(1));
      expect(progress.lastReadAyah, equals(1));
    });
  });
}
