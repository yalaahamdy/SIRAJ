import 'package:equatable/equatable.dart';

/// Deterministic, unambiguous identifier for an Ayah (surahNumber:ayahNumber).
class AyahKey extends Equatable implements Comparable<AyahKey> {
  final int surahNumber;
  final int ayahNumber;

  const AyahKey({
    required this.surahNumber,
    required this.ayahNumber,
  })  : assert(surahNumber >= 1 && surahNumber <= 114, 'Surah number must be between 1 and 114'),
        assert(ayahNumber >= 1, 'Ayah number must be >= 1');

  /// Parses a key string in format "surah:ayah" or "surahNumber:ayahNumber".
  factory AyahKey.parse(String keyStr) {
    final parts = keyStr.split(':');
    if (parts.length < 2) {
      throw FormatException('Invalid AyahKey format: $keyStr');
    }
    // Handle prefixed keys like "quran:uthmani:1:1" or simple "1:1"
    final sStr = parts[parts.length - 2];
    final aStr = parts[parts.length - 1];

    final s = int.parse(sStr);
    final a = int.parse(aStr);
    return AyahKey(surahNumber: s, ayahNumber: a);
  }

  @override
  String toString() => '$surahNumber:$ayahNumber';

  /// Generates the canonical full identifier.
  String toCanonicalId(String editionId) => 'quran:$editionId:$surahNumber:$ayahNumber';

  @override
  int compareTo(AyahKey other) {
    if (surahNumber != other.surahNumber) {
      return surahNumber.compareTo(other.surahNumber);
    }
    return ayahNumber.compareTo(other.ayahNumber);
  }

  @override
  List<Object?> get props => [surahNumber, ayahNumber];
}
