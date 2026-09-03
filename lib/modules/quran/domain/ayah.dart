import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'dart:convert';
import 'ayah_key.dart';

/// Immutable canonical entity representing a single Quranic Ayah.
class Ayah extends Equatable implements Comparable<Ayah> {
  final AyahKey key;
  final String textUthmani;
  final String textSimple;
  final int juzNumber;
  final int hizbNumber;
  final int rubNumber;
  final int pageNumber;
  final int manzilNumber;
  final bool hasSajdah;
  final int? sajdahNumber;
  final String integrityHash;

  const Ayah({
    required this.key,
    required this.textUthmani,
    required this.textSimple,
    required this.juzNumber,
    required this.hizbNumber,
    required this.rubNumber,
    required this.pageNumber,
    required this.manzilNumber,
    required this.hasSajdah,
    this.sajdahNumber,
    required this.integrityHash,
  })  : assert(juzNumber >= 1 && juzNumber <= 30, 'Juz must be 1..30'),
        assert(hizbNumber >= 1 && hizbNumber <= 60, 'Hizb must be 1..60'),
        assert(rubNumber >= 1 && rubNumber <= 240, 'Rub must be 1..240'),
        assert(pageNumber >= 1 && pageNumber <= 604, 'Page must be 1..604');

  int get surahNumber => key.surahNumber;
  int get ayahNumber => key.ayahNumber;

  /// Creates an Ayah with automatic SHA-256 integrity hash calculation.
  factory Ayah.create({
    required int surahNumber,
    required int ayahNumber,
    required String textUthmani,
    required String textSimple,
    required int juzNumber,
    required int hizbNumber,
    required int rubNumber,
    required int pageNumber,
    required int manzilNumber,
    bool hasSajdah = false,
    int? sajdahNumber,
  }) {
    final hash = computeHash(textUthmani);
    return Ayah(
      key: AyahKey(surahNumber: surahNumber, ayahNumber: ayahNumber),
      textUthmani: textUthmani,
      textSimple: textSimple,
      juzNumber: juzNumber,
      hizbNumber: hizbNumber,
      rubNumber: rubNumber,
      pageNumber: pageNumber,
      manzilNumber: manzilNumber,
      hasSajdah: hasSajdah,
      sajdahNumber: sajdahNumber,
      integrityHash: hash,
    );
  }

  factory Ayah.fromMap(Map<String, dynamic> map) {
    final surahNum = map['surah_number'] as int;
    final ayahNum = map['ayah_number'] as int;
    final textUthmani = map['text_uthmani'] as String;
    final textSimple = map['text_simple'] as String? ?? '';
    final storedHash = map['hash'] as String? ?? computeHash(textUthmani);

    return Ayah(
      key: AyahKey(surahNumber: surahNum, ayahNumber: ayahNum),
      textUthmani: textUthmani,
      textSimple: textSimple,
      juzNumber: map['juz'] as int? ?? 1,
      hizbNumber: map['hizb'] as int? ?? 1,
      rubNumber: map['rub'] as int? ?? 1,
      pageNumber: map['page'] as int? ?? 1,
      manzilNumber: map['manzil'] as int? ?? 1,
      hasSajdah: map['has_sajdah'] as bool? ?? false,
      sajdahNumber: map['sajdah_number'] as int?,
      integrityHash: storedHash,
    );
  }

  Map<String, dynamic> toMap(String editionId) {
    return {
      'id': key.toCanonicalId(editionId),
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'text_uthmani': textUthmani,
      'text_simple': textSimple,
      'juz': juzNumber,
      'hizb': hizbNumber,
      'rub': rubNumber,
      'page': pageNumber,
      'manzil': manzilNumber,
      'has_sajdah': hasSajdah,
      if (sajdahNumber != null) 'sajdah_number': sajdahNumber,
      'hash': integrityHash,
    };
  }

  /// Calculates SHA-256 hash of canonical Uthmani text.
  static String computeHash(String text) {
    final bytes = utf8.encode(text);
    final digest = sha256.convert(bytes);
    return 'sha256:${digest.toString()}';
  }

  /// Verifies whether the Uthmani text matches the stored integrity hash.
  bool verifyIntegrity() => computeHash(textUthmani) == integrityHash;

  @override
  int compareTo(Ayah other) => key.compareTo(other.key);

  @override
  List<Object?> get props => [
        key,
        textUthmani,
        textSimple,
        juzNumber,
        hizbNumber,
        rubNumber,
        pageNumber,
        manzilNumber,
        hasSajdah,
        sajdahNumber,
        integrityHash,
      ];
}
