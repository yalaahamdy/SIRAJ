import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/content_record.dart';
import '../domain/content_type.dart';
import '../package/content_package.dart';

/// Read-Only contract for accessing verified canonical content.
/// Strictly prohibits any write/mutate operations from downstream modules or UI (Law 3).
abstract class ContentStore {
  /// Retrieves an installed package by its package ID.
  Future<Result<ContentPackage, ContentNotFoundFailure>> getPackage(String packageId);

  /// Retrieves a specific verified content item by its canonical ID.
  Future<Result<ContentRecord, ContentNotFoundFailure>> getItem(String contentId);

  /// Queries all records of a specific [ContentType] with optional filters.
  Future<Result<List<ContentRecord>, Failure>> getCollection(
    ContentType type, {
    String? targetModule,
    String? language,
  });

  /// Verifies integrity of all currently loaded packages.
  Future<Result<bool, PackageVerificationFailure>> verifyIntegrity();

  /// Gets the installed semantic version of a package, or null if not installed.
  Future<String?> installedVersion(String packageId);
}
