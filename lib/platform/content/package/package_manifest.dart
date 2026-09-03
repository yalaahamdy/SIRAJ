import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

/// Manifest document defining package identity, file checksums, and cryptographic signatures.
class PackageManifest extends Equatable {
  final String packageId;
  final String version;
  final String targetModule;
  final DateTime createdAt;
  final Map<String, String> fileHashes; // recordId or filename -> sha256
  final String signature;
  final String signerIdentity;
  final String signatureAlgorithm;

  const PackageManifest({
    required this.packageId,
    required this.version,
    required this.targetModule,
    required this.createdAt,
    required this.fileHashes,
    required this.signature,
    required this.signerIdentity,
    this.signatureAlgorithm = 'ed25519',
  });

  /// Deterministic payload of the manifest used for signing and verification.
  String computeSignablePayload() {
    final sortedKeys = fileHashes.keys.toList()..sort();
    final buffer = StringBuffer();
    buffer.writeln('PACKAGE:$packageId');
    buffer.writeln('VERSION:$version');
    buffer.writeln('MODULE:$targetModule');
    buffer.writeln('CREATED:${createdAt.toIso8601String()}');
    buffer.writeln('SIGNER:$signerIdentity');
    for (final key in sortedKeys) {
      buffer.writeln('FILE:$key=${fileHashes[key]}');
    }
    return buffer.toString();
  }

  /// Calculates SHA-256 fingerprint of the manifest signable payload.
  String computeManifestDigest() {
    final bytes = utf8.encode(computeSignablePayload());
    final digest = sha256.convert(bytes);
    return 'sha256:${digest.toString()}';
  }

  @override
  List<Object?> get props => [
        packageId,
        version,
        targetModule,
        createdAt,
        fileHashes,
        signature,
        signerIdentity,
        signatureAlgorithm,
      ];
}
