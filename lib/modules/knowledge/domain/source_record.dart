import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'source_type.dart';

/// Full provenance record for a verified scholarly source (§5, §6).
class SourceRecord extends Equatable {
  final String sourceId;
  final String title;
  final String author;
  final String? editor;
  final String? publisher;
  final String? edition;
  final int? year;
  final String language;
  final SourceType sourceType;
  final String? referenceScheme;
  final String reviewState;
  final String integrityHash;

  const SourceRecord({
    required this.sourceId,
    required this.title,
    required this.author,
    this.editor,
    this.publisher,
    this.edition,
    this.year,
    this.language = 'ar',
    required this.sourceType,
    this.referenceScheme,
    this.reviewState = 'APPROVED',
    required this.integrityHash,
  });

  /// Factory to instantiate a [SourceRecord] with computed SHA-256 hash.
  factory SourceRecord.create({
    required String sourceId,
    required String title,
    required String author,
    String? editor,
    String? publisher,
    String? edition,
    int? year,
    String language = 'ar',
    required SourceType sourceType,
    String? referenceScheme,
    String reviewState = 'APPROVED',
  }) {
    final hashPayload = '$sourceId|$title|$author|${editor ?? ''}|${publisher ?? ''}|${edition ?? ''}|${year ?? ''}|$language|${sourceType.name}|$reviewState';
    final hash = 'sha256:${sha256.convert(utf8.encode(hashPayload)).toString()}';

    return SourceRecord(
      sourceId: sourceId,
      title: title,
      author: author,
      editor: editor,
      publisher: publisher,
      edition: edition,
      year: year,
      language: language,
      sourceType: sourceType,
      referenceScheme: referenceScheme,
      reviewState: reviewState,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final hashPayload = '$sourceId|$title|$author|${editor ?? ''}|${publisher ?? ''}|${edition ?? ''}|${year ?? ''}|$language|${sourceType.name}|$reviewState';
    final expected = 'sha256:${sha256.convert(utf8.encode(hashPayload)).toString()}';
    return integrityHash == expected;
  }

  Map<String, dynamic> toMap() {
    return {
      'source_id': sourceId,
      'title': title,
      'author': author,
      'editor': editor,
      'publisher': publisher,
      'edition': edition,
      'year': year,
      'language': language,
      'source_type': sourceType.name,
      'reference_scheme': referenceScheme,
      'review_state': reviewState,
      'integrity_hash': integrityHash,
    };
  }

  factory SourceRecord.fromMap(Map<String, dynamic> map) {
    return SourceRecord(
      sourceId: map['source_id'] as String,
      title: map['title'] as String,
      author: map['author'] as String,
      editor: map['editor'] as String?,
      publisher: map['publisher'] as String?,
      edition: map['edition'] as String?,
      year: map['year'] as int?,
      language: map['language'] as String? ?? 'ar',
      sourceType: SourceType.values.byName(map['source_type'] as String),
      referenceScheme: map['reference_scheme'] as String?,
      reviewState: map['review_state'] as String? ?? 'APPROVED',
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        sourceId,
        title,
        author,
        editor,
        publisher,
        edition,
        year,
        language,
        sourceType,
        referenceScheme,
        reviewState,
        integrityHash,
      ];
}
