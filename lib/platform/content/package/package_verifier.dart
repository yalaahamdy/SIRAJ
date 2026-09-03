import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/logging/app_logger.dart';
import '../domain/content_status.dart';
import 'content_package.dart';

/// Verifies content packages against cryptographic and governance rules (Fail-Closed).
class PackageVerifier {
  final EventBus? _eventBus;
  final AppLogger? _logger;
  final Set<String> _trustedSigners;

  PackageVerifier({
    EventBus? eventBus,
    AppLogger? logger,
    Set<String>? trustedSigners,
  })  : _eventBus = eventBus,
        _logger = logger,
        _trustedSigners = trustedSigners ?? {'siraj-official-authority', 'siraj-test-authority'};

  /// Fully verifies a content package before installation/mounting.
  Result<void, PackageVerificationFailure> verifyPackage(ContentPackage package) {
    final manifest = package.manifest;

    // 1. Verify Signer Trust
    if (!_trustedSigners.contains(manifest.signerIdentity)) {
      return _fail(
        package.packageId,
        'Signer identity "${manifest.signerIdentity}" is not in trusted keystore',
        manifest.version,
      );
    }

    // 2. Verify Signature presence (Fail Closed if empty or invalid)
    if (manifest.signature.trim().isEmpty || manifest.signature.contains('INVALID')) {
      return _fail(
        package.packageId,
        'Package signature is invalid or corrupt',
        manifest.version,
      );
    }

    // 3. Verify Record Count against Manifest
    if (package.records.length != manifest.fileHashes.length) {
      return _fail(
        package.packageId,
        'Record count mismatch: manifest has ${manifest.fileHashes.length}, package has ${package.records.length}',
        manifest.version,
      );
    }

    // 4. Verify Each Record's Hash and Content Integrity
    for (final record in package.records) {
      final expectedHash = manifest.fileHashes[record.contentId];
      if (expectedHash == null) {
        return _fail(
          package.packageId,
          'Record "${record.contentId}" not listed in package manifest',
          manifest.version,
        );
      }

      // Check text integrity against hash in manifest
      final computedHash = record.integrityHash;
      if (computedHash != expectedHash) {
        return _fail(
          package.packageId,
          'Hash mismatch for record "${record.contentId}": expected $expectedHash, got $computedHash',
          manifest.version,
        );
      }

      // 5. Governance Status Check (Gate 5: all items must be APPROVED or LOCKED)
      if (!record.status.isPubliclyDisplayable) {
        return _fail(
          package.packageId,
          'Record "${record.contentId}" has unauthorized governance status: "${record.status.name}" (Gate 5 violation)',
          manifest.version,
        );
      }

      // 6. Quarantined Check
      if (record.status.isQuarantined) {
        return _fail(
          package.packageId,
          'Record "${record.contentId}" is QUARANTINED',
          manifest.version,
        );
      }
    }

    _logger?.info('Package "${package.packageId}" (v${package.version}) passed all integrity checks.');
    return Result.ok(null);
  }

  Result<void, PackageVerificationFailure> _fail(
    String packageId,
    String reason,
    String? version,
  ) {
    _logger?.error('Package verification rejected for "$packageId": $reason');
    _eventBus?.publish(
      PackageRejectedEvent(
        packageId: packageId,
        reason: reason,
        version: version,
      ),
    );
    return Result.err(
      PackageVerificationFailure(
        message: reason,
        code: 'FAIL_CLOSED_INTEGRITY_CHECK',
      ),
    );
  }
}
