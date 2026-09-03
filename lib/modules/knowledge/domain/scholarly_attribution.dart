import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

/// Structured scholarly quotation and attribution entity (§12).
class ScholarlyAttribution extends Equatable {
  final String attributionId;
  final String scholarId;
  final String scholarName;
  final String quote;
  final String sourceId;
  final String? pageReference;
  final String? context;
  final String verificationStatus;
  final String integrityHash;

  const ScholarlyAttribution({
    required this.attributionId,
    required this.scholarId,
    required this.scholarName,
    required this.quote,
    required this.sourceId,
    this.pageReference,
    this.context,
    this.verificationStatus = 'VERIFIED',
    required this.integrityHash,
  });

  factory ScholarlyAttribution.create({
    required String attributionId,
    required String scholarId,
    required String scholarName,
    required String quote,
    required String sourceId,
    String? pageReference,
    String? context,
    String verificationStatus = 'VERIFIED',
  }) {
    final payload = '$attributionId|$scholarId|$scholarName|$quote|$sourceId|${pageReference ?? ''}|${context ?? ''}|$verificationStatus';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return ScholarlyAttribution(
      attributionId: attributionId,
      scholarId: scholarId,
      scholarName: scholarName,
      quote: quote,
      sourceId: sourceId,
      pageReference: pageReference,
      context: context,
      verificationStatus: verificationStatus,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final payload = '$attributionId|$scholarId|$scholarName|$quote|$sourceId|${pageReference ?? ''}|${context ?? ''}|$verificationStatus';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'attribution_id': attributionId,
      'scholar_id': scholarId,
      'scholar_name': scholarName,
      'quote': quote,
      'source_id': sourceId,
      'page_reference': pageReference,
      'context': context,
      'verification_status': verificationStatus,
      'integrity_hash': integrityHash,
    };
  }

  factory ScholarlyAttribution.fromMap(Map<String, dynamic> map) {
    return ScholarlyAttribution(
      attributionId: map['attribution_id'] as String,
      scholarId: map['scholar_id'] as String,
      scholarName: map['scholar_name'] as String,
      quote: map['quote'] as String,
      sourceId: map['source_id'] as String,
      pageReference: map['page_reference'] as String?,
      context: map['context'] as String?,
      verificationStatus: map['verification_status'] as String? ?? 'VERIFIED',
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        attributionId,
        scholarId,
        scholarName,
        quote,
        sourceId,
        pageReference,
        context,
        verificationStatus,
        integrityHash,
      ];
}
