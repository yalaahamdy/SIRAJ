import 'package:equatable/equatable.dart';

enum SourceType {
  primary,
  secondary,
}

/// Structured reference to the authentic canonical source.
class SourceRef extends Equatable {
  final String reference;
  final SourceType type;
  final bool chainSecondary;
  final String? bookTitle;
  final String? editionOrVerification;
  final String? volumeAndPage;
  final String? itemNumber;

  const SourceRef({
    required this.reference,
    this.type = SourceType.primary,
    this.chainSecondary = false,
    this.bookTitle,
    this.editionOrVerification,
    this.volumeAndPage,
    this.itemNumber,
  });

  @override
  List<Object?> get props => [
        reference,
        type,
        chainSecondary,
        bookTitle,
        editionOrVerification,
        volumeAndPage,
        itemNumber,
      ];
}

/// Attribution metadata for prophetic or scholarly statements.
class Attribution extends Equatable {
  final String to;
  final bool verifiedByRef;

  const Attribution({
    required this.to,
    required this.verifiedByRef,
  });

  @override
  List<Object?> get props => [to, verifiedByRef];
}

/// Scholarly grading for Hadith content.
class HadithGrade extends Equatable {
  final String gradeValue; // e.g., "صحيح"
  final String givenBy; // e.g., "مسلم في صحيحه"
  final List<String> conflictingGrades;

  const HadithGrade({
    required this.gradeValue,
    required this.givenBy,
    this.conflictingGrades = const [],
  });

  @override
  List<Object?> get props => [gradeValue, givenBy, conflictingGrades];
}

/// Jurisprudence details (for rulings and devotion calculations).
class JurisprudenceMetadata extends Equatable {
  final String? school;
  final bool disagreementNoted;
  final String? context;

  const JurisprudenceMetadata({
    this.school,
    this.disagreementNoted = false,
    this.context,
  });

  @override
  List<Object?> get props => [school, disagreementNoted, context];
}

/// Named human review record (Law 6 & Gate 6 compliance).
class HumanReviewRecord extends Equatable {
  final String reviewerName;
  final String reviewerRole;
  final DateTime reviewedAt;
  final String verdict; // APPROVED or REJECTED
  final String? notes;

  const HumanReviewRecord({
    required this.reviewerName,
    required this.reviewerRole,
    required this.reviewedAt,
    required this.verdict,
    this.notes,
  });

  @override
  List<Object?> get props => [
        reviewerName,
        reviewerRole,
        reviewedAt,
        verdict,
        notes,
      ];
}
