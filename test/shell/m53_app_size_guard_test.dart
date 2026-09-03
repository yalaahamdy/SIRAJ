import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  group('M53: SIRAJ v1.0 — App Size & Packaging Guard Suite (§20, §40)', () {
    test('Gradle Packaging: Release builds must NOT retain unstripped native debug symbols', () {
      final buildGradleFile = File('android/app/build.gradle.kts');
      expect(buildGradleFile.existsSync(), isTrue, reason: 'build.gradle.kts must exist');

      final content = buildGradleFile.readAsStringSync();
      expect(
        content.contains('keepDebugSymbols'),
        isFalse,
        reason: 'keepDebugSymbols must not be enabled globally in build.gradle.kts as it bloats libflutter.so to 147MB per ABI',
      );
    });

    test('Asset Integrity: Workspace must NOT contain accidental multi-megabyte fixture blobs in assets/', () {
      final assetsDir = Directory('assets');
      if (assetsDir.existsSync()) {
        for (final entity in assetsDir.listSync(recursive: true)) {
          if (entity is File) {
            final sizeInMb = entity.lengthSync() / (1024 * 1024);
            expect(
              sizeInMb,
              lessThan(25.0),
              reason: 'Asset ${entity.path} ($sizeInMb MB) exceeds 25MB threshold. Compress or stream large assets.',
            );
          }
        }
      }
    });

    test('Seed Provider: Seed packages are memoized and do not recreate duplicate objects', () {
      final q1 = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      final q2 = DefaultCanonicalSeedProvider.getQuranSeedPackage();
      expect(identical(q1, q2), isTrue, reason: 'Quran seed package must be memoized in memory');

      final a1 = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      final a2 = DefaultCanonicalSeedProvider.getAdhkarSeedPackage();
      expect(identical(a1, a2), isTrue, reason: 'Adhkar seed package must be memoized in memory');
    });
  });
}
