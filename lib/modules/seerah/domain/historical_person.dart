import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'historical_date.dart';

/// Historical biography entity representing persons in Seerah & early Islam (§8, §9).
class HistoricalPerson extends Equatable {
  final String personId;
  final String canonicalName;
  final String? kunyah;
  final String? titleOrLakab;
  final String historicalRole;
  final HistoricalDate? birthDate;
  final HistoricalDate? deathDate;
  final String biographicalSummary;
  final List<String> sourceIds;
  final List<String> aliases;
  final String integrityHash;

  const HistoricalPerson({
    required this.personId,
    required this.canonicalName,
    this.kunyah,
    this.titleOrLakab,
    required this.historicalRole,
    this.birthDate,
    this.deathDate,
    required this.biographicalSummary,
    required this.sourceIds,
    this.aliases = const [],
    required this.integrityHash,
  });

  factory HistoricalPerson.create({
    required String personId,
    required String canonicalName,
    String? kunyah,
    String? titleOrLakab,
    required String historicalRole,
    HistoricalDate? birthDate,
    HistoricalDate? deathDate,
    required String biographicalSummary,
    required List<String> sourceIds,
    List<String> aliases = const [],
  }) {
    final sourcesPayload = sourceIds.join(',');
    final aliasesPayload = aliases.join(',');
    final bPayload = birthDate != null ? '${birthDate.hijriYear}:${birthDate.dateDisplay}' : '';
    final dPayload = deathDate != null ? '${deathDate.hijriYear}:${deathDate.dateDisplay}' : '';

    final payload = '$personId|$canonicalName|${kunyah ?? ''}|${titleOrLakab ?? ''}|$historicalRole|$bPayload|$dPayload|$biographicalSummary|$sourcesPayload|$aliasesPayload';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return HistoricalPerson(
      personId: personId,
      canonicalName: canonicalName,
      kunyah: kunyah,
      titleOrLakab: titleOrLakab,
      historicalRole: historicalRole,
      birthDate: birthDate,
      deathDate: deathDate,
      biographicalSummary: biographicalSummary,
      sourceIds: sourceIds,
      aliases: aliases,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final sourcesPayload = sourceIds.join(',');
    final aliasesPayload = aliases.join(',');
    final bPayload = birthDate != null ? '${birthDate!.hijriYear}:${birthDate!.dateDisplay}' : '';
    final dPayload = deathDate != null ? '${deathDate!.hijriYear}:${deathDate!.dateDisplay}' : '';

    final payload = '$personId|$canonicalName|${kunyah ?? ''}|${titleOrLakab ?? ''}|$historicalRole|$bPayload|$dPayload|$biographicalSummary|$sourcesPayload|$aliasesPayload';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'person_id': personId,
      'canonical_name': canonicalName,
      'kunyah': kunyah,
      'title_or_lakab': titleOrLakab,
      'historical_role': historicalRole,
      'birth_date': birthDate?.toMap(),
      'death_date': deathDate?.toMap(),
      'biographical_summary': biographicalSummary,
      'source_ids': sourceIds,
      'aliases': aliases,
      'integrity_hash': integrityHash,
    };
  }

  factory HistoricalPerson.fromMap(Map<String, dynamic> map) {
    final rawSources = map['source_ids'] as List<dynamic>? ?? [];
    final rawAliases = map['aliases'] as List<dynamic>? ?? [];
    final rawBDate = map['birth_date'] as Map<String, dynamic>?;
    final rawDDate = map['death_date'] as Map<String, dynamic>?;

    return HistoricalPerson(
      personId: map['person_id'] as String,
      canonicalName: map['canonical_name'] as String,
      kunyah: map['kunyah'] as String?,
      titleOrLakab: map['title_or_lakab'] as String?,
      historicalRole: map['historical_role'] as String,
      birthDate: rawBDate != null ? HistoricalDate.fromMap(rawBDate) : null,
      deathDate: rawDDate != null ? HistoricalDate.fromMap(rawDDate) : null,
      biographicalSummary: map['biographical_summary'] as String,
      sourceIds: rawSources.map((e) => e.toString()).toList(),
      aliases: rawAliases.map((e) => e.toString()).toList(),
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        personId,
        canonicalName,
        kunyah,
        titleOrLakab,
        historicalRole,
        birthDate,
        deathDate,
        biographicalSummary,
        sourceIds,
        aliases,
        integrityHash,
      ];
}
