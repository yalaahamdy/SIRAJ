import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';

void main() {
  group('Quran Canonical Cryptographic Integrity Audit Suite (§3, §15, §19)', () {
    test('Canonical package matches official manifest aggregate SHA-256 and individual surahs', () {
      final manifestFile = File('docs/quran/quran_canonical_manifest.json');
      expect(manifestFile.existsSync(), isTrue, reason: 'docs/quran/quran_canonical_manifest.json must exist');

      final manifestJson = jsonDecode(manifestFile.readAsStringSync()) as Map<String, dynamic>;
      final manifestAggregateHash = manifestJson['aggregate_sha256'] as String;

      final package = CanonicalQuranLoader.loadPackageSync();

      // Verify aggregate content hash
      final calculatedAggregateHash = package.computeAggregateContentHash();
      expect(
        calculatedAggregateHash,
        equals(manifestAggregateHash),
        reason: 'Aggregate SHA-256 hash mismatch between package and manifest!',
      );

      // Verify package internal contentHash field
      expect(
        package.contentHash,
        equals(manifestAggregateHash),
        reason: 'Package contentHash does not match manifest aggregate_sha256',
      );

      // Verify each individual Ayah hash
      for (final ayah in package.ayahs) {
        final expectedAyahHash = 'sha256:${sha256.convert(utf8.encode(ayah.textUthmani)).toString()}';
        expect(
          ayah.integrityHash,
          equals(expectedAyahHash),
          reason: 'Individual Ayah hash mismatch at ${ayah.surahNumber}:${ayah.ayahNumber}',
        );
      }
    });

    test('Full package verification passes all governance integrity checks', () {
      final package = CanonicalQuranLoader.loadPackageSync();
      final integrityResult = package.verifyIntegrity();
      expect(integrityResult.isSuccess, isTrue, reason: integrityResult.failureOrNull?.message);
    });
  });
}
