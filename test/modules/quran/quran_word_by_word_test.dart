import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/quran_word.dart';
import 'package:siraj/shell/quran/widgets/word_by_word_sheet.dart';
import 'package:siraj/shell/theme/app_theme.dart';

void main() {
  group('M02 Quran Word-By-Word Subsystem Tests', () {
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

    final testWords = [
      const QuranWord(
        surahNumber: 1,
        ayahNumber: 1,
        wordNumber: 1,
        textArabic: 'بِسْمِ',
        translation: 'In the name',
        transliteration: 'Bismi',
      ),
      const QuranWord(
        surahNumber: 1,
        ayahNumber: 1,
        wordNumber: 2,
        textArabic: 'ٱللَّهِ',
        translation: 'of Allah',
        transliteration: 'Allahi',
      ),
      const QuranWord(
        surahNumber: 1,
        ayahNumber: 1,
        wordNumber: 3,
        textArabic: 'ٱلرَّحْمَٰنِ',
        translation: 'the Entirely Merciful',
        transliteration: 'Ar-Rahman',
      ),
      const QuranWord(
        surahNumber: 1,
        ayahNumber: 1,
        wordNumber: 4,
        textArabic: 'ٱلرَّحِيمِ',
        translation: 'the Especially Merciful',
        transliteration: 'Ar-Raheem',
      ),
    ];

    testWidgets('WordByWordSheet renders individual words and linguistic translations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: WordByWordSheet(
              ayah: testAyah,
              surahNameArabic: 'الفاتحة',
              words: testWords,
            ),
          ),
        ),
      );

      expect(find.textContaining('معاني كلمات الآية 1'), findsOneWidget);
      expect(find.text('بِسْمِ'), findsOneWidget);
      expect(find.text('In the name'), findsOneWidget);
      expect(find.text('ٱلرَّحْمَٰنِ'), findsOneWidget);
      expect(find.text('the Entirely Merciful'), findsOneWidget);
    });
  });
}
