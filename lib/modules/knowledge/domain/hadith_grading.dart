import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

/// Standard authenticity grading classes for Hadith narrations (§10, §11).
enum HadithGrade {
  mutawatir('متواتر'),
  sahih('صحيح'),
  hasan('حسن'),
  daeef('ضعيف'),
  mawdoo('موضوع'),
  unverified('غير محقق');

  final String labelArabic;
  const HadithGrade(this.labelArabic);
}

/// Sourced and attributed Hadith grading entity (§10, §11).
class HadithGrading extends Equatable {
  final String gradingId;
  final HadithGrade grade;
  final String scholarName;
  final String sourceBook;
  final String? context;
  final String reviewState;
  final String integrityHash;

  const HadithGrading({
    required this.gradingId,
    required this.grade,
    required this.scholarName,
    required this.sourceBook,
    this.context,
    this.reviewState = 'APPROVED',
    required this.integrityHash,
  });

  factory HadithGrading.create({
    required String gradingId,
    required HadithGrade grade,
    required String scholarName,
    required String sourceBook,
    String? context,
    String reviewState = 'APPROVED',
  }) {
    final payload = '$gradingId|${grade.name}|$scholarName|$sourceBook|${context ?? ''}|$reviewState';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return HadithGrading(
      gradingId: gradingId,
      grade: grade,
      scholarName: scholarName,
      sourceBook: sourceBook,
      context: context,
      reviewState: reviewState,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final payload = '$gradingId|${grade.name}|$scholarName|$sourceBook|${context ?? ''}|$reviewState';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'grading_id': gradingId,
      'grade': grade.name,
      'scholar_name': scholarName,
      'source_book': sourceBook,
      'context': context,
      'review_state': reviewState,
      'integrity_hash': integrityHash,
    };
  }

  factory HadithGrading.fromMap(Map<String, dynamic> map) {
    return HadithGrading(
      gradingId: map['grading_id'] as String,
      grade: HadithGrade.values.byName(map['grade'] as String),
      scholarName: map['scholar_name'] as String,
      sourceBook: map['source_book'] as String,
      context: map['context'] as String?,
      reviewState: map['review_state'] as String? ?? 'APPROVED',
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        gradingId,
        grade,
        scholarName,
        sourceBook,
        context,
        reviewState,
        integrityHash,
      ];
}
