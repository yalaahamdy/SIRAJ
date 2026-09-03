import 'package:equatable/equatable.dart';

/// Single Ayah translation entity segregated strictly from canonical Arabic text (§13).
class AyahTranslation extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final String text;

  const AyahTranslation({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
  });

  factory AyahTranslation.fromMap(Map<String, dynamic> map) {
    return AyahTranslation(
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      text: map['translation_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'translation_text': text,
    };
  }

  @override
  List<Object?> get props => [surahNumber, ayahNumber, text];
}

/// Verified Translation Package with provenance and license metadata.
class QuranTranslationPackage extends Equatable {
  final String id;
  final String language;
  final String languageName;
  final String? languageNativeName;
  final String author;
  final String provenance;
  final String version;
  final List<AyahTranslation> translations;

  const QuranTranslationPackage({
    required this.id,
    required this.language,
    required this.languageName,
    this.languageNativeName,
    required this.author,
    required this.provenance,
    required this.version,
    required this.translations,
  });

  factory QuranTranslationPackage.fromMap(Map<String, dynamic> map) {
    final manifest = map['manifest'] as Map<String, dynamic>? ?? {};
    final list = (map['translations'] as List<dynamic>?) ?? [];

    return QuranTranslationPackage(
      id: manifest['id'] as String? ?? 'trans_en_v1',
      language: manifest['language'] as String? ?? 'en',
      languageName: manifest['language_name'] as String? ?? 'English',
      languageNativeName: manifest['language_native_name'] as String?,
      author: manifest['author'] as String? ?? 'Dr. Mustafa Khattab (The Clear Quran)',
      provenance: manifest['provenance'] as String? ?? 'Tanzil / quranjson (MIT License)',
      version: manifest['version'] as String? ?? '1.0.0',
      translations: list.map((e) => AyahTranslation.fromMap(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  List<Object?> get props => [id, language, languageName, languageNativeName, author, provenance, version, translations];
}

/// Metadata representation for supported translation editions in SIRAJ (§13, §16).
class QuranTranslationInfo extends Equatable {
  final String code;
  final String nameEnglish;
  final String nameNative;
  final String author;
  final String fileName;

  const QuranTranslationInfo({
    required this.code,
    required this.nameEnglish,
    required this.nameNative,
    required this.author,
    required this.fileName,
  });

  @override
  List<Object?> get props => [code, nameEnglish, nameNative, author, fileName];
}

/// All 11 verified translations bundled offline with SIRAJ from risan/quran-json.
const kAvailableQuranTranslations = <QuranTranslationInfo>[
  QuranTranslationInfo(
    code: 'en',
    nameEnglish: 'English',
    nameNative: 'English',
    author: 'Dr. Mustafa Khattab / Saheeh Int.',
    fileName: 'en_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'fr',
    nameEnglish: 'French',
    nameNative: 'Français',
    author: 'Muhammad Hamidullah',
    fileName: 'fr_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'es',
    nameEnglish: 'Spanish',
    nameNative: 'Español',
    author: 'Julio Cortes / Raúl González',
    fileName: 'es_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'id',
    nameEnglish: 'Indonesian',
    nameNative: 'Bahasa Indonesia',
    author: 'Kementerian Agama RI',
    fileName: 'id_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'ur',
    nameEnglish: 'Urdu',
    nameNative: 'اردو',
    author: 'Fateh Muhammad Jalandhry',
    fileName: 'ur_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'tr',
    nameEnglish: 'Turkish',
    nameNative: 'Türkçe',
    author: 'Diyanet Isleri Baskanligi',
    fileName: 'tr_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'ru',
    nameEnglish: 'Russian',
    nameNative: 'Русский',
    author: 'Elmir Kuliev',
    fileName: 'ru_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'bn',
    nameEnglish: 'Bengali',
    nameNative: 'বাংলা',
    author: 'Muhiuddin Khan',
    fileName: 'bn_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'zh',
    nameEnglish: 'Chinese',
    nameNative: '中文',
    author: 'Ma Jian',
    fileName: 'zh_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'sv',
    nameEnglish: 'Swedish',
    nameNative: 'Svenska',
    author: 'Knut Bernström',
    fileName: 'sv_translation_v1.json',
  ),
  QuranTranslationInfo(
    code: 'transliteration',
    nameEnglish: 'Transliteration',
    nameNative: 'English Transliteration',
    author: 'Tanzil Project Transliteration',
    fileName: 'transliteration_v1.json',
  ),
];
