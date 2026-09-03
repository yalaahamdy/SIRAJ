import 'dart:math';
import '../../domain/ayah.dart';
import '../domain/quran_recitation_word.dart';


/// Quran-aware Arabic text normalization, token matching, and word alignment (§8, §9).
/// Strictly maintains canonical text immutability: normalization is performed ONLY
/// on transient string copies for recognition comparison.
class QuranRecitationMatcher {
  const QuranRecitationMatcher();

  /// Regex matching Arabic diacritics (Harakat, Tanween, Shaddah, Sukun, Dagger Alif, Maddah, etc.).
  static final RegExp _diacriticsRegex = RegExp(
    r'[\u064B-\u065F\u0670\u06D6-\u06ED\u0610-\u061A\u08D4-\u08E1\u08E3-\u08FF]',
  );

  /// Quranic pause marks, end-of-ayah signs, ornamentation, and ayah numbers.
  static final RegExp _quranPunctuationRegex = RegExp(
    r'[\u0600-\u0605\u06D6-\u06DC\u06DD\u06DE\u06DF\u06E0-\u06E9\u06EA-\u06ED\uFD3E\uFD3F\u0660-\u06690-9.,:;!?()\[\]"«»\-\—]',
  );

  /// Strips Tashkeel, normalizes Hamzas, Taa Marbuta, and Alif Maqsura for robust speech comparison.
  /// Does NOT mutate any canonical storage.
  static String normalizeForRecognition(String input) {
    if (input.isEmpty) return '';

    var text = input;

    // 1. Remove Tatweel (Kashida)
    text = text.replaceAll('\u0640', '');

    // 2. Remove all diacritics and Quranic annotations
    text = text.replaceAll(_diacriticsRegex, '');
    text = text.replaceAll(_quranPunctuationRegex, '');

    // 3. Normalize Alif variations (أ, إ, آ, ٱ -> ا)
    text = text.replaceAll(RegExp(r'[\u0622\u0623\u0625\u0671]'), '\u0627');

    // 4. Normalize Taa Marbuta (ة -> ه)
    text = text.replaceAll('\u0629', '\u0647');

    // 5. Normalize Alif Maqsura (ى -> ي)
    text = text.replaceAll('\u0649', '\u064A');

    // 6. Normalize Waw with Hamza and Yaa with Hamza (ؤ -> و, ئ -> ي)
    text = text.replaceAll('\u0624', '\u0648');
    text = text.replaceAll('\u0626', '\u064A');

    // 7. Trim and collapse whitespace
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  /// Calculates Levenshtein similarity (0.0 to 1.0) between two normalized strings.
  static double calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final len1 = s1.length;
    final len2 = s2.length;
    final matrix = List.generate(
      len1 + 1,
      (i) => List<int>.filled(len2 + 1, 0),
    );

    for (var i = 0; i <= len1; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j <= len2; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= len1; i++) {
      for (var j = 1; j <= len2; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = min(
          matrix[i - 1][j] + 1, // deletion
          min(
            matrix[i][j - 1] + 1, // insertion
            matrix[i - 1][j - 1] + cost, // substitution
          ),
        );
      }
    }

    final distance = matrix[len1][len2];
    final maxLength = max(len1, len2);
    return (1.0 - (distance / maxLength)).clamp(0.0, 1.0);
  }

  /// Evaluates whether a spoken word matches the target Quranic word,
  /// distinguishing minor pronunciation/phonetic variations from completely different words.
  static RecitationMatchResult evaluateWordMatch(String targetNormalized, String spokenNormalized) {
    if (targetNormalized.isEmpty || spokenNormalized.isEmpty) {
      return const RecitationMatchResult(isMatch: false, isMistake: false, confidence: 0.0);
    }

    final t = targetNormalized.trim();
    final s = spokenNormalized.trim();

    if (t == s) {
      return const RecitationMatchResult(isMatch: true, isMistake: false, confidence: 1.0);
    }

    final similarity = calculateSimilarity(t, s);

    // 1. Short words (length <= 3): Consonants must be almost identical
    if (t.length <= 3 || s.length <= 3) {
      if (similarity >= 0.85) {
        return RecitationMatchResult(isMatch: true, isMistake: false, confidence: similarity);
      } else {
        return RecitationMatchResult(isMatch: false, isMistake: true, confidence: similarity);
      }
    }

    // 2. Medium words (length 4 to 5):
    if (t.length <= 5) {
      final tHasAl = t.startsWith('ال');
      final sHasAl = s.startsWith('ال');
      if (tHasAl != sHasAl) {
        final tStem = tHasAl ? t.substring(2) : t;
        final sStem = sHasAl ? s.substring(2) : s;
        final stemSim = calculateSimilarity(tStem, sStem);
        if (stemSim >= 0.80) {
          return RecitationMatchResult(isMatch: true, isMistake: false, confidence: stemSim);
        }
      }

      if (similarity >= 0.75) {
        return RecitationMatchResult(isMatch: true, isMistake: false, confidence: similarity);
      } else if (similarity < 0.55) {
        return RecitationMatchResult(isMatch: false, isMistake: true, confidence: similarity);
      } else {
        return RecitationMatchResult(isMatch: false, isMistake: false, confidence: similarity);
      }
    }

    // 3. Long words (length >= 6):
    if (similarity >= 0.70) {
      return RecitationMatchResult(isMatch: true, isMistake: false, confidence: similarity);
    } else if (similarity < 0.50) {
      return RecitationMatchResult(isMatch: false, isMistake: true, confidence: similarity);
    } else {
      return RecitationMatchResult(isMatch: false, isMistake: false, confidence: similarity);
    }
  }

