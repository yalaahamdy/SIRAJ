import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/surah_list_screen.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';
import 'package:siraj/shell/quran/widgets/quran_mushaf_flow_view.dart';
import 'package:siraj/shell/quran/widgets/surah_header_card.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('L4 Quran Reader & Surah List Widget Tests (§13, §24, §25)', () {
    late QuranModule quranModule;

    setUp(() {
      final storage = MemoryStorageRegistry();
      final clock = TestClock(DateTime.utc(2026, 8, 31, 12, 0));
      quranModule = QuranModule(storageRegistry: storage, clock: clock);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);
    });

    testWidgets('SurahListScreen renders tabs, search bar, and Surah list', (tester) async {
      int? openedSurah;

      await tester.pumpWidget(
        MaterialApp(
          home: SurahListScreen(
            quranModule: quranModule,
            onOpenSurah: (surahNum, {targetPage, targetAyah}) => openedSurah = surahNum,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check Tabs
      expect(find.text('السور'), findsOneWidget);
      expect(find.text('التلاوة'), findsOneWidget);
      expect(find.text('الأجزاء'), findsOneWidget);
      expect(find.text('الإعدادات'), findsOneWidget);

      // Check Search Field
      expect(find.byType(TextField), findsWidgets);

      // Check Al-Fatihah in list
      expect(find.text('سورة الفاتحة'), findsWidgets);

      // Tap on Al-Fatihah
      await tester.tap(find.text('سورة الفاتحة').first);
      expect(openedSurah, equals(1));
    });

    testWidgets('QuranReaderScreen renders Surah header and Ayah list with bookmarking', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Header card
      expect(find.byType(SurahHeaderCard), findsOneWidget);
      expect(find.text('سورة الفاتحة'), findsWidgets);

      // In default Mushaf mode, QuranMushafFlowView is rendered
      expect(find.byType(QuranMushafFlowView), findsOneWidget);

      // Switch to Translation mode to test verse-by-verse AyahView
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('الترجمة'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Ayah views in translation mode
      expect(find.byType(AyahView), findsWidgets);
      expect(find.textContaining('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'), findsOneWidget);
    });
  });
}
