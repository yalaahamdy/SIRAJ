import 'package:equatable/equatable.dart';

/// User-specific reading progress and last read position.
class QuranReadingProgress extends Equatable {
  final int lastReadSurah;
  final int lastReadAyah;
  final int lastReadPage;
  final String surahNameArabic;
  final DateTime updatedAtUtc;

  const QuranReadingProgress({
    this.lastReadSurah = 1,
    this.lastReadAyah = 1,
    this.lastReadPage = 1,
    this.surahNameArabic = 'الفاتحة',
    required this.updatedAtUtc,
  });

  factory QuranReadingProgress.fromMap(Map<String, dynamic> map) {
    return QuranReadingProgress(
      lastReadSurah: map['last_read_surah'] as int? ?? 1,
      lastReadAyah: map['last_read_ayah'] as int? ?? 1,
      lastReadPage: map['last_read_page'] as int? ?? 1,
      surahNameArabic: map['surah_name_arabic'] as String? ?? 'الفاتحة',
      updatedAtUtc: DateTime.parse(map['updated_at_utc'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'last_read_surah': lastReadSurah,
      'last_read_ayah': lastReadAyah,
      'last_read_page': lastReadPage,
      'surah_name_arabic': surahNameArabic,
      'updated_at_utc': updatedAtUtc.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        lastReadSurah,
        lastReadAyah,
        lastReadPage,
        surahNameArabic,
        updatedAtUtc,
      ];
}
