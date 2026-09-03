import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'historical_period.dart';
import 'historical_person.dart';
import 'historical_place.dart';
import 'person_relationship.dart';
import 'seerah_event.dart';

/// Cryptographically signed canonical Seerah & Islamic History package (§28, §29).
class CanonicalSeerahPackage extends Equatable {
  final String packageId;
  final String schemaVersion;
  final List<HistoricalPeriod> periods;
  final List<SeerahEvent> events;
  final List<HistoricalPerson> persons;
  final List<PersonRelationship> relationships;
  final List<HistoricalPlace> places;
  final String contentHash;
  final String signerIdentity;
  final String signature;
  final DateTime publishedAt;

  const CanonicalSeerahPackage({
    required this.packageId,
    required this.schemaVersion,
    required this.periods,
    required this.events,
    required this.persons,
    required this.relationships,
    required this.places,
    required this.contentHash,
    required this.signerIdentity,
    required this.signature,
    required this.publishedAt,
  });

  factory CanonicalSeerahPackage.create({
    required String packageId,
    String schemaVersion = '1.0.0',
    required List<HistoricalPeriod> periods,
    required List<SeerahEvent> events,
    required List<HistoricalPerson> persons,
    required List<PersonRelationship> relationships,
    required List<HistoricalPlace> places,
    required String signerIdentity,
    required String signature,
    required DateTime publishedAt,
  }) {
    final periodsPayload = periods.map((p) => '${p.periodId}:${p.orderIndex}').join(';');
    final eventsPayload = events.map((e) => e.integrityHash).join(';');
    final personsPayload = persons.map((p) => p.integrityHash).join(';');
    final placesPayload = places.map((pl) => pl.integrityHash).join(';');

    final rawPayload = '$packageId|$schemaVersion|$periodsPayload|$eventsPayload|$personsPayload|$placesPayload|$signerIdentity|${publishedAt.toIso8601String()}';
    final computedHash = 'sha256:${sha256.convert(utf8.encode(rawPayload)).toString()}';

    return CanonicalSeerahPackage(
      packageId: packageId,
      schemaVersion: schemaVersion,
      periods: periods,
      events: events,
      persons: persons,
      relationships: relationships,
      places: places,
      contentHash: computedHash,
      signerIdentity: signerIdentity,
      signature: signature,
      publishedAt: publishedAt,
    );
  }

  bool verifyPackageIntegrity() {
    if (signature.isEmpty || signerIdentity.isEmpty) return false;

    for (final e in events) {
      if (!e.verifyHash()) return false;
    }
    for (final p in persons) {
      if (!p.verifyHash()) return false;
    }
    for (final pl in places) {
      if (!pl.verifyHash()) return false;
    }

    final periodsPayload = periods.map((p) => '${p.periodId}:${p.orderIndex}').join(';');
    final eventsPayload = events.map((e) => e.integrityHash).join(';');
    final personsPayload = persons.map((p) => p.integrityHash).join(';');
    final placesPayload = places.map((pl) => pl.integrityHash).join(';');

    final rawPayload = '$packageId|$schemaVersion|$periodsPayload|$eventsPayload|$personsPayload|$placesPayload|$signerIdentity|${publishedAt.toIso8601String()}';
    final expectedHash = 'sha256:${sha256.convert(utf8.encode(rawPayload)).toString()}';

    return contentHash == expectedHash;
  }

  Map<String, dynamic> toMap() {
    return {
      'package_id': packageId,
      'schema_version': schemaVersion,
      'periods': periods.map((p) => p.toMap()).toList(),
      'events': events.map((e) => e.toMap()).toList(),
      'persons': persons.map((p) => p.toMap()).toList(),
      'relationships': relationships.map((r) => r.toMap()).toList(),
      'places': places.map((pl) => pl.toMap()).toList(),
      'content_hash': contentHash,
      'signer_identity': signerIdentity,
      'signature': signature,
      'published_at': publishedAt.toIso8601String(),
    };
  }

  factory CanonicalSeerahPackage.fromMap(Map<String, dynamic> map) {
    final rawPeriods = map['periods'] as List<dynamic>? ?? [];
    final rawEvents = map['events'] as List<dynamic>? ?? [];
    final rawPersons = map['persons'] as List<dynamic>? ?? [];
    final rawRels = map['relationships'] as List<dynamic>? ?? [];
    final rawPlaces = map['places'] as List<dynamic>? ?? [];

    return CanonicalSeerahPackage(
      packageId: map['package_id'] as String,
      schemaVersion: map['schema_version'] as String? ?? '1.0.0',
      periods: rawPeriods.map((p) => HistoricalPeriod.fromMap(p as Map<String, dynamic>)).toList(),
      events: rawEvents.map((e) => SeerahEvent.fromMap(e as Map<String, dynamic>)).toList(),
      persons: rawPersons.map((p) => HistoricalPerson.fromMap(p as Map<String, dynamic>)).toList(),
      relationships: rawRels.map((r) => PersonRelationship.fromMap(r as Map<String, dynamic>)).toList(),
      places: rawPlaces.map((pl) => HistoricalPlace.fromMap(pl as Map<String, dynamic>)).toList(),
      contentHash: map['content_hash'] as String,
      signerIdentity: map['signer_identity'] as String,
      signature: map['signature'] as String,
      publishedAt: DateTime.parse(map['published_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        packageId,
        schemaVersion,
        periods,
        events,
        persons,
        relationships,
        places,
        contentHash,
        signerIdentity,
        signature,
        publishedAt,
      ];
}
