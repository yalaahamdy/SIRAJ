import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

/// Types of primary and secondary textual evidences (§16).
enum EvidenceType {
  quranAyah('آية قرآنية'),
  hadith('حديث نبوي'),
  athar('أثر عن الصحابة/التابعين'),
  scholarlyConsensus('إجماع منقول'),
  qiyas('قياس / استدلال');

  final String labelArabic;
  const EvidenceType(this.labelArabic);
}

/// Structured model representing an evidence citation linked to a canonical or verified source (§16).
class EvidenceReference extends Equatable {
  final String evidenceId;
  final EvidenceType evidenceType;
  final String referenceKey; // e.g. "2:183" or "bukhari_1"
  final String displayCitation;
  final String? sourceId;
  final String? pageReference;
  final String? context;
  final String integrityHash;

  const EvidenceReference({
    required this.evidenceId,
    required this.evidenceType,
    required this.referenceKey,
    required this.displayCitation,
    this.sourceId,
    this.pageReference,
    this.context,
    required this.integrityHash,
  });

  factory EvidenceReference.create({
    required String evidenceId,
    required EvidenceType evidenceType,
    required String referenceKey,
    required String displayCitation,
    String? sourceId,
    String? pageReference,
    String? context,
  }) {
    final payload = '$evidenceId|${evidenceType.name}|$referenceKey|$displayCitation|${sourceId ?? ''}|${pageReference ?? ''}|${context ?? ''}';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return EvidenceReference(
      evidenceId: evidenceId,
      evidenceType: evidenceType,
      referenceKey: referenceKey,
      displayCitation: displayCitation,
      sourceId: sourceId,
      pageReference: pageReference,
      context: context,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final payload = '$evidenceId|${evidenceType.name}|$referenceKey|$displayCitation|${sourceId ?? ''}|${pageReference ?? ''}|${context ?? ''}';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'evidence_id': evidenceId,
      'evidence_type': evidenceType.name,
      'reference_key': referenceKey,
      'display_citation': displayCitation,
      'source_id': sourceId,
      'page_reference': pageReference,
      'context': context,
      'integrity_hash': integrityHash,
    };
  }

  factory EvidenceReference.fromMap(Map<String, dynamic> map) {
    return EvidenceReference(
      evidenceId: map['evidence_id'] as String,
      evidenceType: EvidenceType.values.byName(map['evidence_type'] as String),
      referenceKey: map['reference_key'] as String,
      displayCitation: map['display_citation'] as String,
      sourceId: map['source_id'] as String?,
      pageReference: map['page_reference'] as String?,
      context: map['context'] as String?,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        evidenceId,
        evidenceType,
        referenceKey,
        displayCitation,
        sourceId,
        pageReference,
        context,
        integrityHash,
      ];
}
