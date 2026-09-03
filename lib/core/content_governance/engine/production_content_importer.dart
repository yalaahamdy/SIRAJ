import '../models/canonical_content_package.dart';
import 'canonical_content_registry.dart';
import 'content_signing_service.dart';

/// Secure importer for canonical packages enforcing structural checks and synthetic data firewall (§25, §26, §47).
class ProductionContentImporter {
  final CanonicalContentRegistry _registry;
  final ContentSigningService _signingService;

  const ProductionContentImporter({
    required CanonicalContentRegistry registry,
    required ContentSigningService signingService,
  })  : _registry = registry,
        _signingService = signingService;

  /// Imports and validates a production content package candidate (§25, §26, §47).
  bool importPackage(CanonicalContentPackage package) {
    // 1. Synthetic Data Firewall: Strictly reject synthetic or test fixtures (§47)
    if (package.isSynthetic || package.packageId.contains('synthetic') || package.packageId.contains('fixture')) {
      return false;
    }

    // 2. Schema and Structural Check (§26)
    if (package.packageId.isEmpty ||
        package.version.isEmpty ||
        package.contentHashSha256.isEmpty ||
        package.sourceEdition.isEmpty) {
      return false;
    }

    // 3. Signature Verification (§26)
    if (!_signingService.verifyPackageSignature(package)) {
      return false;
    }

    // Register package as signed candidate
    _registry.registerPackage(package);
    return true;
  }
}
