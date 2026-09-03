import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

void main() async {
  stdout.writeln('=== SIRAJ TAFSIR INGESTION PIPELINE (AL-TAFSIR AL-MUYASSAR) ===');

  final client = HttpClient();
  client.connectionTimeout = const Duration(seconds: 15);

  final allTafsirs = <Map<String, dynamic>>[];
  int totalAyahsIngested = 0;

  for (int surahNum = 1; surahNum <= 114; surahNum++) {
    final url = Uri.parse(
      'https://raw.githubusercontent.com/spa5k/tafsir_api/main/tafsir/ar-tafsir-muyassar/$surahNum.json',
    );

    String body = '';
    int retries = 3;
    while (retries > 0) {
      try {
        final req = await client.getUrl(url);
        final resp = await req.close();
        if (resp.statusCode == 200) {
          body = await resp.transform(utf8.decoder).join();
          break;
        } else {
          stderr.writeln('Surah $surahNum returned status ${resp.statusCode}, retrying...');
          retries--;
          await Future.delayed(const Duration(milliseconds: 500));
        }
      } catch (e) {
        stderr.writeln('Error fetching Surah $surahNum: $e, retrying...');
        retries--;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    if (body.isEmpty) {
      stderr.writeln('FATAL: Failed to fetch Tafsir for Surah $surahNum');
      exit(1);
    }

    final list = jsonDecode(body) as List<dynamic>;
    for (final item in list) {
      final textRaw = (item['text'] as String? ?? '').trim();
      final textClean = textRaw
          .replaceAll('\uFEFF', '')
          .replaceAll('\u200B', '')
          .replaceAll('\u200C', '')
          .replaceAll('\u200D', '')
          .replaceAll('\r', '')
          .trim();

      final ayahNum = item['ayah'] as int;
      final ayahHash = 'sha256:${sha256.convert(utf8.encode(textClean))}';

      allTafsirs.add({
        'surah_number': surahNum,
        'ayah_number': ayahNum,
        'tafsir_text': textClean,
        'hash': ayahHash,
      });
      totalAyahsIngested++;
    }

    if (surahNum % 20 == 0 || surahNum == 114) {
      stdout.writeln('Ingested Surahs 1..$surahNum ($totalAyahsIngested Ayahs so far)...');
    }
  }

  client.close();

  stdout.writeln('Calculating aggregate package hash...');
  final buffer = StringBuffer();
  for (final t in allTafsirs) {
    buffer.write('${t['surah_number']}:${t['ayah_number']}:${t['tafsir_text']}|');
  }
  final aggregateHash = 'sha256:${sha256.convert(utf8.encode(buffer.toString()))}';

  final package = {
    'manifest': {
      'package_id': 'pkg_tafsir_ar_muyassar_v1',
      'edition_id': 'ar.muyassar',
      'name_arabic': 'التفسير الميسر',
      'name_english': 'Al-Tafsir Al-Muyassar',
      'author': 'نخبة من العلماء بإشراف مجمع الملك فهد لطباعة المصحف الشريف',
      'publisher': 'مجمع الملك فهد لطباعة المصحف الشريف',
      'language': 'ar',
      'version': '1.0.0',
      'total_records': totalAyahsIngested,
      'content_hash': aggregateHash,
      'license': 'Public Domain / Free for Islamic Dissemination',
      'provenance': 'King Fahd Glorious Quran Printing Complex via spa5k/tafsir_api authenticated archive',
      'ingested_at': DateTime.now().toUtc().toIso8601String(),
    },
    'tafsirs': allTafsirs,
  };

  final outDir = Directory('assets/quran/tafsir');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  final outFile = File('assets/quran/tafsir/ar_muyassar_v1.json');
  final jsonEncoded = jsonEncode(package);
  outFile.writeAsStringSync(jsonEncoded);

  stdout.writeln('--- SUCCESS ---');
  stdout.writeln('Saved Tafsir package to ${outFile.path}');
  stdout.writeln('Total records: $totalAyahsIngested');
  stdout.writeln('File size: ${outFile.lengthSync()} bytes');
  stdout.writeln('Aggregate Hash: $aggregateHash');
}