  /// Tokenizes an Ayah's canonical text into individual words while preserving canonical purity.
  static List<QuranRecitationWord> initializeWordsForAyah(Ayah ayah) {
    final rawWords = ayah.textUthmani
        .split(RegExp(r'\s+'))
        .where((w) => w.trim().isNotEmpty)
        .toList();

    return List.generate(rawWords.length, (index) {
      final canonical = rawWords[index].trim();
      final normalized = normalizeForRecognition(canonical);
      return QuranRecitationWord(
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        wordIndex: index,
        canonicalText: canonical,
        normalizedText: normalized,
        state: RecitationWordState.hidden,
      );
    });
  }

  /// Attempts to match an incoming recognized speech token against the expected word sequence.
  /// Supports:
  /// - Exact match
  /// - High phonetic similarity (>= 0.82)
  /// - Absorbing stutter / hesitation (repeated token matching current or last word)
  /// - Lookahead window of 1 word to handle minor omissions
  static RecitationMatchResult matchToken({
    required List<QuranRecitationWord> words,
    required int currentIndex,
    required String speechToken,
  }) {
    if (currentIndex < 0 || currentIndex >= words.length) {
      return RecitationMatchResult.noMatch();
    }

    final normalizedSpeech = normalizeForRecognition(speechToken);
    if (normalizedSpeech.isEmpty) {
      return RecitationMatchResult.noMatch();
    }

    // 1. Check if user is repeating the previous word (stutter / hesitation tolerance §10)
    if (currentIndex > 0) {
      final prevWord = words[currentIndex - 1];
      final prevSim = calculateSimilarity(prevWord.normalizedText, normalizedSpeech);
      if (prevSim >= 0.85) {
        // Absorbed hesitation: don't advance, don't fail session
        return RecitationMatchResult.hesitationAbsorbed(
          matchedIndex: currentIndex - 1,
        );
      }
    }

    // 2. Check exact or high similarity with current expected word
    final currentWord = words[currentIndex];
    final currentSim = calculateSimilarity(currentWord.normalizedText, normalizedSpeech);

    if (currentSim >= 0.85) {
      return RecitationMatchResult.matched(
        matchedIndex: currentIndex,
        confidence: currentSim,
        confidenceLevel: RecitationWordConfidence.confirmed,
        recognizerToken: speechToken,
      );
    } else if (currentSim >= 0.70) {
      return RecitationMatchResult.matched(
        matchedIndex: currentIndex,
        confidence: currentSim,
        confidenceLevel: RecitationWordConfidence.probable,
        recognizerToken: speechToken,
      );
    }

    // 3. Lookahead window of 1 word (user may have slightly blurred a particle)
    if (currentIndex + 1 < words.length) {
      final nextWord = words[currentIndex + 1];
      final nextSim = calculateSimilarity(nextWord.normalizedText, normalizedSpeech);
      if (nextSim >= 0.85) {
        return RecitationMatchResult.matched(
          matchedIndex: currentIndex + 1,
          confidence: nextSim,
          confidenceLevel: RecitationWordConfidence.confirmed,
          recognizerToken: speechToken,
        );
      }
    }

    // Unmatched token
    return RecitationMatchResult.uncertain(
      matchedIndex: currentIndex,
      similarity: currentSim,
      recognizerToken: speechToken,
    );
  }
}

/// Result of matching a speech token against the recitation word sequence.
class RecitationMatchResult {
  final bool isMatch;
  final bool isMistake;
  final bool isHesitation;
  final int? matchedIndex;
  final double confidence;
  final RecitationWordConfidence confidenceLevel;
  final String? recognizerToken;

  const RecitationMatchResult({
    required this.isMatch,
    this.isMistake = false,
    this.isHesitation = false,
    this.matchedIndex,
    this.confidence = 0.0,
    this.confidenceLevel = RecitationWordConfidence.notRecognized,
    this.recognizerToken,
  });

  double get similarity => confidence;

  factory RecitationMatchResult.matched({
    required int matchedIndex,
    required double confidence,
    required RecitationWordConfidence confidenceLevel,
    required String recognizerToken,
  }) =>
      RecitationMatchResult(
        isMatch: true,
        matchedIndex: matchedIndex,
        confidence: confidence,
        confidenceLevel: confidenceLevel,
        recognizerToken: recognizerToken,
      );

  factory RecitationMatchResult.mistake({
    required double similarity,
    String? recognizerToken,
  }) =>
      RecitationMatchResult(
        isMatch: false,
        isMistake: true,
        confidence: similarity,
        recognizerToken: recognizerToken,
      );

  factory RecitationMatchResult.hesitationAbsorbed({
    required int matchedIndex,
  }) =>
      RecitationMatchResult(
        isMatch: false,
        isHesitation: true,
        matchedIndex: matchedIndex,
      );

  factory RecitationMatchResult.uncertain({
    required int matchedIndex,
    required double similarity,
    required String recognizerToken,
  }) =>
      RecitationMatchResult(
        isMatch: false,
        matchedIndex: matchedIndex,
        confidence: similarity,
        confidenceLevel: RecitationWordConfidence.uncertain,
        recognizerToken: recognizerToken,
      );

  factory RecitationMatchResult.noMatch() => const RecitationMatchResult(
        isMatch: false,
      );
}
