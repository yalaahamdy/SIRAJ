import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/surah_list_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran Progress & Continue Reading Suite (§24..§26, §47, §48, §85)', () {
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

    testWidgets('Progress Flow 1: Opening Reader automatically records last read position', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 114,
            initialAyahNumber: 3,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final progressRes = await quranModule.getReadingProgress();
      expect(progressRes.isSuccess, isTrue);
      final progress = progressRes.valueOrNull!;
      expect(progress.lastReadSurah, equals(114));
      expect(progress.lastReadAyah, equals(3));
      expect(progress.surahNameArabic, equals('الناس'));
    });

    testWidgets('Progress Flow 2: Continue Reading Banner appears on Surahs tab and resumes reader', (tester) async {
      // Pre-save progress
      await quranModule.updateReadingPosition(
        surahNumber: 114,
        ayahNumber: 2,
        pageNumber: 604,
        surahNameArabic: 'الناس',
      );

      int? openedSurah;
      int? openedAyah;

      await tester.pumpWidget(
        createTestApp(
          SurahListScreen(
            quranModule: quranModule,
            onOpenSurah: (surahNum, {targetPage, targetAyah}) {
              openedSurah = surahNum;
              openedAyah = targetAyah;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check banner visibility
      expect(find.text('متابعة القراءة: سورة الناس'), findsOneWidget);
      expect(find.textContaining('الآية 2'), findsOneWidget);

      // Tap Continue button
      await tester.tap(find.text('متابعة'));
      await tester.pumpAndSettle();

      expect(openedSurah, equals(114));
      expect(openedAyah, equals(2));
    });
  });
}
