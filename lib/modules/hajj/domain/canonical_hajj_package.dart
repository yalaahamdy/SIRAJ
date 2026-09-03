import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'miqat.dart';
import 'preparation_item.dart';
import 'ritual_step.dart';
import 'sacred_location.dart';

/// Cryptographically signed canonical package for Hajj & Umrah guidance (§40).
class CanonicalHajjPackage {
  final String packageId;
  final String schemaVersion;
  final List<RitualStep> steps;
  final List<Miqat> miqats;
  final List<SacredLocation> locations;
  final List<PreparationItem> preparationItems;
  final String contentHash;
  final String signerIdentity;
  final String signature;
  final DateTime publishedAt;

  const CanonicalHajjPackage({
    required this.packageId,
    required this.schemaVersion,
    required this.steps,
    required this.miqats,
    required this.locations,
    required this.preparationItems,
    required this.contentHash,
    required this.signerIdentity,
    required this.signature,
    required this.publishedAt,
  });

  static String computeContentHash({
    required List<RitualStep> steps,
    required List<Miqat> miqats,
    required List<SacredLocation> locations,
  }) {
    final stepHashes = steps.map((s) => s.integrityHash).join('|');
    final miqatHashes = miqats.map((m) => m.integrityHash).join('|');
    final locHashes = locations.map((l) => l.integrityHash).join('|');
    final payload = '$stepHashes#$miqatHashes#$locHashes';
    return 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
  }

  factory CanonicalHajjPackage.create({
    required String packageId,
    required String schemaVersion,
    required List<RitualStep> steps,
    required List<Miqat> miqats,
    required List<SacredLocation> locations,
    required List<PreparationItem> preparationItems,
    required String signerIdentity,
    required String signature,
    required DateTime publishedAt,
  }) {
    final hash = computeContentHash(
      steps: steps,
      miqats: miqats,
      locations: locations,
    );
    return CanonicalHajjPackage(
      packageId: packageId,
      schemaVersion: schemaVersion,
      steps: List.unmodifiable(steps),
      miqats: List.unmodifiable(miqats),
      locations: List.unmodifiable(locations),
      preparationItems: List.unmodifiable(preparationItems),
      contentHash: hash,
      signerIdentity: signerIdentity,
      signature: signature,
      publishedAt: publishedAt,
    );
  }

  bool verifyIntegrity() {
    if (signature.isEmpty || signerIdentity.isEmpty) return false;
    final expectedHash = computeContentHash(
      steps: steps,
      miqats: miqats,
      locations: locations,
    );
    if (contentHash != expectedHash) return false;

    for (final s in steps) {
      if (!s.verifyHash()) return false;
    }
    for (final m in miqats) {
      if (!m.verifyHash()) return false;
    }
    for (final l in locations) {
      if (!l.verifyHash()) return false;
    }
    return true;
  }

  Map<String, dynamic> toJson() => {
        'packageId': packageId,
        'schemaVersion': schemaVersion,
        'steps': steps.map((e) => e.toJson()).toList(),
        'miqats': miqats.map((e) => e.toJson()).toList(),
        'locations': locations.map((e) => e.toJson()).toList(),
        'preparationItems': preparationItems.map((e) => e.toJson()).toList(),
        'contentHash': contentHash,
        'signerIdentity': signerIdentity,
        'signature': signature,
        'publishedAt': publishedAt.toIso8601String(),
      };

  factory CanonicalHajjPackage.fromJson(Map<String, dynamic> json) => CanonicalHajjPackage(
        packageId: json['packageId'] as String,
        schemaVersion: json['schemaVersion'] as String,
        steps: (json['steps'] as List<dynamic>).map((e) => RitualStep.fromJson(e as Map<String, dynamic>)).toList(),
        miqats: (json['miqats'] as List<dynamic>).map((e) => Miqat.fromJson(e as Map<String, dynamic>)).toList(),
        locations: (json['locations'] as List<dynamic>).map((e) => SacredLocation.fromJson(e as Map<String, dynamic>)).toList(),
        preparationItems: (json['preparationItems'] as List<dynamic>).map((e) => PreparationItem.fromJson(e as Map<String, dynamic>)).toList(),
        contentHash: json['contentHash'] as String,
        signerIdentity: json['signerIdentity'] as String,
        signature: json['signature'] as String,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
      );
}
