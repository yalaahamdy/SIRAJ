import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/quran_reader_modes.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';
import 'package:siraj/shell/theme/app_theme.dart';

void main() {
  group('M02 Quran Translation Mode Switching Tests', () {
    final testAyah = Ayah.create(
      surahNumber: 1,
      ayahNumber: 1,
      textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
      textSimple: 'بسم الله الرحمن الرحيم',
      juzNumber: 1,
      hizbNumber: 1,
      rubNumber: 1,
      pageNumber: 1,
      manzilNumber: 1,
      hasSajdah: false,
    );

    const testTranslation = 'In the name of Allah, the Entirely Merciful, the Especially Merciful.';

    testWidgets('Mushaf Mode hides translation and displays pure Arabic calligraphy', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AyahView(
              ayah: testAyah,
              config: const QuranTypographyConfig(
                readerMode: QuranReaderMode.mushaf,
                showTranslation: false,
              ),
              translationText: testTranslation,
            ),
          ),
        ),
      );

      expect(find.textContaining('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'), findsOneWidget);
      expect(find.textContaining('In the name of Allah'), findsNothing);
    });

    testWidgets('Translation Mode reveals authentic English translation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AyahView(
              ayah: testAyah,
              config: const QuranTypographyConfig(
                readerMode: QuranReaderMode.translation,
                showTranslation: true,
              ),
              translationText: testTranslation,
            ),
          ),
        ),
      );

      expect(find.textContaining('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ'), findsOneWidget);
      expect(find.textContaining('In the name of Allah'), findsOneWidget);
    });

    testWidgets('Multi-language translation switching renders target language text correctly', (tester) async {
      // Test dynamic switching across English, French, and Urdu
      final enMap = CanonicalQuranLoader.loadTranslationsSync(languageCode: 'en');
      final frMap = CanonicalQuranLoader.loadTranslationsSync(languageCode: 'fr');
      final urMap = CanonicalQuranLoader.loadTranslationsSync(languageCode: 'ur');

      expect(enMap['1:1'], isNotNull);
      expect(frMap['1:1'], isNotNull);
      expect(urMap['1:1'], isNotNull);

      // Render with French
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AyahView(
              ayah: testAyah,
              config: const QuranTypographyConfig(
                readerMode: QuranReaderMode.translation,
                showTranslation: true,
                translationLanguage: 'fr',
              ),
              translationText: frMap['1:1'],
            ),
          ),
        ),
      );
      expect(find.textContaining("Au nom d'Allah"), findsOneWidget);

      // Switch to Urdu
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AyahView(
              ayah: testAyah,
              config: const QuranTypographyConfig(
                readerMode: QuranReaderMode.translation,
                showTranslation: true,
                translationLanguage: 'ur',
              ),
              translationText: urMap['1:1'],
            ),
          ),
        ),
      );
      expect(find.textContaining('اللہ کے نام سے جو رحمان و رحیم ہے'), findsOneWidget);
    });
  });
}
