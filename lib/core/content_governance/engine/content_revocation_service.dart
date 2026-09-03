import '../models/canonical_content_package.dart';
import 'canonical_content_registry.dart';

/// Emergency revocation and quarantine service for canonical content packages (§30, §31, §41).
class ContentRevocationService {
  final CanonicalContentRegistry _registry;

  const ContentRevocationService({
    required CanonicalContentRegistry registry,
  }) : _registry = registry;

  /// Revokes an active or candidate package immediately (§30, §41).
  bool revokePackage({
    required String packageId,
    required String reasonArabic,
  }) {
    final package = _registry.getPackage(packageId);
    if (package == null) return false;

    final revoked = package.copyWith(
      reviewState: ContentReviewState.revoked,
      metadata: {
        ...package.metadata,
        'revocation_reason': reasonArabic,
        'revoked_at': DateTime.now().toIso8601String(),
      },
    );

    _registry.registerPackage(revoked);
    return true;
  }

  /// Places a package into quarantine (§28).
  bool quarantinePackage({
    required String packageId,
    required String reasonArabic,
  }) {
    final package = _registry.getPackage(packageId);
    if (package == null) return false;

    final quarantined = package.copyWith(
      reviewState: ContentReviewState.quarantined,
      metadata: {
        ...package.metadata,
        'quarantine_reason': reasonArabic,
        'quarantined_at': DateTime.now().toIso8601String(),
      },
    );

    _registry.registerPackage(quarantined);
    return true;
  }
}
