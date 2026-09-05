import 'package:equatable/equatable.dart';

/// Lifecycle state of a word during recitation recognition (§10, §11).
enum RecitationWordState {
  /// Word is hidden from the user during recitation.
  hidden,

  /// Word was recognized by the speech engine above threshold.
  recognized,

  /// Word matching is ambiguous or confidence is below safe threshold.
  uncertain,

  /// Word was manually unhidden by tapping 'إظهار الكلمة'.
  revealed,

  /// Word was identified as a pronunciation/word mistake.
  mistake,
}

/// Disclosed confidence level for recitation evaluation (§12).
/// System explicitly refrains from claiming categorical religious correctness.
enum RecitationWordConfidence {
  /// Confirmed match above 0.85 normalized similarity.
  confirmed,

  /// Probable match between 0.70 and 0.85 normalized similarity.
  probable,

  /// Uncertain match below 0.70 normalized similarity.
  uncertain,

  /// Not recognized / speech not detected for this word.
  notRecognized,
}

/// Granular representation of a single word in a recitation verse.
class QuranRecitationWord extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final int wordIndex;

  /// Pure canonical Quran word with Uthmani script and diacritics.
  /// Strictly preserved without any mutation.
  final String canonicalText;

  /// Normalized copy generated strictly for recognition comparison.
  final String normalizedText;

  final RecitationWordState state;
  final double confidence;
  final RecitationWordConfidence confidenceLevel;
  final DateTime? recognizedAt;
  final String? recognizerToken;

  const QuranRecitationWord({
    required this.surahNumber,
    required this.ayahNumber,
    required this.wordIndex,
    required this.canonicalText,
    required this.normalizedText,
    this.state = RecitationWordState.hidden,
    this.confidence = 0.0,
    this.confidenceLevel = RecitationWordConfidence.notRecognized,
    this.recognizedAt,
    this.recognizerToken,
  });

  /// Whether the word is visible in the UI (recognized, revealed, or mistake).
  bool get isVisible =>
      state == RecitationWordState.recognized ||
      state == RecitationWordState.revealed ||
      state == RecitationWordState.mistake;

  /// Whether this word was flagged as an omission or pronunciation mistake.
  bool get isMistake => state == RecitationWordState.mistake;

  QuranRecitationWord copyWith({
    RecitationWordState? state,
    double? confidence,
    RecitationWordConfidence? confidenceLevel,
    DateTime? recognizedAt,
    String? recognizerToken,
  }) {
    return QuranRecitationWord(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      wordIndex: wordIndex,
      canonicalText: canonicalText,
      normalizedText: normalizedText,
      state: state ?? this.state,
      confidence: confidence ?? this.confidence,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      recognizedAt: recognizedAt ?? this.recognizedAt,
      recognizerToken: recognizerToken ?? this.recognizerToken,
    );
  }

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'wordIndex': wordIndex,
        'canonicalText': canonicalText,
        'normalizedText': normalizedText,
        'state': state.name,
        'confidence': confidence,
        'confidenceLevel': confidenceLevel.name,
        'recognizedAt': recognizedAt?.toIso8601String(),
        'recognizerToken': recognizerToken,
      };

  @override
  List<Object?> get props => [
        surahNumber,
        ayahNumber,
        wordIndex,
        canonicalText,
        normalizedText,
        state,
        confidence,
        confidenceLevel,
        recognizedAt,
        recognizerToken,
      ];
}

/// Token emitted by speech recognition engines before alignment.
class QuranRecitationToken extends Equatable {
  final String rawText;
  final String normalizedText;
  final double confidence;
  final DateTime timestamp;
  final bool isPartial;

  const QuranRecitationToken({
    required this.rawText,
    required this.normalizedText,
    required this.confidence,
    required this.timestamp,
    this.isPartial = false,
  });

  @override
  List<Object?> get props => [
        rawText,
        normalizedText,
        confidence,
        timestamp,
        isPartial,
      ];
}
