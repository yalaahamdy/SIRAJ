import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/tajweed_rule.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('Quran Tajweed Rules & Rendering Layer Suite (§12, §15)', () {
    test('Tajweed rules load correctly from verified canonical asset', () {
      final rules = CanonicalQuranLoader.loadTajweedRulesSync();
      expect(rules.isNotEmpty, isTrue);
      expect(rules.containsKey('1'), isTrue); // Surah 1 rules exist
    });

    test('Canonical Arabic text bytes are 100% immutable and unaltered by Tajweed rendering', () {
      final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      final surah1Ayahs = package.ayahs.where((a) => a.surahNumber == 1).toList();
      final rules = CanonicalQuranLoader.loadTajweedRulesSync();
      final surah1Rules = rules['1'] as Map<String, dynamic>? ?? {};

      for (final ayah in surah1Ayahs) {
        final ayahRules = surah1Rules['verse_${ayah.ayahNumber}'] as List<dynamic>?;

        final spans = TajweedRenderer.buildSpans(
          textUthmani: ayah.textUthmani,
          rawRules: ayahRules,
          baseStyle: const TextStyle(fontSize: 22),
        );

        // Concatenate all span texts
        final reconstructedText = spans.map((s) => s.text ?? '').join();

        // Invariant: The reconstructed string from spans MUST equal the canonical text exactly!
        expect(
          reconstructedText,
          equals(ayah.textUthmani),
          reason: 'Text altered during Tajweed rendering at ${ayah.surahNumber}:${ayah.ayahNumber}',
        );
      }
    });

    test('TajweedRuleType maps correctly and provides authentic Arabic labels and distinct colors', () {
      expect(TajweedRuleType.ghunnah.labelArabic, equals('غنة'));
      expect(TajweedRuleType.ikhfa.labelArabic, equals('إخفاء'));
      expect(TajweedRuleType.qalqalah.labelArabic, equals('قلقلة'));
      expect(TajweedRuleType.iqlab.labelArabic, equals('إقلاب'));

      // Check color distinctions
      final colors = TajweedRuleType.values.map((e) => e.color).toSet();
      expect(colors.length, greaterThan(5));
    });

    test('Fallback to plain span when rules are null or empty', () {
      const plainText = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
      final spans = TajweedRenderer.buildSpans(
        textUthmani: plainText,
        rawRules: null,
        baseStyle: const TextStyle(fontSize: 20),
      );

      expect(spans.length, equals(1));
      expect(spans.first.text, equals(plainText));
    });
  });
}
