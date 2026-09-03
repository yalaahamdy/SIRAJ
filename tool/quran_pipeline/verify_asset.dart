import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/quran/quran_canonical_v1.json');
  if (!file.existsSync()) {
    stderr.writeln('ERROR: File does not exist at ${file.path}');
    exit(1);
  }

  final bytes = file.readAsBytesSync();
  stdout.writeln('File size: ${bytes.length} bytes');

  final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
  final manifest = json['manifest'] as Map<String, dynamic>;
  final surahs = json['surahs'] as List<dynamic>;
  final ayahs = json['ayahs'] as List<dynamic>;
  final juzs = json['juzs'] as List<dynamic>;

  stdout.writeln('--- CANONICAL ASSET VERIFICATION ---');
  stdout.writeln('Package ID: ${manifest['package_id']}');
  stdout.writeln('Surah count: ${surahs.length}');
  stdout.writeln('Ayah count: ${ayahs.length}');
  stdout.writeln('Juz count: ${juzs.length}');
  stdout.writeln('First Surah: #${surahs.first['number']} - ${surahs.first['name_arabic']} (${surahs.first['name_english']}) [${surahs.first['ayah_count']} ayahs]');
  stdout.writeln('Second Surah: #${surahs[1]['number']} - ${surahs[1]['name_arabic']} (${surahs[1]['name_english']}) [${surahs[1]['ayah_count']} ayahs]');
  stdout.writeln('Middle Surah: #${surahs[56]['number']} - ${surahs[56]['name_arabic']} (${surahs[56]['name_english']}) [${surahs[56]['ayah_count']} ayahs]');
  stdout.writeln('Final Surah: #${surahs.last['number']} - ${surahs.last['name_arabic']} (${surahs.last['name_english']}) [${surahs.last['ayah_count']} ayahs]');
  stdout.writeln('Manifest Hash: ${manifest['content_hash']}');

  // Verify counts
  if (surahs.length != 114) {
    stderr.writeln('FAILED: Surah count is not 114');
    exit(1);
  }
  if (ayahs.length != 6236) {
    stderr.writeln('FAILED: Ayah count is not 6236');
    exit(1);
  }
  if (juzs.length != 30) {
    stderr.writeln('FAILED: Juz count is not 30');
    exit(1);
  }

  stdout.writeln('--- ASSET INTEGRITY VERIFIED: PASS ---');
}
