import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/canonical_content_package.dart';

/// Cryptographic signing and signature verification service for canonical packages (§7, §8, §14, §15).
class ContentSigningService {
  final String _signingKeySecret;

  const ContentSigningService({
    String signingKeySecret = 'siraj_canonical_signing_key_secure_salt_2026',
  }) : _signingKeySecret = signingKeySecret;

  /// Generates HMAC-SHA256 signature binding the package ID, version, and content hash (§7, §11).
  String signPackage(CanonicalContentPackage package) {
    final payload = '${package.packageId}:${package.version}:${package.contentHashSha256}';
    final key = utf8.encode(_signingKeySecret);
    final bytes = utf8.encode(payload);
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(bytes);
    return digest.toString();
  }

  /// Verifies if a package signature is cryptographically valid and matches the exact content hash (§7, §11).
  bool verifyPackageSignature(CanonicalContentPackage package) {
    if (package.signature == null || package.signature!.isEmpty) {
      return false;
    }
    final expectedSignature = signPackage(package);
    return expectedSignature == package.signature;
  }
}
