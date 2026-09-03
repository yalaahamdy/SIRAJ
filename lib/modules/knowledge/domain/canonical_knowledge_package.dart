import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'fiqh_topic.dart';
import 'hadith_entity.dart';
import 'knowledge_item.dart';
import 'knowledge_relation.dart';
import 'learning_path.dart';
import 'source_record.dart';

/// Cryptographically signed canonical knowledge package (§24).
class CanonicalKnowledgePackage extends Equatable {
  final String packageId;
  final String schemaVersion;
  final List<SourceRecord> sources;
  final List<HadithEntity> hadiths;
  final List<FiqhTopic> fiqhTopics;
  final List<KnowledgeItem> knowledgeItems;
  final List<KnowledgeRelation> relations;
  final List<LearningPath> learningPaths;
  final String contentHash;
  final String signerIdentity;
  final String signature;
  final DateTime publishedAt;

  const CanonicalKnowledgePackage({
    required this.packageId,
    required this.schemaVersion,
    required this.sources,
    required this.hadiths,
    required this.fiqhTopics,
    required this.knowledgeItems,
    this.relations = const [],
    this.learningPaths = const [],
    required this.contentHash,
    required this.signerIdentity,
    required this.signature,
    required this.publishedAt,
  });

  /// Factory to instantiate and compute aggregate SHA-256 package hash.
  factory CanonicalKnowledgePackage.create({
    required String packageId,
    String schemaVersion = '1.0.0',
    required List<SourceRecord> sources,
    required List<HadithEntity> hadiths,
    required List<FiqhTopic> fiqhTopics,
    required List<KnowledgeItem> knowledgeItems,
    List<KnowledgeRelation> relations = const [],
    List<LearningPath> learningPaths = const [],
    required String signerIdentity,
    required String signature,
    required DateTime publishedAt,
  }) {
    final sourcesHash = sources.map((s) => s.integrityHash).join(';');
    final hadithsHash = hadiths.map((h) => h.integrityHash).join(';');
    final fiqhHash = fiqhTopics.map((f) => f.integrityHash).join(';');
    final itemsHash = knowledgeItems.map((k) => k.integrityHash).join(';');

    final rawPayload = '$packageId|$schemaVersion|$sourcesHash|$hadithsHash|$fiqhHash|$itemsHash|$signerIdentity|${publishedAt.toIso8601String()}';
    final computedHash = 'sha256:${sha256.convert(utf8.encode(rawPayload)).toString()}';

    return CanonicalKnowledgePackage(
      packageId: packageId,
      schemaVersion: schemaVersion,
      sources: sources,
      hadiths: hadiths,
      fiqhTopics: fiqhTopics,
      knowledgeItems: knowledgeItems,
      relations: relations,
      learningPaths: learningPaths,
      contentHash: computedHash,
      signerIdentity: signerIdentity,
      signature: signature,
      publishedAt: publishedAt,
    );
  }

  /// Verifies internal cryptographic integrity and all entity hashes.
  bool verifyPackageIntegrity() {
    if (signature.isEmpty || signerIdentity.isEmpty) return false;

    for (final s in sources) {
      if (!s.verifyHash()) return false;
    }
    for (final h in hadiths) {
      if (!h.verifyHash()) return false;
    }
    for (final f in fiqhTopics) {
      if (!f.verifyHash()) return false;
    }
    for (final k in knowledgeItems) {
      if (!k.verifyHash()) return false;
    }

    final sourcesHash = sources.map((s) => s.integrityHash).join(';');
    final hadithsHash = hadiths.map((h) => h.integrityHash).join(';');
    final fiqhHash = fiqhTopics.map((f) => f.integrityHash).join(';');
    final itemsHash = knowledgeItems.map((k) => k.integrityHash).join(';');

    final rawPayload = '$packageId|$schemaVersion|$sourcesHash|$hadithsHash|$fiqhHash|$itemsHash|$signerIdentity|${publishedAt.toIso8601String()}';
    final expectedHash = 'sha256:${sha256.convert(utf8.encode(rawPayload)).toString()}';

    return contentHash == expectedHash;
  }

  Map<String, dynamic> toMap() {
    return {
      'package_id': packageId,
      'schema_version': schemaVersion,
      'sources': sources.map((s) => s.toMap()).toList(),
      'hadiths': hadiths.map((h) => h.toMap()).toList(),
      'fiqh_topics': fiqhTopics.map((f) => f.toMap()).toList(),
      'knowledge_items': knowledgeItems.map((k) => k.toMap()).toList(),
      'relations': relations.map((r) => r.toMap()).toList(),
      'learning_paths': learningPaths.map((l) => l.toMap()).toList(),
      'content_hash': contentHash,
      'signer_identity': signerIdentity,
      'signature': signature,
      'published_at': publishedAt.toIso8601String(),
    };
  }

  factory CanonicalKnowledgePackage.fromMap(Map<String, dynamic> map) {
    final rawSources = map['sources'] as List<dynamic>? ?? [];
    final rawHadiths = map['hadiths'] as List<dynamic>? ?? [];
    final rawFiqh = map['fiqh_topics'] as List<dynamic>? ?? [];
    final rawItems = map['knowledge_items'] as List<dynamic>? ?? [];
    final rawRelations = map['relations'] as List<dynamic>? ?? [];
    final rawPaths = map['learning_paths'] as List<dynamic>? ?? [];

    return CanonicalKnowledgePackage(
      packageId: map['package_id'] as String,
      schemaVersion: map['schema_version'] as String? ?? '1.0.0',
      sources: rawSources.map((s) => SourceRecord.fromMap(s as Map<String, dynamic>)).toList(),
      hadiths: rawHadiths.map((h) => HadithEntity.fromMap(h as Map<String, dynamic>)).toList(),
      fiqhTopics: rawFiqh.map((f) => FiqhTopic.fromMap(f as Map<String, dynamic>)).toList(),
      knowledgeItems: rawItems.map((k) => KnowledgeItem.fromMap(k as Map<String, dynamic>)).toList(),
      relations: rawRelations.map((r) => KnowledgeRelation.fromMap(r as Map<String, dynamic>)).toList(),
      learningPaths: rawPaths.map((l) => LearningPath.fromMap(l as Map<String, dynamic>)).toList(),
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
        sources,
        hadiths,
        fiqhTopics,
        knowledgeItems,
        relations,
        learningPaths,
        contentHash,
        signerIdentity,
        signature,
        publishedAt,
      ];
}
