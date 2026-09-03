import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/surah_list_screen.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran Search Flow Suite (§27..§35, §86)', () {
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

    testWidgets('Search Flow 1: Typing normalized query displays matching results with canonical text', (tester) async {
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

      // Enter search query without diacritics: "الرحمن"
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'الرحمن');
      await tester.pumpAndSettle();

      // Search results appear
      expect(find.textContaining('سورة رقم'), findsWidgets);

      // Tap on first result
      await tester.tap(find.textContaining('سورة رقم').first);
      await tester.pumpAndSettle();

      expect(openedSurah, isNotNull);
      expect(openedAyah, isNotNull);
    });

    testWidgets('Search Flow 2: Non-matching query renders empty state cleanly', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          SurahListScreen(
            quranModule: quranModule,
            onOpenSurah: (_, {targetPage, targetAyah}) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'كلمة_غير_موجودة_إطلاقا_xyz');
      await tester.pumpAndSettle();

      expect(find.text('لم يتم العثور على نتائج مطابقة'), findsOneWidget);
    });
  });
}
