import 'package:equatable/equatable.dart';

/// Metadata describing a specific Quranic edition or transmission (Riwayah / Script).
class QuranEdition extends Equatable {
  final String id;
  final String name;
  final String englishName;
  final String language;
  final String scriptType; // 'uthmani', 'simple', 'tajweed'
  final String fontRequirements;
  final String sourceReference;
  final String version;

  const QuranEdition({
    required this.id,
    required this.name,
    required this.englishName,
    this.language = 'ar',
    this.scriptType = 'uthmani',
    this.fontRequirements = 'KFGQPC Uthmanic Script',
    required this.sourceReference,
    required this.version,
  });

  static const QuranEdition uthmaniHafs = QuranEdition(
    id: 'uthmani_hafs',
    name: 'مصحف المدينة النبوية (رواية حفص بالرسم العثماني)',
    englishName: 'Madinah Mushaf (Hafs Uthmani Script)',
    language: 'ar',
    scriptType: 'uthmani',
    fontRequirements: 'KFGQPC Uthmanic Script HAFS',
    sourceReference: 'Tanzil Project / King Fahd Glorious Quran Printing Complex',
    version: '1.1.0',
  );

  factory QuranEdition.fromMap(Map<String, dynamic> map) {
    return QuranEdition(
      id: map['id'] as String,
      name: map['name'] as String,
      englishName: map['english_name'] as String,
      language: map['language'] as String? ?? 'ar',
      scriptType: map['script_type'] as String? ?? 'uthmani',
      fontRequirements: map['font_requirements'] as String? ?? '',
      sourceReference: map['source_reference'] as String? ?? '',
      version: map['version'] as String? ?? '1.0.0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'english_name': englishName,
      'language': language,
      'script_type': scriptType,
      'font_requirements': fontRequirements,
      'source_reference': sourceReference,
      'version': version,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        englishName,
        language,
        scriptType,
        fontRequirements,
        sourceReference,
        version,
      ];
}
