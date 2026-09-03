import 'package:equatable/equatable.dart';

/// Segregated linguistic and word-by-word data entity for deep Quranic reflection (§13, §14).
/// Completely separated from the canonical Arabic text to uphold Law 3.
class QuranWord extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final int wordNumber;
  final String textArabic;
  final String translation;
  final String transliteration;
  final String? morphologyNotes;

  const QuranWord({
    required this.surahNumber,
    required this.ayahNumber,
    required this.wordNumber,
    required this.textArabic,
    required this.translation,
    required this.transliteration,
    this.morphologyNotes,
  });

  factory QuranWord.fromJson(Map<String, dynamic> json) {
    return QuranWord(
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      wordNumber: json['word_number'] as int,
      textArabic: json['text_arabic'] as String,
      translation: json['translation'] as String,
      transliteration: json['transliteration'] as String? ?? '',
      morphologyNotes: json['morphology_notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
        'word_number': wordNumber,
        'text_arabic': textArabic,
        'translation': translation,
        'transliteration': transliteration,
        if (morphologyNotes != null) 'morphology_notes': morphologyNotes,
      };

  @override
  List<Object?> get props => [
        surahNumber,
        ayahNumber,
        wordNumber,
        textArabic,
        translation,
        transliteration,
        morphologyNotes,
      ];
}
