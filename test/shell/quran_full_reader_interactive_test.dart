import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/surah_list_screen.dart';
import 'package:siraj/shell/routing/app_router.dart';
import 'package:siraj/shell/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Quran Full Reader Real Production UI Interaction Test (§10, §11, §13)', () {
    late QuranModule quranModule;

    setUp(() async {
      final package = await CanonicalQuranLoader.loadPackage();
      quranModule = QuranModule(storageRegistry: MemoryStorageRegistry());
      quranModule.store.mountPackage(package);
      AppRouter.defaultQuranModule = quranModule;
    });

    testWidgets('SurahListScreen renders all 114 Surahs from canonical metadata', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: SurahListScreen(
            quranModule: quranModule,
            onOpenSurah: (surahNum, {targetAyah, targetPage}) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure Al-Fatihah is present with prefix
      expect(find.text('سورة الفاتحة'), findsOneWidget);

      // Verify that the module supplies all 114 Surahs
      final allSurahs = quranModule.getAllSurahs().valueOrNull!;
      expect(allSurahs.length, equals(114));
      expect(allSurahs.first.nameArabic, equals('الفاتحة'));
      expect(allSurahs[1].nameArabic, equals('البقرة'));
      expect(allSurahs.last.nameArabic, equals('الناس'));
    });

    testWidgets('QuranReaderScreen opens and renders real Ayahs for mandatory test Surahs (1, 2, 3, 18, 36, 55, 67, 78, 112, 113, 114)', (tester) async {
      final targetSurahs = [1, 2, 3, 18, 36, 55, 67, 78, 112, 113, 114];

      for (final surahNum in targetSurahs) {
        final surahInfo = quranModule.getSurah(surahNum).valueOrNull!;
        final ayahs = quranModule.getSurahAyahs(surahNum).valueOrNull!;
        expect(ayahs.isNotEmpty, isTrue, reason: 'Surah $surahNum ayahs must not be empty');

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: QuranReaderScreen(
              key: ValueKey(surahNum),
              quranModule: quranModule,
              initialSurahNumber: surahNum,
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify Surah header displays authentic Arabic name
        expect(find.text('سورة ${surahInfo.nameArabic}'), findsWidgets);

        // Verify first Ayah text is rendered
        final firstAyahText = ayahs.first.textUthmani;
        expect(find.text(firstAyahText), findsOneWidget,
            reason: 'Surah $surahNum first Ayah was not rendered');

        // Scroll down
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();
      }
    });
  });
}
