import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Quran Architecture Guardrails & Boundaries Tests (§29, §30)', () {

    test('UI Shell (lib/shell/quran/) must NOT directly import raw canonical package internals', () {
      final shellQuranDir = Directory('lib/shell/quran');
      if (!shellQuranDir.existsSync()) return;

      final dartFiles = shellQuranDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        expect(
          content.contains('canonical_quran_package.dart'),
          isFalse,
          reason: '${file.path} must not directly import CanonicalQuranPackage',
        );
      }
    });

    test('L0 Kernel files must NOT import L2 Quran module', () {
      final l0Dir = Directory('lib/core');
      final dartFiles = l0Dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        expect(
          content.contains('modules/quran'),
          isFalse,
          reason: '${file.path} violates Layer 0 isolation by importing L2 Quran',
        );
      }
    });

    test('L1 Platform files must NOT import L2 Quran module', () {
      final l1Dir = Directory('lib/platform');
      final dartFiles = l1Dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        expect(
          content.contains('modules/quran'),
          isFalse,
          reason: '${file.path} violates Layer 1 isolation by importing L2 Quran',
        );
      }
    });
  });
}
