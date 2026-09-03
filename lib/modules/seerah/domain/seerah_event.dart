import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'historical_date.dart';
import 'historical_evidence_level.dart';
import 'moral_lesson.dart';
import 'narrative_variant.dart';

/// Canonical, immutable Seerah Event entity (§5, §12, §15, §29).
class SeerahEvent extends Equatable {
  final String eventId;
  final String title;
  final String periodId;
  final HistoricalDate historicalDate;
  final String? locationId;
  final List<String> participantIds;
  final String summary;
  final HistoricalEvidenceLevel evidenceLevel;
  final List<String> sourceIds;
  final List<NarrativeVariant> variants;
  final List<MoralLesson> moralLessons;
  final List<String> relatedQuranAyahs;
  final List<String> relatedHadithIds;
  final bool isOrderUncertain;
  final int version;
  final String reviewState;
  final String integrityHash;

  const SeerahEvent({
    required this.eventId,
    required this.title,
    required this.periodId,
    required this.historicalDate,
    this.locationId,
    this.participantIds = const [],
    required this.summary,
    this.evidenceLevel = HistoricalEvidenceLevel.strongReport,
    required this.sourceIds,
    this.variants = const [],
    this.moralLessons = const [],
    this.relatedQuranAyahs = const [],
    this.relatedHadithIds = const [],
    this.isOrderUncertain = false,
    this.version = 1,
    this.reviewState = 'APPROVED',
    required this.integrityHash,
  });

  factory SeerahEvent.create({
    required String eventId,
    required String title,
    required String periodId,
    required HistoricalDate historicalDate,
    String? locationId,
    List<String> participantIds = const [],
    required String summary,
    HistoricalEvidenceLevel evidenceLevel = HistoricalEvidenceLevel.strongReport,
    required List<String> sourceIds,
    List<NarrativeVariant> variants = const [],
    List<MoralLesson> moralLessons = const [],
    List<String> relatedQuranAyahs = const [],
    List<String> relatedHadithIds = const [],
    bool isOrderUncertain = false,
    int version = 1,
    String reviewState = 'APPROVED',
  }) {
    final participantsPayload = participantIds.join(',');
    final sourcesPayload = sourceIds.join(',');
    final variantsPayload = variants.map((v) => v.integrityHash).join(';');
    final quranPayload = relatedQuranAyahs.join(',');
    final hadithPayload = relatedHadithIds.join(',');
    final dPayload = '${historicalDate.hijriYear}:${historicalDate.precision.name}:${historicalDate.dateDisplay}';

    final payload = '$eventId|$title|$periodId|$dPayload|${locationId ?? ''}|$participantsPayload|$summary|${evidenceLevel.name}|$sourcesPayload|$variantsPayload|$quranPayload|$hadithPayload|$isOrderUncertain|$version|$reviewState';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return SeerahEvent(
      eventId: eventId,
      title: title,
      periodId: periodId,
      historicalDate: historicalDate,
      locationId: locationId,
      participantIds: participantIds,
      summary: summary,
      evidenceLevel: evidenceLevel,
      sourceIds: sourceIds,
      variants: variants,
      moralLessons: moralLessons,
      relatedQuranAyahs: relatedQuranAyahs,
      relatedHadithIds: relatedHadithIds,
      isOrderUncertain: isOrderUncertain,
      version: version,
      reviewState: reviewState,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    for (final v in variants) {
      if (!v.verifyHash()) return false;
    }
    final participantsPayload = participantIds.join(',');
    final sourcesPayload = sourceIds.join(',');
    final variantsPayload = variants.map((v) => v.integrityHash).join(';');
    final quranPayload = relatedQuranAyahs.join(',');
    final hadithPayload = relatedHadithIds.join(',');
    final dPayload = '${historicalDate.hijriYear}:${historicalDate.precision.name}:${historicalDate.dateDisplay}';

    final payload = '$eventId|$title|$periodId|$dPayload|${locationId ?? ''}|$participantsPayload|$summary|${evidenceLevel.name}|$sourcesPayload|$variantsPayload|$quranPayload|$hadithPayload|$isOrderUncertain|$version|$reviewState';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'event_id': eventId,
      'title': title,
      'period_id': periodId,
      'historical_date': historicalDate.toMap(),
      'location_id': locationId,
      'participant_ids': participantIds,
      'summary': summary,
      'evidence_level': evidenceLevel.name,
      'source_ids': sourceIds,
      'variants': variants.map((v) => v.toMap()).toList(),
      'moral_lessons': moralLessons.map((m) => m.toMap()).toList(),
      'related_quran_ayahs': relatedQuranAyahs,
      'related_hadith_ids': relatedHadithIds,
      'is_order_uncertain': isOrderUncertain,
      'version': version,
      'review_state': reviewState,
      'integrity_hash': integrityHash,
    };
  }

  factory SeerahEvent.fromMap(Map<String, dynamic> map) {
    final rawParticipants = map['participant_ids'] as List<dynamic>? ?? [];
    final rawSources = map['source_ids'] as List<dynamic>? ?? [];
    final rawVariants = map['variants'] as List<dynamic>? ?? [];
    final rawLessons = map['moral_lessons'] as List<dynamic>? ?? [];
    final rawQuran = map['related_quran_ayahs'] as List<dynamic>? ?? [];
    final rawHadith = map['related_hadith_ids'] as List<dynamic>? ?? [];

    return SeerahEvent(
      eventId: map['event_id'] as String,
      title: map['title'] as String,
      periodId: map['period_id'] as String,
      historicalDate: HistoricalDate.fromMap(map['historical_date'] as Map<String, dynamic>),
      locationId: map['location_id'] as String?,
      participantIds: rawParticipants.map((e) => e.toString()).toList(),
      summary: map['summary'] as String,
      evidenceLevel: HistoricalEvidenceLevel.values.byName(map['evidence_level'] as String? ?? 'strongReport'),
      sourceIds: rawSources.map((e) => e.toString()).toList(),
      variants: rawVariants.map((v) => NarrativeVariant.fromMap(v as Map<String, dynamic>)).toList(),
      moralLessons: rawLessons.map((m) => MoralLesson.fromMap(m as Map<String, dynamic>)).toList(),
      relatedQuranAyahs: rawQuran.map((e) => e.toString()).toList(),
      relatedHadithIds: rawHadith.map((e) => e.toString()).toList(),
      isOrderUncertain: map['is_order_uncertain'] as bool? ?? false,
      version: map['version'] as int? ?? 1,
      reviewState: map['review_state'] as String? ?? 'APPROVED',
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        eventId,
        title,
        periodId,
        historicalDate,
        locationId,
        participantIds,
        summary,
        evidenceLevel,
        sourceIds,
        variants,
        moralLessons,
        relatedQuranAyahs,
        relatedHadithIds,
        isOrderUncertain,
        version,
        reviewState,
        integrityHash,
      ];
}
