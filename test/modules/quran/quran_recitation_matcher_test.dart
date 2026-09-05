import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_word.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_matcher.dart';

void main() {
  group('M02.2 Quran Recitation Matcher & Normalization Tests (§8, §9, §10)', () {
    test('Arabic normalization strips diacritics and pause marks correctly without altering canonical storage', () {
      const canonicalUthmani = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ۝١';
      final normalized = QuranRecitationMatcher.normalizeForRecognition(canonicalUthmani);

      // Normalization output should be plain Arabic letters
      expect(normalized, equals('بسم الله الرحمن الرحيم'));

      // Ensure original canonical text variable was never mutated
      expect(canonicalUthmani, equals('بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ ۝١'));
    });

    test('Normalizes Hamzas, Taa Marbuta, and Alif Maqsura consistently', () {
      expect(QuranRecitationMatcher.normalizeForRecognition('إِيَّاكَ'), equals('اياك'));
      expect(QuranRecitationMatcher.normalizeForRecognition('الصَّلَاةَ'), equals('الصلاه'));
      expect(QuranRecitationMatcher.normalizeForRecognition('هُدًى'), equals('هدي'));
      expect(QuranRecitationMatcher.normalizeForRecognition('يُؤْمِنُونَ'), equals('يومنون'));
    });

    test('Levenshtein similarity calculation handles identical and divergent words accurately', () {
      expect(QuranRecitationMatcher.calculateSimilarity('الله', 'الله'), equals(1.0));
      expect(QuranRecitationMatcher.calculateSimilarity('الرحمن', 'الرحيم'), inInclusiveRange(0.4, 0.7));
      expect(QuranRecitationMatcher.calculateSimilarity('', 'كلمة'), equals(0.0));
    });

    test('Initializes words for an Ayah preserving canonical text and setting initial hidden state', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        pageNumber: 1,
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(ayah);

      expect(words.length, equals(4));
      expect(words[0].canonicalText, equals('بِسْمِ'));
      expect(words[0].normalizedText, equals('بسم'));
      expect(words[0].state, equals(RecitationWordState.hidden));

      expect(words[1].canonicalText, equals('ٱللَّهِ'));
      expect(words[1].normalizedText, equals('الله'));

      expect(words[2].canonicalText, equals('ٱلرَّحْمَٰنِ'));
      expect(words[2].normalizedText, equals('الرحمن'));

      expect(words[3].canonicalText, equals('ٱلرَّحِيمِ'));
      expect(words[3].normalizedText, equals('الرحيم'));
    });

    test('Exact match confirms word and returns confirmed confidence level', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        pageNumber: 1,
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(ayah);

      final result = QuranRecitationMatcher.matchToken(
        words: words,
        currentIndex: 0,
        speechToken: 'بِسْمِ',
      );

      expect(result.isMatch, isTrue);
      expect(result.matchedIndex, equals(0));
      expect(result.confidenceLevel, equals(RecitationWordConfidence.confirmed));
      expect(result.confidence, equals(1.0));
    });

    test('Absorbs stutter / hesitation when user repeats a previous word (§10)', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        pageNumber: 1,
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(ayah);

      // User recited word 0 (بسم) and pointer moved to index 1 (الله)
      // Now user repeats 'بسم' by hesitation
      final result = QuranRecitationMatcher.matchToken(
        words: words,
        currentIndex: 1,
        speechToken: 'بسم',
      );

      expect(result.isMatch, isFalse);
      expect(result.isHesitation, isTrue);
      expect(result.matchedIndex, equals(0));
    });

    test('Uncertain match marks word below confidence threshold', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        pageNumber: 1,
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(ayah);

      final result = QuranRecitationMatcher.matchToken(
        words: words,
        currentIndex: 0,
        speechToken: 'كتاب',
      );

      expect(result.isMatch, isFalse);
      expect(result.isHesitation, isFalse);
      expect(result.confidenceLevel, equals(RecitationWordConfidence.uncertain));
    });

    test('Lookahead matches word + 1 and reports current word in skippedIndices', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        pageNumber: 1,
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(ayah);

      // User skips 'بسم' (index 0) and recites 'الله' (index 1)
      final result = QuranRecitationMatcher.matchToken(
        words: words,
        currentIndex: 0,
        speechToken: 'الله',
      );

      expect(result.isMatch, isTrue);
      expect(result.matchedIndex, equals(1));
      expect(result.skippedIndices, equals([0]));
    });

    test('Lookahead matches word + 2 and reports words 0 and 1 in skippedIndices', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        pageNumber: 1,
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(ayah);

      // User skips 'بسم' (0) and 'الله' (1) and recites 'الرحمن' (2)
      final result = QuranRecitationMatcher.matchToken(
        words: words,
        currentIndex: 0,
        speechToken: 'الرحمن',
      );

      expect(result.isMatch, isTrue);
      expect(result.matchedIndex, equals(2));
      expect(result.skippedIndices, equals([0, 1]));
    });

    test('evaluateLookaheadMatch identifies match across candidate list and flags skipped words', () {
      final ayah = Ayah.create(
        surahNumber: 1,
        ayahNumber: 1,
        textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textSimple: 'بسم الله الرحمن الرحيم',
        pageNumber: 1,
        juzNumber: 1,
        hizbNumber: 1,
        rubNumber: 1,
        manzilNumber: 1,
      );

      final words = QuranRecitationMatcher.initializeWordsForAyah(ayah);
      final wordsMap = {1: words};

      final candidates = QuranRecitationMatcher.getLookaheadCandidates(
        wordsMap: wordsMap,
        currentAyahNumber: 1,
        currentWordIndex: 0,
        endAyah: 1,
        windowSize: 3,
      );

      expect(candidates.length, equals(3));
      expect(candidates[0].word.normalizedText, equals('بسم'));
      expect(candidates[1].word.normalizedText, equals('الله'));
      expect(candidates[2].word.normalizedText, equals('الرحمن'));

      // Speech token matches candidate 1 ('الله')
      final matchRes = QuranRecitationMatcher.evaluateLookaheadMatch(
        candidates: candidates,
        speechToken: 'الله',
      );

      expect(matchRes.isMatch, isTrue);
      expect(matchRes.matchedPointer?.wordIndex, equals(1));
      expect(matchRes.skippedPointers.length, equals(1));
      expect(matchRes.skippedPointers.first.wordIndex, equals(0));
    });
  });
}
