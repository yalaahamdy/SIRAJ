import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/events/app_events.dart';
import '../../../core/events/event_bus.dart';
import '../../../core/logging/app_logger.dart';
import '../domain/content_record.dart';
import '../domain/content_status.dart';
import '../domain/content_type.dart';
import '../package/content_package.dart';
import '../package/package_verifier.dart';
import 'content_store.dart';

/// In-memory and local package-backed implementation of [ContentStore].
/// Guaranteed read-only interface for feature modules and UI.
class ReadOnlyContentStore implements ContentStore {
  final Map<String, ContentPackage> _mountedPackages = {};
  final Map<String, ContentRecord> _indexedRecords = {};
  final PackageVerifier _verifier;
  final EventBus? _eventBus;
  final AppLogger? _logger;

  ReadOnlyContentStore({
    PackageVerifier? verifier,
    EventBus? eventBus,
    AppLogger? logger,
  })  : _verifier = verifier ?? PackageVerifier(eventBus: eventBus, logger: logger),
        _eventBus = eventBus,
        _logger = logger;

  /// Internal package mount procedure. Only packages passing full verification are mounted.
  Result<void, PackageVerificationFailure> mountPackage(ContentPackage package) {
    // 1. Run full Fail-Closed Verification
    final verifyResult = _verifier.verifyPackage(package);
    if (verifyResult.isFailure) {
      _logger?.error('Refusing to mount invalid package "${package.packageId}"');
      return verifyResult;
    }

    // 2. Mount package and index records
    final previous = _mountedPackages[package.packageId];
    _mountedPackages[package.packageId] = package;

    for (final record in package.records) {
      // Secondary safety check: Only approved or locked records are indexed
      if (record.status.isPubliclyDisplayable) {
        _indexedRecords[record.contentId] = record;
      }
    }

    if (previous != null) {
      _eventBus?.publish(
        PackageUpdatedEvent(
          packageId: package.packageId,
          previousVersion: previous.version,
          newVersion: package.version,
        ),
      );
    } else {
      _eventBus?.publish(
        PackageInstalledEvent(
          packageId: package.packageId,
          version: package.version,
        ),
      );
    }

    _logger?.info('Mounted package "${package.packageId}" (v${package.version}) with ${package.records.length} records.');
    return Result.ok(null);
  }

  @override
  Future<Result<ContentPackage, ContentNotFoundFailure>> getPackage(String packageId) async {
    final pkg = _mountedPackages[packageId];
    if (pkg != null) {
      return Result.ok(pkg);
    }
    return Result.err(
      ContentNotFoundFailure(
        message: 'Content package "$packageId" is not installed or verified',
      ),
    );
  }

  @override
  Future<Result<ContentRecord, ContentNotFoundFailure>> getItem(String contentId) async {
    final record = _indexedRecords[contentId];
    if (record != null) {
      // Quarantined items are hidden dynamically
      if (record.status.isQuarantined) {
        return Result.err(
          ContentNotFoundFailure(
            message: 'Content item "$contentId" is currently QUARANTINED',
          ),
        );
      }
      return Result.ok(record);
    }
    return Result.err(
      ContentNotFoundFailure(
        message: 'Content item "$contentId" not found in verified store',
      ),
    );
  }

  @override
  Future<Result<List<ContentRecord>, Failure>> getCollection(
    ContentType type, {
    String? targetModule,
    String? language,
  }) async {
    final results = _indexedRecords.values.where((r) {
      if (r.contentType != type) return false;
      if (r.status.isQuarantined || !r.status.isPubliclyDisplayable) return false;
      if (language != null && r.language != language) return false;
      return true;
    }).toList();

    return Result.ok(List.unmodifiable(results));
  }

  @override
  Future<Result<bool, PackageVerificationFailure>> verifyIntegrity() async {
    for (final package in _mountedPackages.values) {
      final res = _verifier.verifyPackage(package);
      if (res.isFailure) {
        return Result.err(res.failureOrNull!);
      }
    }
    return Result.ok(true);
  }

  @override
  Future<String?> installedVersion(String packageId) async {
    return _mountedPackages[packageId]?.version;
  }
}
