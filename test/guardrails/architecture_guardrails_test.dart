import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Architecture Guardrails: Layer & Dependency Enforcement (Law 7, DEPENDENCY_GRAPH.md)', () {
    final libDir = Directory('lib');

    test('L0 Kernel files must NOT import L1 Platform, L2 Modules, L3 Services, or L4 Shell', () {
      final coreDir = Directory(p.join(libDir.path, 'core'));
      if (!coreDir.existsSync()) return;

      final violations = <String>[];
      for (final file in coreDir.listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final content = file.readAsStringSync();

        final lines = content.split('\n');
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.startsWith('import ') || line.startsWith('export ')) {
            if (line.contains('/platform/') ||
                line.contains('/modules/') ||
                line.contains('/services/') ||
                line.contains('/shell/')) {
              violations.add('${file.path}:${i + 1} -> $line');
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'L0 Kernel must only have downward / zero dependencies. Violations found:\n${violations.join('\n')}',
      );
    });

    test('L1 Platform files must NOT import L2 Modules, L3 Services, or L4 Shell', () {
      final platformDir = Directory(p.join(libDir.path, 'platform'));
      if (!platformDir.existsSync()) return;

      final violations = <String>[];
      for (final file in platformDir.listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final content = file.readAsStringSync();

        final lines = content.split('\n');
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.startsWith('import ') || line.startsWith('export ')) {
            if (line.contains('/modules/') ||
                line.contains('/services/') ||
                line.contains('/shell/')) {
              violations.add('${file.path}:${i + 1} -> $line');
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'L1 Platform must only import L0 Kernel. Violations found:\n${violations.join('\n')}',
      );
    });

    test('L2 Modules files must NOT import L3 Services or L4 Shell', () {
      final modulesDir = Directory(p.join(libDir.path, 'modules'));
      if (!modulesDir.existsSync()) return;

      final violations = <String>[];
      for (final file in modulesDir.listSync(recursive: true).whereType<File>()) {
        if (!file.path.endsWith('.dart')) continue;
        final content = file.readAsStringSync();

        final lines = content.split('\n');
        for (int i = 0; i < lines.length; i++) {
          final line = lines[i].trim();
          if (line.startsWith('import ') || line.startsWith('export ')) {
            if (line.contains('package:siraj/services/') ||
                line.contains('../../services/') ||
                line.contains('../../../services/') ||
                line.contains('/shell/')) {
              violations.add('${file.path}:${i + 1} -> $line');
            }
          }
        }
      }

      expect(
        violations,
        isEmpty,
        reason: 'L2 Modules must NOT depend upward. Violations found:\n${violations.join('\n')}',
      );
    });
  });
}
