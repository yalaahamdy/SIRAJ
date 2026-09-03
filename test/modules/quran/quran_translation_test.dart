import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/quran_translation.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('Quran Translation Segregation & Provenance Suite (§13, §15)', () {
    test('English translations dataset contains all 6,236 verses', () {
      final transMap = CanonicalQuranLoader.loadTranslationsSync();
      expect(transMap.length, equals(6236));

      // Milestone verses
      expect(transMap['1:1']?.isNotEmpty, isTrue);
      expect(transMap['2:255']?.isNotEmpty, isTrue);
      expect(transMap['112:1']?.isNotEmpty, isTrue);
      expect(transMap['114:6']?.isNotEmpty, isTrue);
    });

    test('Translation package carries authentic provenance and author attribution', () {
      final file = File('assets/quran/translations/en_translation_v1.json');
      expect(file.existsSync(), isTrue);

      final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final pkg = QuranTranslationPackage.fromMap(json);

      expect(pkg.language, equals('en'));
      expect(pkg.author.isNotEmpty, isTrue);
      expect(pkg.provenance.contains('MIT'), isTrue);
      expect(pkg.translations.length, equals(6236));
    });

    test('Translation is completely segregated and never mixed into Arabic canonical text', () {
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      final transMap = CanonicalQuranLoader.loadTranslationsSync();

      // Check that Ayah.textUthmani contains NO Latin characters
      final latinPattern = RegExp(r'[a-zA-Z]');
      for (final ayah in package.ayahs.take(100)) {
        expect(
          latinPattern.hasMatch(ayah.textUthmani),
          isFalse,
          reason: 'Latin character found in Uthmani text at ${ayah.surahNumber}:${ayah.ayahNumber}',
        );

        final translation = transMap['${ayah.surahNumber}:${ayah.ayahNumber}'];
        expect(translation, isNotNull);
      }
    });

    test('All 11 translations from risan/quran-json are bundled and contain 6,236 verses each', () {
      expect(kAvailableQuranTranslations.length, equals(11));

      for (final info in kAvailableQuranTranslations) {
        final file = File('assets/quran/translations/${info.fileName}');
        expect(file.existsSync(), isTrue, reason: 'Missing translation file ${info.fileName}');

        final transMap = CanonicalQuranLoader.loadTranslationsSync(languageCode: info.code);
        expect(transMap.length, equals(6236), reason: 'Translation ${info.code} does not have 6236 ayahs');

        // Check first ayah (1:1) and last ayah (114:6) are non-empty
        expect(transMap['1:1']?.isNotEmpty, isTrue, reason: '1:1 empty for ${info.code}');
        expect(transMap['114:6']?.isNotEmpty, isTrue, reason: '114:6 empty for ${info.code}');
      }
    });
  });
}
