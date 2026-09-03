import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/revelation_type.dart';
import 'package:siraj/modules/quran/domain/surah.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_target.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_word.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_matcher.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/shell/quran/widgets/quran_mushaf_flow_view.dart';

void main() {
  const testSurah = Surah(
    number: 1,
    nameArabic: 'الفاتحة',
    nameEnglish: 'Al-Fatiha',
    nameTransliteration: 'Al-Fatihah',
    revelationType: RevelationType.meccan,
    ayahCount: 3,
    startPage: 1,
  );

  final testAyahs = [
    Ayah.create(
      surahNumber: 1,
      ayahNumber: 1,
      textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
      textSimple: 'بسم الله الرحمن الرحيم',
      juzNumber: 1,
      pageNumber: 1,
      hizbNumber: 1,
      rubNumber: 1,
      manzilNumber: 1,
    ),
    Ayah.create(
      surahNumber: 1,
      ayahNumber: 2,
      textUthmani: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَـٰلَمِينَ',
      textSimple: 'الحمد لله رب العالمين',
      juzNumber: 1,
      pageNumber: 1,
      hizbNumber: 1,
      rubNumber: 1,
      manzilNumber: 1,
    ),
    Ayah.create(
      surahNumber: 1,
      ayahNumber: 3,
      textUthmani: 'ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
      textSimple: 'الرحمن الرحيم',
      juzNumber: 1,
      pageNumber: 1,
      hizbNumber: 1,
      rubNumber: 1,
      manzilNumber: 1,
    ),
  ];

  const config = QuranTypographyConfig();

  group('In-Place Quran Recitation Tests (§M02.2 - Veiling and Unveiling)', () {
    testWidgets('Mode A: Verses in recitation target are veiled during recording in Mushaf',
        (tester) async {
      final target = QuranRecitationTarget(
        surahNumber: 1,
        surahNameArabic: 'الفاتحة',
        startAyah: 1,
        endAyah: 2,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: testAyahs,
              config: config,
              activeRecitationTarget: target,
              isRecitationActive: true,
              isRecitationTextHidden: true, // Recording active
              onAyahTap: (_) {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(
        find.byWidgetPredicate((w) => w is Text && w.textSpan != null),
      );
      final spans = (textWidget.textSpan as TextSpan).children!;

      // Ayah 1 (spans[0]) & Ayah 2 (spans[2]) are veiled with 100% transparency
      final ayah1Span = spans[0] as TextSpan;
      expect(ayah1Span.style?.color, equals(Colors.transparent));

      final ayah2Span = spans[2] as TextSpan;
      expect(ayah2Span.style?.color, equals(Colors.transparent));

      // Ayah 3 (spans[4]) is outside target range -> visible
      final ayah3Span = spans[4] as TextSpan;
      expect(ayah3Span.style?.color, isNot(equals(Colors.transparent)));
    });

    testWidgets('Mode A: Verses immediately REAPPEAR in Mushaf after recording stops',
        (tester) async {
      final target = QuranRecitationTarget(
        surahNumber: 1,
        surahNameArabic: 'الفاتحة',
        startAyah: 1,
        endAyah: 2,
      );

      // When recording completes: isRecitationTextHidden becomes false
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: testAyahs,
              config: config,
              activeRecitationTarget: target,
              isRecitationActive: true,
              isRecitationTextHidden: false, // Recording stopped: revealed!
              onAyahTap: (_) {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(
        find.byWidgetPredicate((w) => w is Text && w.textSpan != null),
      );
      final spans = (textWidget.textSpan as TextSpan).children!;

      // Full canonical text is back to visible in the Mushaf (not transparent)
      final ayah1Span = spans[0] as TextSpan;
      expect(ayah1Span.style?.color, isNot(equals(Colors.transparent)));

      final ayah2Span = spans[2] as TextSpan;
      expect(ayah2Span.style?.color, isNot(equals(Colors.transparent)));
    });

    testWidgets('Mode B: FastConformer recognized words reveal in-place inside Mushaf text',
        (tester) async {
      final target = QuranRecitationTarget(
        surahNumber: 1,
        surahNameArabic: 'الفاتحة',
        startAyah: 1,
        endAyah: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(testAyahs[0]);

      // Initially all words are hidden
      expect(words.every((w) => !w.isVisible), isTrue);

      // Simulate FastConformer recognizing the first two words
      words[0] = words[0].copyWith(
        state: RecitationWordState.recognized,
        confidenceLevel: RecitationWordConfidence.confirmed,
      );
      words[1] = words[1].copyWith(
        state: RecitationWordState.recognized,
        confidenceLevel: RecitationWordConfidence.confirmed,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: testAyahs,
              config: config,
              activeRecitationTarget: target,
              isRecitationActive: true,
              isRecitationTextHidden: false,
              recitationWordsMap: {1: words},
              onAyahTap: (_) {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(
        find.byWidgetPredicate((w) => w is Text && w.textSpan != null),
      );
      final spans = (textWidget.textSpan as TextSpan).children!;

      // Recognized words (0 and 1) are visible (not transparent)
      final word0Span = spans[0] as TextSpan;
      expect(word0Span.style?.color, isNot(equals(Colors.transparent)));

      final word1Span = spans[1] as TextSpan;
      expect(word1Span.style?.color, isNot(equals(Colors.transparent)));

      // Unrecognized words (2 and 3) are 100% transparent
      final word2Span = spans[2] as TextSpan;
      expect(word2Span.style?.color, equals(Colors.transparent));

      final word3Span = spans[3] as TextSpan;
      expect(word3Span.style?.color, equals(Colors.transparent));
    });
  });
}
