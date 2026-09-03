import 'package:equatable/equatable.dart';
import 'revelation_type.dart';

/// Immutable canonical entity representing a Quranic Surah (Chapter).
class Surah extends Equatable implements Comparable<Surah> {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final RevelationType revelationType;
  final int ayahCount;
  final int startPage;

  const Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.revelationType,
    required this.ayahCount,
    required this.startPage,
  })  : assert(number >= 1 && number <= 114, 'Surah number must be 1..114'),
        assert(ayahCount >= 1, 'Ayah count must be >= 1'),
        assert(startPage >= 1 && startPage <= 604, 'Start page must be 1..604');

  factory Surah.fromMap(Map<String, dynamic> map) {
    return Surah(
      number: map['number'] as int,
      nameArabic: map['name_arabic'] as String,
      nameEnglish: map['name_english'] as String,
      nameTransliteration: map['name_transliteration'] as String? ?? map['name_english'] as String,
      revelationType: (map['revelation_type'] as String).toLowerCase() == 'medinan'
          ? RevelationType.medinan
          : RevelationType.meccan,
      ayahCount: map['ayah_count'] as int,
      startPage: map['start_page'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name_arabic': nameArabic,
      'name_english': nameEnglish,
      'name_transliteration': nameTransliteration,
      'revelation_type': revelationType.nameEnglish,
      'ayah_count': ayahCount,
      'start_page': startPage,
    };
  }

  @override
  int compareTo(Surah other) => number.compareTo(other.number);

  @override
  List<Object?> get props => [
        number,
        nameArabic,
        nameEnglish,
        nameTransliteration,
        revelationType,
        ayahCount,
        startPage,
      ];
}
