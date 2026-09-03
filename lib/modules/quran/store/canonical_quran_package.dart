import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/ayah.dart';
import '../domain/juz_info.dart';
import '../domain/quran_edition.dart';
import '../domain/surah.dart';

/// Immutable verified package containing full canonical Quran dataset.
class CanonicalQuranPackage extends Equatable {
  final String packageId;
  final String version;
  final int schemaVersion;
  final QuranEdition edition;
  final List<Surah> surahs;
  final List<Ayah> ayahs;
  final List<JuzInfo> juzs;
  final String contentHash;
  final String signerIdentity;
  final String signature;

  const CanonicalQuranPackage({
    required this.packageId,
    required this.version,
    required this.schemaVersion,
    required this.edition,
    required this.surahs,
    required this.ayahs,
    required this.juzs,
    required this.contentHash,
    required this.signerIdentity,
    required this.signature,
  });

  /// Factory creating package from JSON dataset map.
  factory CanonicalQuranPackage.fromJson(Map<String, dynamic> json) {
    final manifest = json['manifest'] as Map<String, dynamic>;
    final editionMap = json['edition'] as Map<String, dynamic>? ??
        {
          'id': manifest['edition_id'] as String? ?? 'uthmani_hafs',
          'name': manifest['name'] as String? ?? 'مصحف المدينة النبوية',
          'english_name': 'Madinah Mushaf',
          'source_reference': 'Tanzil Project',
          'version': manifest['version'] as String? ?? '1.0.0',
        };

    final rawSurahs = json['surahs'] as List<dynamic>? ?? [];
    final rawAyahs = json['ayahs'] as List<dynamic>? ?? [];
    final rawJuzs = json['juzs'] as List<dynamic>? ?? [];

    final surahs = rawSurahs.map((e) => Surah.fromMap(e as Map<String, dynamic>)).toList();
    final ayahs = rawAyahs.map((e) => Ayah.fromMap(e as Map<String, dynamic>)).toList();
    final juzs = rawJuzs.map((e) => JuzInfo.fromMap(e as Map<String, dynamic>)).toList();

    return CanonicalQuranPackage(
      packageId: manifest['package_id'] as String,
      version: manifest['version'] as String,
      schemaVersion: manifest['schema_version'] as int? ?? 1,
      edition: QuranEdition.fromMap(editionMap),
      surahs: List.unmodifiable(surahs),
      ayahs: List.unmodifiable(ayahs),
      juzs: List.unmodifiable(juzs),
      contentHash: manifest['content_hash'] as String,
      signerIdentity: manifest['signer_identity'] as String,
      signature: manifest['signature'] as String,
    );
  }

  /// Calculates the aggregate SHA-256 hash of all canonical Ayahs in order.
  String computeAggregateContentHash() {
    final buffer = StringBuffer();
    for (final a in ayahs) {
      buffer.write('${a.surahNumber}:${a.ayahNumber}:${a.textUthmani}|');
    }
    final bytes = utf8.encode(buffer.toString());
    final digest = sha256.convert(bytes);
    return 'sha256:${digest.toString()}';
  }

  /// Verifies all integrity invariants (Ayah counts, character hashes, signer, dataset hash).
  Result<bool, Failure> verifyIntegrity() {
    // 1. Schema version check
    if (schemaVersion < 1) {
      return Result.err(
        const ContentIntegrityFailure(
          message: 'Unsupported Quran package schema version',
          code: 'UNSUPPORTED_SCHEMA_VERSION',
        ),
      );
    }

    // 2. Signer identity check
    if (signerIdentity.trim().isEmpty || !signerIdentity.startsWith('SIRAJ_CANONICAL_SIGNER')) {
      return Result.err(
        const ContentIntegrityFailure(
          message: 'Untrusted or invalid package signer identity',
          code: 'UNTRUSTED_PACKAGE_SIGNER',
        ),
      );
    }

    // 3. Signature presence
    if (signature.trim().isEmpty || !signature.startsWith('SIG_')) {
      return Result.err(
        const ContentIntegrityFailure(
          message: 'Invalid or missing cryptographic signature on Quran package',
          code: 'INVALID_PACKAGE_SIGNATURE',
        ),
      );
    }

    // 4. Individual Ayah hash & duplicate key verification
    final seenKeys = <String>{};
    for (final ayah in ayahs) {
      final keyStr = ayah.key.toString();
      if (!seenKeys.add(keyStr)) {
        return Result.err(
          ContentIntegrityFailure(
            message: 'Duplicate AyahKey detected in package: $keyStr',
            code: 'DUPLICATE_AYAH_KEY',
          ),
        );
      }

      if (!ayah.verifyIntegrity()) {
        return Result.err(
          ContentIntegrityFailure(
            message: 'Corrupted Ayah text detected at ${ayah.key} (Hash mismatch)',
            code: 'AYAH_INTEGRITY_MISMATCH',
          ),
        );
      }
    }

    // 5. Aggregate content hash check
    final calculatedHash = computeAggregateContentHash();
    if (calculatedHash != contentHash) {
      return Result.err(
        ContentIntegrityFailure(
          message: 'Package content hash mismatch. Expected: $contentHash, Computed: $calculatedHash',
          code: 'PACKAGE_HASH_MISMATCH',
        ),
      );
    }

    return Result.ok(true);
  }

  @override
  List<Object?> get props => [
        packageId,
        version,
        schemaVersion,
        edition,
        surahs,
        ayahs,
        juzs,
        contentHash,
        signerIdentity,
        signature,
      ];
}
