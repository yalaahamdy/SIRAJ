import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M02.1 Audio Asset Resolution & Bundled Files Tests (§14, §15)', () {
    test('Canonical starter audio files for Al-Fatihah (1..7) exist on disk', () {
      for (int i = 1; i <= 7; i++) {
        final aPad = i.toString().padLeft(3, '0');
        final file = File('assets/quran/audio/001/$aPad.mp3');
        expect(file.existsSync(), isTrue, reason: 'Missing assets/quran/audio/001/$aPad.mp3');
        expect(file.lengthSync(), greaterThan(10000), reason: 'Audio file too small');
      }
    });

    test('Canonical starter audio files for Al-Baqarah (1..5) exist on disk', () {
      for (int i = 1; i <= 5; i++) {
        final aPad = i.toString().padLeft(3, '0');
        final file = File('assets/quran/audio/002/$aPad.mp3');
        expect(file.existsSync(), isTrue, reason: 'Missing assets/quran/audio/002/$aPad.mp3');
        expect(file.lengthSync(), greaterThan(10000), reason: 'Audio file too small');
      }
    });

    test('Canonical starter audio files for An-Nas (1..6) exist on disk', () {
      for (int i = 1; i <= 6; i++) {
        final aPad = i.toString().padLeft(3, '0');
        final file = File('assets/quran/audio/114/$aPad.mp3');
        expect(file.existsSync(), isTrue, reason: 'Missing assets/quran/audio/114/$aPad.mp3');
        expect(file.lengthSync(), greaterThan(8000), reason: 'Audio file too small');
      }
    });
  });
}
