// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

class TranslationSpec {
  final String sourceFile;
  final String code;
  final String targetFile;
  final String languageName;
  final String languageNativeName;
  final String author;

  const TranslationSpec({
    required this.sourceFile,
    required this.code,
    required this.targetFile,
    required this.languageName,
    required this.languageNativeName,
    required this.author,
  });
}

const specs = [
  TranslationSpec(
    sourceFile: 'en.json',
    code: 'en',
    targetFile: 'en_translation_v1.json',
    languageName: 'English',
    languageNativeName: 'English',
    author: 'Dr. Mustafa Khattab (The Clear Quran) / Saheeh International',
  ),
  TranslationSpec(
    sourceFile: 'fr.json',
    code: 'fr',
    targetFile: 'fr_translation_v1.json',
    languageName: 'French',
    languageNativeName: 'Français',
    author: 'Muhammad Hamidullah',
  ),
  TranslationSpec(
    sourceFile: 'es.json',
    code: 'es',
    targetFile: 'es_translation_v1.json',
    languageName: 'Spanish',
    languageNativeName: 'Español',
    author: 'Julio Cortes / Raúl González Bórnez',
  ),
  TranslationSpec(
    sourceFile: 'id.json',
    code: 'id',
    targetFile: 'id_translation_v1.json',
    languageName: 'Indonesian',
    languageNativeName: 'Bahasa Indonesia',
    author: 'Kementerian Agama Republik Indonesia',
  ),
  TranslationSpec(
    sourceFile: 'ur.json',
    code: 'ur',
    targetFile: 'ur_translation_v1.json',
    languageName: 'Urdu',
    languageNativeName: 'اردو',
    author: 'Fateh Muhammad Jalandhry',
  ),
  TranslationSpec(
    sourceFile: 'tr.json',
    code: 'tr',
    targetFile: 'tr_translation_v1.json',
    languageName: 'Turkish',
    languageNativeName: 'Türkçe',
    author: 'Diyanet Isleri Baskanligi',
  ),
  TranslationSpec(
    sourceFile: 'ru.json',
    code: 'ru',
    targetFile: 'ru_translation_v1.json',
    languageName: 'Russian',
    languageNativeName: 'Русский',
    author: 'Elmir Kuliev',
  ),
  TranslationSpec(
    sourceFile: 'bn.json',
    code: 'bn',
    targetFile: 'bn_translation_v1.json',
    languageName: 'Bengali',
    languageNativeName: 'বাংলা',
    author: 'Muhiuddin Khan',
  ),
  TranslationSpec(
    sourceFile: 'zh.json',
    code: 'zh',
    targetFile: 'zh_translation_v1.json',
    languageName: 'Chinese',
    languageNativeName: '中文',
    author: 'Ma Jian',
  ),
  TranslationSpec(
    sourceFile: 'sv.json',
    code: 'sv',
    targetFile: 'sv_translation_v1.json',
    languageName: 'Swedish',
    languageNativeName: 'Svenska',
    author: 'Knut Bernström',
  ),
  TranslationSpec(
    sourceFile: 'transliteration.json',
    code: 'transliteration',
    targetFile: 'transliteration_v1.json',
    languageName: 'Transliteration',
    languageNativeName: 'English Transliteration',
    author: 'Tanzil Project Transliteration',
  ),
];

Future<void> main() async {
  final targetDir = Directory('assets/quran/translations');
  if (!targetDir.existsSync()) {
    targetDir.createSync(recursive: true);
  }

  final client = HttpClient();
  client.connectionTimeout = const Duration(seconds: 15);

  print('Starting download of ${specs.length} translations from risan/quran-json...');

  for (final spec in specs) {
    final url = 'https://raw.githubusercontent.com/risan/quran-json/main/data/editions/${spec.sourceFile}';
    final outFile = File('${targetDir.path}/${spec.targetFile}');

    print('Downloading ${spec.languageName} (${spec.code}) from $url...');
    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close();
      if (res.statusCode != 200) {
        print('FAILED: status code ${res.statusCode} for ${spec.code}');
        continue;
      }

      final content = await res.transform(utf8.decoder).join();
      final rawData = jsonDecode(content) as Map<String, dynamic>;

      final translationsList = <Map<String, dynamic>>[];

      // Sort chapters numerically from 1 to 114
      final chapterKeys = rawData.keys.map(int.parse).toList()..sort();
      for (final ch in chapterKeys) {
        final verses = (rawData['$ch'] as List<dynamic>?) ?? [];
        for (final v in verses) {
          final vMap = v as Map<String, dynamic>;
          translationsList.add({
            'surah_number': vMap['chapter'] as int,
            'ayah_number': vMap['verse'] as int,
            'translation_text': (vMap['text'] as String? ?? '').trim(),
          });
        }
      }

      final packageData = {
        'manifest': {
          'id': 'trans_${spec.code}_v1',
          'language': spec.code,
          'language_name': spec.languageName,
          'language_native_name': spec.languageNativeName,
          'author': spec.author,
          'provenance': 'risan/quran-json (MIT License) / Tanzil / QuranEnc',
          'version': '1.0.0',
          'ayah_count': translationsList.length,
        },
        'translations': translationsList,
      };

      outFile.writeAsStringSync(jsonEncode(packageData));
      print('SUCCESS: Saved ${spec.targetFile} with ${translationsList.length} ayahs (${(outFile.lengthSync() / 1024).toStringAsFixed(1)} KB)');
    } catch (e) {
      print('ERROR downloading ${spec.code}: $e');
    }
  }

  client.close();
  print('All translations processing completed!');
}
