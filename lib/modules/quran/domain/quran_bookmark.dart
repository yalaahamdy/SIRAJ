import 'package:equatable/equatable.dart';

/// User-specific bookmark entity stored strictly in `mod_quran` without modifying canonical text.
class QuranBookmark extends Equatable {
  final String id;
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final String surahNameArabic;
  final String ayahSnippet;
  final String? note;
  final DateTime createdAtUtc;

  const QuranBookmark({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.surahNameArabic,
    required this.ayahSnippet,
    this.note,
    required this.createdAtUtc,
  });

  factory QuranBookmark.fromMap(Map<String, dynamic> map) {
    return QuranBookmark(
      id: map['id'] as String,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      pageNumber: map['page_number'] as int,
      surahNameArabic: map['surah_name_arabic'] as String? ?? '',
      ayahSnippet: map['ayah_snippet'] as String? ?? '',
      note: map['note'] as String?,
      createdAtUtc: DateTime.parse(map['created_at_utc'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'page_number': pageNumber,
      'surah_name_arabic': surahNameArabic,
      'ayah_snippet': ayahSnippet,
      if (note != null) 'note': note,
      'created_at_utc': createdAtUtc.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        surahNumber,
        ayahNumber,
        pageNumber,
        surahNameArabic,
        ayahSnippet,
        note,
        createdAtUtc,
      ];
}
