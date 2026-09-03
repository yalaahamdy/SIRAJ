import 'package:equatable/equatable.dart';

/// Represents the authentic, segregated scholarly exegesis (Tafsir) of a single Quranic Ayah (§13, §14).
/// Completely separated from the canonical Arabic text to uphold Law 3.
class AyahTafsir extends Equatable {
  final int surahNumber;
  final int ayahNumber;
  final String tafsirText;
  final String hash;

  const AyahTafsir({
    required this.surahNumber,
    required this.ayahNumber,
    required this.tafsirText,
    required this.hash,
  });

  factory AyahTafsir.fromJson(Map<String, dynamic> json) {
    return AyahTafsir(
      surahNumber: json['surah_number'] as int,
      ayahNumber: json['ayah_number'] as int,
      tafsirText: json['tafsir_text'] as String,
      hash: json['hash'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
        'tafsir_text': tafsirText,
        'hash': hash,
      };

  @override
  List<Object?> get props => [surahNumber, ayahNumber, tafsirText, hash];
}

/// Metadata describing an authentic, peer-reviewed Tafsir edition.
class TafsirEdition extends Equatable {
  final String id;
  final String nameArabic;
  final String nameEnglish;
  final String author;
  final String publisher;
  final String language;
  final String license;
  final String provenance;

  const TafsirEdition({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.author,
    required this.publisher,
    required this.language,
    required this.license,
    required this.provenance,
  });

  factory TafsirEdition.fromJson(Map<String, dynamic> json) {
    return TafsirEdition(
      id: json['edition_id'] as String? ?? json['package_id'] as String? ?? 'ar.muyassar',
      nameArabic: json['name_arabic'] as String? ?? 'التفسير الميسر',
      nameEnglish: json['name_english'] as String? ?? 'Al-Tafsir Al-Muyassar',
      author: json['author'] as String? ?? 'نخبة من العلماء',
      publisher: json['publisher'] as String? ?? 'مجمع الملك فهد لطباعة المصحف الشريف',
      language: json['language'] as String? ?? 'ar',
      license: json['license'] as String? ?? 'Public Domain / Free for Islamic Dissemination',
      provenance: json['provenance'] as String? ?? 'King Fahd Glorious Quran Printing Complex',
    );
  }

  static const alMuyassar = TafsirEdition(
    id: 'ar.muyassar',
    nameArabic: 'التفسير الميسر',
    nameEnglish: 'Al-Tafsir Al-Muyassar',
    author: 'نخبة من العلماء بإشراف مجمع الملك فهد لطباعة المصحف الشريف',
    publisher: 'مجمع الملك فهد لطباعة المصحف الشريف',
    language: 'ar',
    license: 'Public Domain / Free for Islamic Dissemination',
    provenance: 'King Fahd Glorious Quran Printing Complex',
  );

  @override
  List<Object?> get props => [id, nameArabic, nameEnglish, author, publisher, language];
}

/// Canonical, immutable package of Tafsir records for offline reading.
class CanonicalTafsirPackage extends Equatable {
  final TafsirEdition edition;
  final String version;
  final int totalRecords;
  final String contentHash;
  final Map<String, AyahTafsir> tafsirsByKey;

  const CanonicalTafsirPackage({
    required this.edition,
    required this.version,
    required this.totalRecords,
    required this.contentHash,
    required this.tafsirsByKey,
  });

  factory CanonicalTafsirPackage.fromJson(Map<String, dynamic> json) {
    final manifest = json['manifest'] as Map<String, dynamic>? ?? {};
    final edition = TafsirEdition.fromJson(manifest);
    final version = manifest['version'] as String? ?? '1.0.0';
    final totalRecords = manifest['total_records'] as int? ?? 0;
    final contentHash = manifest['content_hash'] as String? ?? '';

    final list = json['tafsirs'] as List<dynamic>? ?? [];
    final map = <String, AyahTafsir>{};
    for (final item in list) {
      final t = AyahTafsir.fromJson(item as Map<String, dynamic>);
      map['${t.surahNumber}:${t.ayahNumber}'] = t;
    }

    return CanonicalTafsirPackage(
      edition: edition,
      version: version,
      totalRecords: totalRecords,
      contentHash: contentHash,
      tafsirsByKey: map,
    );
  }

  AyahTafsir? getTafsir(int surahNumber, int ayahNumber) {
    return tafsirsByKey['$surahNumber:$ayahNumber'];
  }

  @override
  List<Object?> get props => [edition, version, totalRecords, contentHash];
}
