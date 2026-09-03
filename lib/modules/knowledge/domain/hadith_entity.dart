import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'hadith_grading.dart';
import 'scholarly_attribution.dart';

/// Canonical Hadith entity with stable identity and strict textual separation (§7, §8, §9).
class HadithEntity extends Equatable {
  final String hadithId;
  final String collectionId;
  final int bookNumber;
  final String bookName;
  final int? chapterNumber;
  final String? chapterName;
  final int primaryNumber;
  final int? internationalNumber;
  final String arabicMatn;
  final String? isnad;
  final String sourceId;
  final List<HadithGrading> gradings;
  final Map<String, String> translations;
  final List<ScholarlyAttribution> commentaries;
  final String integrityHash;

  const HadithEntity({
    required this.hadithId,
    required this.collectionId,
    required this.bookNumber,
    required this.bookName,
    this.chapterNumber,
    this.chapterName,
    required this.primaryNumber,
    this.internationalNumber,
    required this.arabicMatn,
    this.isnad,
    required this.sourceId,
    required this.gradings,
    this.translations = const {},
    this.commentaries = const [],
    required this.integrityHash,
  });

  factory HadithEntity.create({
    required String hadithId,
    required String collectionId,
    required int bookNumber,
    required String bookName,
    int? chapterNumber,
    String? chapterName,
    required int primaryNumber,
    int? internationalNumber,
    required String arabicMatn,
    String? isnad,
    required String sourceId,
    required List<HadithGrading> gradings,
    Map<String, String> translations = const {},
    List<ScholarlyAttribution> commentaries = const [],
  }) {
    final gradingsPayload = gradings.map((g) => g.integrityHash).join(';');
    final commentariesPayload = commentaries.map((c) => c.integrityHash).join(';');
    final translationsPayload = translations.entries.map((e) => '${e.key}:${e.value}').join(';');

    final payload = '$hadithId|$collectionId|$bookNumber|$bookName|${chapterNumber ?? ''}|${chapterName ?? ''}|$primaryNumber|${internationalNumber ?? ''}|$arabicMatn|${isnad ?? ''}|$sourceId|$gradingsPayload|$translationsPayload|$commentariesPayload';
    final hash = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';

    return HadithEntity(
      hadithId: hadithId,
      collectionId: collectionId,
      bookNumber: bookNumber,
      bookName: bookName,
      chapterNumber: chapterNumber,
      chapterName: chapterName,
      primaryNumber: primaryNumber,
      internationalNumber: internationalNumber,
      arabicMatn: arabicMatn,
      isnad: isnad,
      sourceId: sourceId,
      gradings: gradings,
      translations: translations,
      commentaries: commentaries,
      integrityHash: hash,
    );
  }

  bool verifyHash() {
    final gradingsPayload = gradings.map((g) => g.integrityHash).join(';');
    final commentariesPayload = commentaries.map((c) => c.integrityHash).join(';');
    final translationsPayload = translations.entries.map((e) => '${e.key}:${e.value}').join(';');

    final payload = '$hadithId|$collectionId|$bookNumber|$bookName|${chapterNumber ?? ''}|${chapterName ?? ''}|$primaryNumber|${internationalNumber ?? ''}|$arabicMatn|${isnad ?? ''}|$sourceId|$gradingsPayload|$translationsPayload|$commentariesPayload';
    final expected = 'sha256:${sha256.convert(utf8.encode(payload)).toString()}';
    return integrityHash == expected;
  }

  HadithGrade get primaryGrade => gradings.isEmpty ? HadithGrade.unverified : gradings.first.grade;

  Map<String, dynamic> toMap() {
    return {
      'hadith_id': hadithId,
      'collection_id': collectionId,
      'book_number': bookNumber,
      'book_name': bookName,
      'chapter_number': chapterNumber,
      'chapter_name': chapterName,
      'primary_number': primaryNumber,
      'international_number': internationalNumber,
      'arabic_matn': arabicMatn,
      'isnad': isnad,
      'source_id': sourceId,
      'gradings': gradings.map((g) => g.toMap()).toList(),
      'translations': translations,
      'commentaries': commentaries.map((c) => c.toMap()).toList(),
      'integrity_hash': integrityHash,
    };
  }

  factory HadithEntity.fromMap(Map<String, dynamic> map) {
    final rawGradings = map['gradings'] as List<dynamic>? ?? [];
    final gradings = rawGradings.map((g) => HadithGrading.fromMap(g as Map<String, dynamic>)).toList();

    final rawCommentaries = map['commentaries'] as List<dynamic>? ?? [];
    final commentaries = rawCommentaries.map((c) => ScholarlyAttribution.fromMap(c as Map<String, dynamic>)).toList();

    final rawTrans = map['translations'] as Map<String, dynamic>? ?? {};
    final translations = rawTrans.map((k, v) => MapEntry(k, v.toString()));

    return HadithEntity(
      hadithId: map['hadith_id'] as String,
      collectionId: map['collection_id'] as String,
      bookNumber: map['book_number'] as int,
      bookName: map['book_name'] as String,
      chapterNumber: map['chapter_number'] as int?,
      chapterName: map['chapter_name'] as String?,
      primaryNumber: map['primary_number'] as int,
      internationalNumber: map['international_number'] as int?,
      arabicMatn: map['arabic_matn'] as String,
      isnad: map['isnad'] as String?,
      sourceId: map['source_id'] as String,
      gradings: gradings,
      translations: translations,
      commentaries: commentaries,
      integrityHash: map['integrity_hash'] as String,
    );
  }

  @override
  List<Object?> get props => [
        hadithId,
        collectionId,
        bookNumber,
        bookName,
        chapterNumber,
        chapterName,
        primaryNumber,
        internationalNumber,
        arabicMatn,
        isnad,
        sourceId,
        gradings,
        translations,
        commentaries,
        integrityHash,
      ];
}
