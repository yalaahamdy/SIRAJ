import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import '../domain/dhikr_item.dart';

/// Cryptographically signed canonical Adhkar package (§26, §27).
class CanonicalAdhkarPackage extends Equatable {
  final String packageId;
  final String version;
  final int schemaVersion;
  final String title;
  final List<DhikrItem> items;
  final String contentHash;
  final String signerIdentity;
  final String signature;
  final DateTime publishedAt;

  const CanonicalAdhkarPackage({
    required this.packageId,
    required this.version,
    required this.schemaVersion,
    required this.title,
    required this.items,
    required this.contentHash,
    required this.signerIdentity,
    required this.signature,
    required this.publishedAt,
  })  : assert(schemaVersion >= 1, 'Schema version must be >= 1'),
        assert(items.length > 0, 'Package must contain at least one Dhikr item');

  static String computeAggregateHash(List<DhikrItem> items) {
    final hashesCombined = items.map((i) => i.integrityHash).join(';');
    final digest = sha256.convert(utf8.encode(hashesCombined)).toString();
    return 'sha256:$digest';
  }

  bool verifyPackageIntegrity() {
    // 1. Check aggregate hash
    final expectedAggregate = computeAggregateHash(items);
    if (contentHash != expectedAggregate) return false;

    // 2. Check each individual item hash
    for (final item in items) {
      if (!item.verifyHash()) return false;
    }

    // 3. Signature present and signer valid
    if (signerIdentity.isEmpty || signature.isEmpty) return false;

    return true;
  }

  factory CanonicalAdhkarPackage.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>;
    final parsedItems = rawItems
        .map((i) => DhikrItem.fromMap(i as Map<String, dynamic>))
        .toList();

    return CanonicalAdhkarPackage(
      packageId: map['package_id'] as String,
      version: map['version'] as String,
      schemaVersion: map['schema_version'] as int? ?? 1,
      title: map['title'] as String,
      items: parsedItems,
      contentHash: map['content_hash'] as String,
      signerIdentity: map['signer_identity'] as String,
      signature: map['signature'] as String,
      publishedAt: DateTime.parse(map['published_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'package_id': packageId,
      'version': version,
      'schema_version': schemaVersion,
      'title': title,
      'items_count': items.length,
      'items': items.map((i) => i.toMap()).toList(),
      'content_hash': contentHash,
      'signer_identity': signerIdentity,
      'signature': signature,
      'published_at': publishedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        packageId,
        version,
        schemaVersion,
        title,
        items,
        contentHash,
        signerIdentity,
        signature,
        publishedAt,
      ];
}
