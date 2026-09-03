// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  final client = HttpClient();
  
  final items = <Map<String, int>>[];
  // Surah 1 (1..7)
  for (int a = 1; a <= 7; a++) {
    items.add({'s': 1, 'a': a});
  }
  // Surah 2 (1..5)
  for (int a = 1; a <= 5; a++) {
    items.add({'s': 2, 'a': a});
  }
  // Surah 114 (1..6)
  for (int a = 1; a <= 6; a++) {
    items.add({'s': 114, 'a': a});
  }

  print('Downloading ${items.length} starter canonical MP3 audio files...');

  for (final item in items) {
    final s = item['s']!;
    final a = item['a']!;
    final sPad = s.toString().padLeft(3, '0');
    final aPad = a.toString().padLeft(3, '0');
    final dir = Directory('assets/quran/audio/$sPad');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final targetFile = File('assets/quran/audio/$sPad/$aPad.mp3');
    final url = 'https://raw.githubusercontent.com/semarketir/quranjson/master/source/audio/$sPad/$aPad.mp3';

    try {
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close();
      if (res.statusCode == 200) {
        final bytes = await res.fold<List<int>>([], (prev, elem) => prev..addAll(elem));
        await targetFile.writeAsBytes(bytes);
        print('Saved: assets/quran/audio/$sPad/$aPad.mp3 (${bytes.length} bytes)');
      } else {
        print('Failed $s:$a -> HTTP ${res.statusCode}');
      }
    } catch (e) {
      print('Error downloading $s:$a -> $e');
    }
  }

  client.close();
  print('Starter audio download process completed.');
}
