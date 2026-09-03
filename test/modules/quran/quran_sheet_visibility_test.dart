import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/quran_reader_modes.dart';
import 'package:siraj/modules/quran/domain/surah.dart';
import 'package:siraj/modules/quran/services/quran_tafsir_service.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/quran/widgets/ayah_action_bottom_sheet.dart';
import 'package:siraj/shell/quran/widgets/reader_settings_sheet.dart';
import 'package:siraj/shell/quran/widgets/tafsir_bottom_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Surah sampleSurah;
  late Ayah sampleAyah;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    sampleSurah = package.surahs.first;
    sampleAyah = package.ayahs.first;
  });

  group('M02.1 Quran Bottom Sheet Opacity & Readability Tests (§7, §8)', () {
    testWidgets('AyahActionBottomSheet has opaque surface background and is readable', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AyahActionBottomSheet(
              ayah: sampleAyah,
              surah: sampleSurah,
              isBookmarked: false,
              onToggleBookmark: () {},
              onMemorize: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(AyahActionBottomSheet),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsWidgets);

      final rootContainer = tester.firstWidget<Container>(containerFinder);
      final decoration = rootContainer.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.color, isNotNull);
      // Background must NOT be transparent (100% opaque)
      expect(decoration.color!.a, equals(1.0));
    });

    testWidgets('ReaderSettingsSheet has opaque surface background in Dark Mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: ReaderSettingsSheet(
              config: const QuranTypographyConfig(themeMode: QuranReaderThemeMode.dark),
              onConfigChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(ReaderSettingsSheet),
        matching: find.byType(Container),
      );
      expect(containerFinder, findsWidgets);

      final rootContainer = tester.firstWidget<Container>(containerFinder);
      final decoration = rootContainer.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.color, isNotNull);
      expect(decoration.color!.a, equals(1.0));
    });

    testWidgets('TafsirBottomSheet has opaque background and elevation shadow', (tester) async {
      final mockTafsir = DefaultQuranTafsirService();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TafsirBottomSheet(
              surahNumber: 1,
              surahNameArabic: 'الفاتحة',
              initialAyahNumber: 1,
              totalAyahsInSurah: 7,
              tafsirService: mockTafsir,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rootContainer = tester.firstWidget<Container>(
        find.descendant(of: find.byType(TafsirBottomSheet), matching: find.byType(Container)),
      );
      final decoration = rootContainer.decoration as BoxDecoration?;
      expect(decoration, isNotNull);
      expect(decoration!.color!.a, equals(1.0));
      expect(decoration.boxShadow, isNotEmpty);
    });
  });
}
