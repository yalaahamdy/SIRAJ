import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sacred Content Firewall Linter (Law 2, Law 3, SACRED_CONTENT_POLICY.md)', () {
    final libDir = Directory('lib');

    // Forbidden test signatures of common religious texts that must never be hardcoded into UI or source code
    final forbiddenPhrases = [
      'بسم الله الرحمن الرحيم',
      'الحمد لله رب العالمين',
      'قل هو الله أحد',
      'إنما الأعمال بالنيات',
      'لا إله إلا الله وحده لا شريك له',
    ];

    test('Source code in lib/ must NOT contain embedded religious verses or hadith texts (Law 3)', () {
      final violations = <String>[];

      for (final file in libDir.listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final content = file.readAsStringSync();

        for (final phrase in forbiddenPhrases) {
          if (content.contains(phrase)) {
            violations.add('Violation in ${file.path}: Contains hardcoded sacred phrase "$phrase"');
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Sacred Content Firewall breach: Religious text must live ONLY in signed data packages outside application source code (Law 3). Violations:\n${violations.join('\n')}',
      );
    });

    test('Production Quran code in lib/ must NOT import test fixtures, mocks, or synthetic data', () {
      final violations = <String>[];
      final forbiddenImports = [
        'test/',
        'fixture',
        'mock',
        'synthetic',
        'canonical_quran_fixture',
        'canonical_quran_ayahs_data',
      ];

      final quranDirs = [
        Directory('lib/modules/quran'),
        Directory('lib/shell/quran'),
      ];

      for (final dir in quranDirs) {
        if (!dir.existsSync()) continue;
        for (final file in dir.listSync(recursive: true).whereType<File>()) {
          if (!file.path.endsWith('.dart')) continue;
          final lines = file.readAsLinesSync();

          for (int i = 0; i < lines.length; i++) {
            final line = lines[i].trim();
            if (line.startsWith('import ') || line.startsWith('export ')) {
              for (final forbidden in forbiddenImports) {
                if (line.toLowerCase().contains(forbidden.toLowerCase())) {
                  violations.add('Illegal import in ${file.path}:${i + 1} -> "$line"');
                }
              }
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'Architecture Guardrail breach: Production code in lib/ must never import test fixtures or synthetic files. Violations:\n${violations.join('\n')}',
      );
    });
  });
}
