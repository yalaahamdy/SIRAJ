import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

/// Link to an authoritative canonical textual evidence (§12).
class EvidenceLink extends Equatable {
  final String evidenceId;
  final String evidenceKey;
  final String citation;
  final String sourceId;
  final String? context;
  final String integrityHash;

  const EvidenceLink({
    required this.evidenceId,
    required this.evidenceKey,
    required this.citation,
    required this.sourceId,
    this.context,
    required this.integrityHash,
  });

  factory EvidenceLink.create({
    required String evidenceId,
    required String evidenceKey,
    required String citation,
    required String sourceId,
    String? context,
  }) {
    final payload = '$evidenceId|$evidenceKey|$citation|$sourceId|${context ?? ''}';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return EvidenceLink(
      evidenceId: evidenceId,
      evidenceKey: evidenceKey,
      citation: citation,
      sourceId: sourceId,
      context: context,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final payload = '$evidenceId|$evidenceKey|$citation|$sourceId|${context ?? ''}';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'evidence_id': evidenceId,
      'evidence_key': evidenceKey,
      'citation': citation,
      'source_id': sourceId,
      'context': context,
      'integrity_hash': integrityHash,
    };
  }

  factory EvidenceLink.fromMap(Map<String, dynamic> map) {
    return EvidenceLink(
      evidenceId: map['evidence_id'] as String,
      evidenceKey: map['evidence_key'] as String,
      citation: map['display_citation'] as String? ?? map['citation'] as String,
      sourceId: map['source_id'] as String,
      context: map['context'] as String?,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        evidenceId,
        evidenceKey,
        citation,
        sourceId,
        context,
        integrityHash,
      ];
}
