import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/dhikr_item.dart';
import '../domain/dhikr_occasion.dart';
import 'canonical_adhkar_package.dart';

/// Read-Only In-Memory Sacred Adhkar Store with Fail-Closed Cryptographic Verification (§26, §27).
class ReadOnlyAdhkarStore {
  CanonicalAdhkarPackage? _activePackage;
  final Map<String, DhikrItem> _itemsById = {};
  final Map<DhikrOccasion, List<DhikrItem>> _itemsByOccasion = {};

  bool get isMounted => _activePackage != null;
  CanonicalAdhkarPackage? get activePackage => _activePackage;

  Result<void, Failure> mountPackage(CanonicalAdhkarPackage package) {
    // 1. Fail-closed cryptographic integrity verification
    if (!package.verifyPackageIntegrity()) {
      return Result.err(
        const PackageVerificationFailure(
          message: 'Adhkar package cryptographic integrity check failed. Mounting rejected (Fail-Closed).',
        ),
      );
    }

    // 2. Check for duplicate IDs within package
    final idSet = <String>{};
    for (final item in package.items) {
      if (!idSet.add(item.id)) {
        return Result.err(
          PackageVerificationFailure(
            message: 'Duplicate Dhikr ID detected in package: ${item.id}',
          ),
        );
      }
    }

    // 3. Build optimized O(1) in-memory indices
    _itemsById.clear();
    _itemsByOccasion.clear();

    for (final item in package.items) {
      _itemsById[item.id] = item;
      _itemsByOccasion.putIfAbsent(item.occasion, () => []).add(item);
    }

    _activePackage = package;
    return Result.ok(null);
  }

  Result<DhikrItem, Failure> getItemById(String id) {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(message: 'No Adhkar package is currently mounted.'),
      );
    }
    final item = _itemsById[id];
    if (item == null) {
      return Result.err(
        ContentNotFoundFailure(message: 'Dhikr item not found with ID: $id'),
      );
    }
    return Result.ok(item);
  }

  Result<List<DhikrItem>, Failure> getItemsByOccasion(DhikrOccasion occasion) {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(message: 'No Adhkar package is currently mounted.'),
      );
    }
    final items = _itemsByOccasion[occasion] ?? [];
    return Result.ok(List.unmodifiable(items));
  }

  Result<List<DhikrItem>, Failure> getAllItems() {
    if (!isMounted) {
      return Result.err(
        const ContentNotFoundFailure(message: 'No Adhkar package is currently mounted.'),
      );
    }
    return Result.ok(List.unmodifiable(_activePackage!.items));
  }

  void unmount() {
    _activePackage = null;
    _itemsById.clear();
    _itemsByOccasion.clear();
  }
}
