import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Canonical Miqat boundary and geographical context (§14, §15).
class Miqat {
  final String miqatId;
  final String nameArabic;
  final String historicalName;
  final String modernName;
  final String region;
  final double latitude;
  final double longitude;
  final double distanceFromMakkahKm;
  final String designatedFor;
  final String sourceId;
  final String integrityHash;

  const Miqat({
    required this.miqatId,
    required this.nameArabic,
    required this.historicalName,
    required this.modernName,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.distanceFromMakkahKm,
    required this.designatedFor,
    required this.sourceId,
    required this.integrityHash,
  });

  static String computeHash({
    required String miqatId,
    required String nameArabic,
    required String historicalName,
    required String modernName,
    required String region,
    required double latitude,
    required double longitude,
    required double distanceFromMakkahKm,
    required String designatedFor,
    required String sourceId,
  }) {
    final payload = '$miqatId|$nameArabic|$historicalName|$modernName|$region|$latitude|$longitude|$distanceFromMakkahKm|$designatedFor|$sourceId';
    return 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
  }

  factory Miqat.create({
    required String miqatId,
    required String nameArabic,
    required String historicalName,
    required String modernName,
    required String region,
    required double latitude,
    required double longitude,
    required double distanceFromMakkahKm,
    required String designatedFor,
    required String sourceId,
  }) {
    final hash = computeHash(
      miqatId: miqatId,
      nameArabic: nameArabic,
      historicalName: historicalName,
      modernName: modernName,
      region: region,
      latitude: latitude,
      longitude: longitude,
      distanceFromMakkahKm: distanceFromMakkahKm,
      designatedFor: designatedFor,
      sourceId: sourceId,
    );
    return Miqat(
      miqatId: miqatId,
      nameArabic: nameArabic,
      historicalName: historicalName,
      modernName: modernName,
      region: region,
      latitude: latitude,
      longitude: longitude,
      distanceFromMakkahKm: distanceFromMakkahKm,
      designatedFor: designatedFor,
      sourceId: sourceId,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    return integrityHash ==
        computeHash(
          miqatId: miqatId,
          nameArabic: nameArabic,
          historicalName: historicalName,
          modernName: modernName,
          region: region,
          latitude: latitude,
          longitude: longitude,
          distanceFromMakkahKm: distanceFromMakkahKm,
          designatedFor: designatedFor,
          sourceId: sourceId,
        );
  }

  Map<String, dynamic> toJson() => {
        'miqatId': miqatId,
        'nameArabic': nameArabic,
        'historicalName': historicalName,
        'modernName': modernName,
        'region': region,
        'latitude': latitude,
        'longitude': longitude,
        'distanceFromMakkahKm': distanceFromMakkahKm,
        'designatedFor': designatedFor,
        'sourceId': sourceId,
        'integrityHash': integrityHash,
      };

  factory Miqat.fromJson(Map<String, dynamic> json) => Miqat(
        miqatId: json['miqatId'] as String,
        nameArabic: json['nameArabic'] as String,
        historicalName: json['historicalName'] as String,
        modernName: json['modernName'] as String,
        region: json['region'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        distanceFromMakkahKm: (json['distanceFromMakkahKm'] as num).toDouble(),
        designatedFor: json['designatedFor'] as String,
        sourceId: json['sourceId'] as String,
        integrityHash: json['integrityHash'] as String,
      );
}
