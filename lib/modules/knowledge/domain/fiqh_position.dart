import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'evidence_reference.dart';
import 'fiqh_school.dart';

/// Attributed jurisprudential opinion or school position on a specific topic (§13, §14).
class FiqhPosition extends Equatable {
  final String positionId;
  final FiqhSchool school;
  final String rulingText;
  final String? scholarName;
  final String sourceId;
  final String? pageReference;
  final List<EvidenceReference> evidences;
  final String integrityHash;

  const FiqhPosition({
    required this.positionId,
    required this.school,
    required this.rulingText,
    this.scholarName,
    required this.sourceId,
    this.pageReference,
    this.evidences = const [],
    required this.integrityHash,
  });

  factory FiqhPosition.create({
    required String positionId,
    required FiqhSchool school,
    required String rulingText,
    String? scholarName,
    required String sourceId,
    String? pageReference,
    List<EvidenceReference> evidences = const [],
  }) {
    final evidencesPayload = evidences.map((e) => e.integrityHash).join(';');
    final payload = '$positionId|${school.name}|$rulingText|${scholarName ?? ''}|$sourceId|${pageReference ?? ''}|$evidencesPayload';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return FiqhPosition(
      positionId: positionId,
      school: school,
      rulingText: rulingText,
      scholarName: scholarName,
      sourceId: sourceId,
      pageReference: pageReference,
      evidences: evidences,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final evidencesPayload = evidences.map((e) => e.integrityHash).join(';');
    final payload = '$positionId|${school.name}|$rulingText|${scholarName ?? ''}|$sourceId|${pageReference ?? ''}|$evidencesPayload';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'position_id': positionId,
      'school': school.name,
      'ruling_text': rulingText,
      'scholar_name': scholarName,
      'source_id': sourceId,
      'page_reference': pageReference,
      'evidences': evidences.map((e) => e.toMap()).toList(),
      'integrity_hash': integrityHash,
    };
  }

  factory FiqhPosition.fromMap(Map<String, dynamic> map) {
    final rawEvidences = map['evidences'] as List<dynamic>? ?? [];
    final evidences = rawEvidences.map((e) => EvidenceReference.fromMap(e as Map<String, dynamic>)).toList();

    return FiqhPosition(
      positionId: map['position_id'] as String,
      school: FiqhSchool.values.byName(map['school'] as String),
      rulingText: map['ruling_text'] as String,
      scholarName: map['scholar_name'] as String?,
      sourceId: map['source_id'] as String,
      pageReference: map['page_reference'] as String?,
      evidences: evidences,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        positionId,
        school,
        rulingText,
        scholarName,
        sourceId,
        pageReference,
        evidences,
        integrityHash,
      ];
}
