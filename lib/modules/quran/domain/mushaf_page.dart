import 'package:equatable/equatable.dart';
import 'ayah.dart';

/// Immutable representation of a single Madinah Mushaf Page (1..604).
class MushafPage extends Equatable implements Comparable<MushafPage> {
  final int pageNumber;
  final int juzNumber;
  final int hizbNumber;
  final List<String> surahNames;
  final List<Ayah> ayahs;

  const MushafPage({
    required this.pageNumber,
    required this.juzNumber,
    required this.hizbNumber,
    required this.surahNames,
    required this.ayahs,
  })  : assert(pageNumber >= 1 && pageNumber <= 604, 'Page number must be 1..604'),
        assert(juzNumber >= 1 && juzNumber <= 30, 'Juz must be 1..30');

  @override
  int compareTo(MushafPage other) => pageNumber.compareTo(other.pageNumber);

  @override
  List<Object?> get props => [
        pageNumber,
        juzNumber,
        hizbNumber,
        surahNames,
        ayahs,
      ];
}
