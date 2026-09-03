import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

/// Geographical certainty of matching historical site to modern location (§11).
enum PlaceCertainty {
  high('مطابقة يقينية محققة'),
  approximate('موقع تقريبي مأثور'),
  disputed('موقع مختلف في تحديده');

  final String labelArabic;
  const PlaceCertainty(this.labelArabic);
}

/// Historical place and geographic site entity (§11).
class HistoricalPlace extends Equatable {
  final String placeId;
  final String nameArabic;
  final String? modernName;
  final String region;
  final double? latitude;
  final double? longitude;
  final String geographicalDescription;
  final PlaceCertainty certainty;
  final List<String> sourceIds;
  final String integrityHash;

  const HistoricalPlace({
    required this.placeId,
    required this.nameArabic,
    this.modernName,
    required this.region,
    this.latitude,
    this.longitude,
    required this.geographicalDescription,
    this.certainty = PlaceCertainty.high,
    required this.sourceIds,
    required this.integrityHash,
  });

  factory HistoricalPlace.create({
    required String placeId,
    required String nameArabic,
    String? modernName,
    required String region,
    double? latitude,
    double? longitude,
    required String geographicalDescription,
    PlaceCertainty certainty = PlaceCertainty.high,
    required List<String> sourceIds,
  }) {
    final sourcesPayload = sourceIds.join(',');
    final payload = '$placeId|$nameArabic|${modernName ?? ''}|$region|${latitude ?? ''}|${longitude ?? ''}|$geographicalDescription|${certainty.name}|$sourcesPayload';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return HistoricalPlace(
      placeId: placeId,
      nameArabic: nameArabic,
      modernName: modernName,
      region: region,
      latitude: latitude,
      longitude: longitude,
      geographicalDescription: geographicalDescription,
      certainty: certainty,
      sourceIds: sourceIds,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final sourcesPayload = sourceIds.join(',');
    final payload = '$placeId|$nameArabic|${modernName ?? ''}|$region|${latitude ?? ''}|${longitude ?? ''}|$geographicalDescription|${certainty.name}|$sourcesPayload';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'place_id': placeId,
      'name_arabic': nameArabic,
      'modern_name': modernName,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'geographical_description': geographicalDescription,
      'certainty': certainty.name,
      'source_ids': sourceIds,
      'integrity_hash': integrityHash,
    };
  }

  factory HistoricalPlace.fromMap(Map<String, dynamic> map) {
    final rawSources = map['source_ids'] as List<dynamic>? ?? [];

    return HistoricalPlace(
      placeId: map['place_id'] as String,
      nameArabic: map['name_arabic'] as String,
      modernName: map['modern_name'] as String?,
      region: map['region'] as String,
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
      geographicalDescription: map['geographical_description'] as String,
      certainty: PlaceCertainty.values.byName(map['certainty'] as String? ?? 'high'),
      sourceIds: rawSources.map((e) => e.toString()).toList(),
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        placeId,
        nameArabic,
        modernName,
        region,
        latitude,
        longitude,
        geographicalDescription,
        certainty,
        sourceIds,
        integrityHash,
      ];
}
