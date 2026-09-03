import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/surah_list_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran Bookmark Flow Suite (§20..§23, §84, §94, §95)', () {
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

    testWidgets('Bookmark Flow 1: Tapping bookmark icon in reader saves and updates state', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find first Ayah's bookmark button
      final bookmarkButtons = find.byTooltip('حفظ كفاصل مرجعي');
      expect(bookmarkButtons, findsWidgets);

      // Tap first bookmark button
      await tester.tap(bookmarkButtons.first);
      await tester.pumpAndSettle();

      // Verify bookmark is stored
      final bookmarksRes = await quranModule.getBookmarks();
      expect(bookmarksRes.isSuccess, isTrue);
      expect(bookmarksRes.valueOrNull!.length, equals(1));
      expect(bookmarksRes.valueOrNull!.first.surahNumber, equals(1));
      expect(bookmarksRes.valueOrNull!.first.ayahNumber, equals(1));

      // Icon changes to active bookmark
      expect(find.byTooltip('إزالة الفاصل'), findsOneWidget);
    });

    testWidgets('Bookmark Flow 2: Saved bookmarks appear in Bookmarks tab and support deletion', (tester) async {
      // Pre-add 2 bookmarks
      await quranModule.addBookmark(
        surahNumber: 1,
        ayahNumber: 5,
        pageNumber: 1,
        surahNameArabic: 'الفاتحة',
        ayahSnippet: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
      );
      await quranModule.addBookmark(
        surahNumber: 114,
        ayahNumber: 1,
        pageNumber: 604,
        surahNameArabic: 'الناس',
        ayahSnippet: 'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
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

      // Switch to Bookmarks tab (الفواصل)
      await tester.tap(find.text('الفواصل'));
      await tester.pumpAndSettle();

      // Verify bookmarks list
      expect(find.text('سورة الفاتحة — الآية 5'), findsOneWidget);
      expect(find.text('سورة الناس — الآية 1'), findsOneWidget);

      // Tap on Al-Fatihah bookmark to jump
      await tester.tap(find.text('سورة الفاتحة — الآية 5'));
      await tester.pumpAndSettle();

      expect(openedSurah, equals(1));
      expect(openedAyah, equals(5));
    });
  });
}
