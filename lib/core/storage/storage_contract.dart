import '../errors/app_failure.dart';
import '../errors/result.dart';

/// Contract for isolated key-value / document storage.
abstract class KeyValueStore {
  /// Unique module namespace (e.g., 'mod_settings', 'mod_tracker').
  String get namespace;

  Future<Result<void, StorageFailure>> setString(String key, String value);
  Future<Result<String?, StorageFailure>> getString(String key);

  Future<Result<void, StorageFailure>> setInt(String key, int value);
  Future<Result<int?, StorageFailure>> getInt(String key);

  Future<Result<void, StorageFailure>> setBool(String key, bool value);
  Future<Result<bool?, StorageFailure>> getBool(String key);

  Future<Result<void, StorageFailure>> remove(String key);
  Future<Result<void, StorageFailure>> clear();
  Future<Result<bool, StorageFailure>> containsKey(String key);
}

/// Registry to obtain storage instances with strictly enforced module namespace boundaries.
abstract class StorageRegistry {
  /// Returns or creates a store for a given module namespace.
  /// Throws or returns error if namespace does not follow `mod_` convention.
  KeyValueStore getStoreForModule(String moduleNamespace);
}
