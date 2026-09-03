import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'authenticity_grade.dart';
import 'dhikr_occasion.dart';
import 'dhikr_type.dart';
import 'repetition_provenance.dart';

/// Immutable Canonical Dhikr / Dua Entity with rigorous provenance (§5, §10).
class DhikrItem extends Equatable {
  final String id;
  final DhikrType type;
  final String textArabic;
  final String sourceTitle;
  final String sourceAuthor;
  final String reference;
  final AuthenticityGrade authenticityGrade;
  final String attribution;
  final DhikrOccasion occasion;
  final RepetitionProvenance repetition;
  final String? benefit;
  final String integrityHash;

  const DhikrItem({
    required this.id,
    required this.type,
    required this.textArabic,
    required this.sourceTitle,
    required this.sourceAuthor,
    required this.reference,
    required this.authenticityGrade,
    required this.attribution,
    required this.occasion,
    required this.repetition,
    this.benefit,
    required this.integrityHash,
  }) : assert(id.length >= 3, 'Dhikr ID must be at least 3 characters');

  static String computeHash({
    required String id,
    required DhikrType type,
    required String textArabic,
    required String sourceTitle,
    required String sourceAuthor,
    required String reference,
    required AuthenticityGrade authenticityGrade,
    required String attribution,
    required int repetitionCount,
    required bool isSourced,
    required DhikrOccasion occasion,
  }) {
    final payload = '$id|${type.name}|$textArabic|$sourceTitle|$sourceAuthor|$reference|${authenticityGrade.name}|$attribution|$repetitionCount|$isSourced|${occasion.name}';
    final digest = sha256.convert(utf8.encode(payload)).toString();
    return 'sha256:$digest';
  }

  bool verifyHash() {
    final expected = computeHash(
      id: id,
      type: type,
      textArabic: textArabic,
      sourceTitle: sourceTitle,
      sourceAuthor: sourceAuthor,
      reference: reference,
      authenticityGrade: authenticityGrade,
      attribution: attribution,
      repetitionCount: repetition.count,
      isSourced: repetition.isSourced,
      occasion: occasion,
    );
    return integrityHash == expected;
  }

  factory DhikrItem.fromMap(Map<String, dynamic> map) {
    return DhikrItem(
      id: map['id'] as String,
      type: DhikrType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => DhikrType.transmittedDhikr,
      ),
      textArabic: map['text_arabic'] as String,
      sourceTitle: map['source_title'] as String,
      sourceAuthor: map['source_author'] as String,
      reference: map['reference'] as String,
      authenticityGrade: AuthenticityGrade.values.firstWhere(
        (g) => g.name == map['authenticity_grade'],
        orElse: () => AuthenticityGrade.unverified,
      ),
      attribution: map['attribution'] as String,
      occasion: DhikrOccasion.values.firstWhere(
        (o) => o.name == map['occasion'],
        orElse: () => DhikrOccasion.general,
      ),
      repetition: RepetitionProvenance.fromMap(map['repetition'] as Map<String, dynamic>),
      benefit: map['benefit'] as String?,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'text_arabic': textArabic,
      'source_title': sourceTitle,
      'source_author': sourceAuthor,
      'reference': reference,
      'authenticity_grade': authenticityGrade.name,
      'attribution': attribution,
      'occasion': occasion.name,
      'repetition': repetition.toMap(),
      if (benefit != null) 'benefit': benefit,
      'integrity_hash': integrityHash,
    };
  }

  @override
  List<Object?> get props => [
        id,
        type,
        textArabic,
        sourceTitle,
        sourceAuthor,
        reference,
        authenticityGrade,
        attribution,
        occasion,
        repetition,
        benefit,
        integrityHash,
      ];
}
