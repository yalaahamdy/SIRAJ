import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'historical_evidence_level.dart';

/// Narrative variant representing divergent scholarly or historical transmissions without collapsing (§13, §14).
class NarrativeVariant extends Equatable {
  final String variantId;
  final String eventId;
  final String narrativeSummary;
  final String narratorOrScholar;
  final String sourceId;
  final HistoricalEvidenceLevel evidenceLevel;
  final String? scholarlyNotes;
  final String integrityHash;

  const NarrativeVariant({
    required this.variantId,
    required this.eventId,
    required this.narrativeSummary,
    required this.narratorOrScholar,
    required this.sourceId,
    this.evidenceLevel = HistoricalEvidenceLevel.multipleSources,
    this.scholarlyNotes,
    required this.integrityHash,
  });

  factory NarrativeVariant.create({
    required String variantId,
    required String eventId,
    required String narrativeSummary,
    required String narratorOrScholar,
    required String sourceId,
    HistoricalEvidenceLevel evidenceLevel = HistoricalEvidenceLevel.multipleSources,
    String? scholarlyNotes,
  }) {
    final payload = '$variantId|$eventId|$narrativeSummary|$narratorOrScholar|$sourceId|${evidenceLevel.name}|${scholarlyNotes ?? ''}';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return NarrativeVariant(
      variantId: variantId,
      eventId: eventId,
      narrativeSummary: narrativeSummary,
      narratorOrScholar: narratorOrScholar,
      sourceId: sourceId,
      evidenceLevel: evidenceLevel,
      scholarlyNotes: scholarlyNotes,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final payload = '$variantId|$eventId|$narrativeSummary|$narratorOrScholar|$sourceId|${evidenceLevel.name}|${scholarlyNotes ?? ''}';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'variant_id': variantId,
      'event_id': eventId,
      'narrative_summary': narrativeSummary,
      'narrator_or_scholar': narratorOrScholar,
      'source_id': sourceId,
      'evidence_level': evidenceLevel.name,
      'scholarly_notes': scholarlyNotes,
      'integrity_hash': integrityHash,
    };
  }

  factory NarrativeVariant.fromMap(Map<String, dynamic> map) {
    return NarrativeVariant(
      variantId: map['variant_id'] as String,
      eventId: map['event_id'] as String,
      narrativeSummary: map['narrative_summary'] as String,
      narratorOrScholar: map['narrator_or_scholar'] as String,
      sourceId: map['source_id'] as String,
      evidenceLevel: HistoricalEvidenceLevel.values.byName(map['evidence_level'] as String? ?? 'multipleSources'),
      scholarlyNotes: map['scholarly_notes'] as String?,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        variantId,
        eventId,
        narrativeSummary,
        narratorOrScholar,
        sourceId,
        evidenceLevel,
        scholarlyNotes,
        integrityHash,
      ];
}
