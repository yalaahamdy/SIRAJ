import 'package:equatable/equatable.dart';

/// Metadata model for a classical or canonical Hadith collection (§7).
class HadithCollection extends Equatable {
  final String collectionId;
  final String titleArabic;
  final String? titleEnglish;
  final String compilerName;
  final int totalHadithCount;
  final String sourceId;
  final String? description;

  const HadithCollection({
    required this.collectionId,
    required this.titleArabic,
    this.titleEnglish,
    required this.compilerName,
    required this.totalHadithCount,
    required this.sourceId,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'collection_id': collectionId,
      'title_arabic': titleArabic,
      'title_english': titleEnglish,
      'compiler_name': compilerName,
      'total_hadith_count': totalHadithCount,
      'source_id': sourceId,
      'description': description,
    };
  }

  factory HadithCollection.fromMap(Map<String, dynamic> map) {
    return HadithCollection(
      collectionId: map['collection_id'] as String,
      titleArabic: map['title_arabic'] as String,
      titleEnglish: map['title_english'] as String?,
      compilerName: map['compiler_name'] as String,
      totalHadithCount: map['total_hadith_count'] as int,
      sourceId: map['source_id'] as String,
      description: map['description'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        collectionId,
        titleArabic,
        titleEnglish,
        compilerName,
        totalHadithCount,
        sourceId,
        description,
      ];
}
