import 'package:equatable/equatable.dart';

/// Defines a deterministic target scope for recitation and memorization (§1, §2).
/// Immutable once a recitation session has started to preserve integrity.
class QuranRecitationTarget extends Equatable {
  final int surahNumber;
  final String surahNameArabic;
  final int startAyah;
  final int endAyah;
  final int? pageNumber;
  final int? juzNumber;

  const QuranRecitationTarget({
    required this.surahNumber,
    required this.surahNameArabic,
    required this.startAyah,
    required this.endAyah,
    this.pageNumber,
    this.juzNumber,
  })  : assert(surahNumber >= 1 && surahNumber <= 114, 'Surah must be 1..114'),
        assert(startAyah >= 1, 'startAyah must be >= 1'),
        assert(endAyah >= startAyah, 'endAyah must be >= startAyah');

  /// Total number of Ayahs in this recitation target.
  int get ayahCount => (endAyah - startAyah) + 1;

  /// Whether a specific Ayah falls inside this target range.
  bool containsAyah(int ayahNumber) =>
      ayahNumber >= startAyah && ayahNumber <= endAyah;

  /// Label for UI display (e.g., 'سورة البقرة: الآيات ١ — ٥').
  String formatArabicRange() {
    if (startAyah == endAyah) {
      return 'سورة $surahNameArabic: الآية $startAyah';
    }
    return 'سورة $surahNameArabic: الآيات $startAyah — $endAyah';
  }

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahNameArabic': surahNameArabic,
        'startAyah': startAyah,
        'endAyah': endAyah,
        'pageNumber': pageNumber,
        'juzNumber': juzNumber,
      };

  factory QuranRecitationTarget.fromJson(Map<String, dynamic> json) =>
      QuranRecitationTarget(
        surahNumber: json['surahNumber'] as int,
        surahNameArabic: json['surahNameArabic'] as String? ?? '',
        startAyah: json['startAyah'] as int,
        endAyah: json['endAyah'] as int,
        pageNumber: json['pageNumber'] as int?,
        juzNumber: json['juzNumber'] as int?,
      );

  @override
  List<Object?> get props => [
        surahNumber,
        surahNameArabic,
        startAyah,
        endAyah,
        pageNumber,
        juzNumber,
      ];
}
