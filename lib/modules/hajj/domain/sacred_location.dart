import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Sacred location in Makkah and Al-Masha'ir Al-Muqaddasah (§16, §17).
class SacredLocation {
  final String locationId;
  final String nameArabic;
  final String description;
  final double latitude;
  final double longitude;
  final String historicalContext;
  final String sourceId;
  final String integrityHash;

  const SacredLocation({
    required this.locationId,
    required this.nameArabic,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.historicalContext,
    required this.sourceId,
    required this.integrityHash,
  });

  static String computeHash({
    required String locationId,
    required String nameArabic,
    required String description,
    required double latitude,
    required double longitude,
    required String historicalContext,
    required String sourceId,
  }) {
    final payload = '$locationId|$nameArabic|$description|$latitude|$longitude|$historicalContext|$sourceId';
    return 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
  }

  factory SacredLocation.create({
    required String locationId,
    required String nameArabic,
    required String description,
    required double latitude,
    required double longitude,
    required String historicalContext,
    required String sourceId,
  }) {
    final hash = computeHash(
      locationId: locationId,
      nameArabic: nameArabic,
      description: description,
      latitude: latitude,
      longitude: longitude,
      historicalContext: historicalContext,
      sourceId: sourceId,
    );
    return SacredLocation(
      locationId: locationId,
      nameArabic: nameArabic,
      description: description,
      latitude: latitude,
      longitude: longitude,
      historicalContext: historicalContext,
      sourceId: sourceId,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    return integrityHash ==
        computeHash(
          locationId: locationId,
          nameArabic: nameArabic,
          description: description,
          latitude: latitude,
          longitude: longitude,
          historicalContext: historicalContext,
          sourceId: sourceId,
        );
  }

  Map<String, dynamic> toJson() => {
        'locationId': locationId,
        'nameArabic': nameArabic,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'historicalContext': historicalContext,
        'sourceId': sourceId,
        'integrityHash': integrityHash,
      };

  factory SacredLocation.fromJson(Map<String, dynamic> json) => SacredLocation(
        locationId: json['locationId'] as String,
        nameArabic: json['nameArabic'] as String,
        description: json['description'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        historicalContext: json['historicalContext'] as String,
        sourceId: json['sourceId'] as String,
        integrityHash: json['integrityHash'] as String,
      );
}
