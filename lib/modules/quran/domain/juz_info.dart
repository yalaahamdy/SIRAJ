import 'package:equatable/equatable.dart';

/// Metadata describing a Quranic Juz (1..30).
class JuzInfo extends Equatable implements Comparable<JuzInfo> {
  final int number;
  final int startSurahNumber;
  final int startAyahNumber;
  final int startPage;
  final String startAyahText;

  const JuzInfo({
    required this.number,
    required this.startSurahNumber,
    required this.startAyahNumber,
    required this.startPage,
    required this.startAyahText,
  })  : assert(number >= 1 && number <= 30, 'Juz number must be 1..30'),
        assert(startSurahNumber >= 1 && startSurahNumber <= 114, 'Start Surah must be 1..114'),
        assert(startPage >= 1 && startPage <= 604, 'Start Page must be 1..604');

  factory JuzInfo.fromMap(Map<String, dynamic> map) {
    return JuzInfo(
      number: map['number'] as int,
      startSurahNumber: map['start_surah_number'] as int,
      startAyahNumber: map['start_ayah_number'] as int,
      startPage: map['start_page'] as int,
      startAyahText: map['start_ayah_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'start_surah_number': startSurahNumber,
      'start_ayah_number': startAyahNumber,
      'start_page': startPage,
      'start_ayah_text': startAyahText,
    };
  }

  @override
  int compareTo(JuzInfo other) => number.compareTo(other.number);

  @override
  List<Object?> get props => [
        number,
        startSurahNumber,
        startAyahNumber,
        startPage,
        startAyahText,
      ];
}
