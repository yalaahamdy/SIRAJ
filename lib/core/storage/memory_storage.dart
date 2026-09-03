import '../errors/app_failure.dart';
import '../errors/result.dart';
import 'storage_contract.dart';

/// In-memory implementation of KeyValueStore for testing and fast local cache.
class MemoryKeyValueStore implements KeyValueStore {
  @override
  final String namespace;

  final Map<String, dynamic> _storage = {};

  MemoryKeyValueStore(this.namespace) {
    if (!namespace.startsWith('mod_') && !namespace.startsWith('sys_')) {
      throw ArgumentError('Namespace must start with mod_ or sys_: $namespace');
    }
  }

  @override
  Future<Result<void, StorageFailure>> setString(String key, String value) async {
    _storage[key] = value;
    return Result.ok(null);
  }

  @override
  Future<Result<String?, StorageFailure>> getString(String key) async {
    final val = _storage[key];
    if (val == null) return Result.ok(null);
    if (val is String) return Result.ok(val);
    return Result.err(StorageFailure(message: 'Value for key "$key" is not a String in $namespace'));
  }

  @override
  Future<Result<void, StorageFailure>> setInt(String key, int value) async {
    _storage[key] = value;
    return Result.ok(null);
  }

  @override
  Future<Result<int?, StorageFailure>> getInt(String key) async {
    final val = _storage[key];
    if (val == null) return Result.ok(null);
    if (val is int) return Result.ok(val);
    return Result.err(StorageFailure(message: 'Value for key "$key" is not an int in $namespace'));
  }

  @override
  Future<Result<void, StorageFailure>> setBool(String key, bool value) async {
    _storage[key] = value;
    return Result.ok(null);
  }

  @override
  Future<Result<bool?, StorageFailure>> getBool(String key) async {
    final val = _storage[key];
    if (val == null) return Result.ok(null);
    if (val is bool) return Result.ok(val);
    return Result.err(StorageFailure(message: 'Value for key "$key" is not a bool in $namespace'));
  }

  @override
  Future<Result<void, StorageFailure>> remove(String key) async {
    _storage.remove(key);
    return Result.ok(null);
  }

  @override
  Future<Result<void, StorageFailure>> clear() async {
    _storage.clear();
    return Result.ok(null);
  }

  @override
  Future<Result<bool, StorageFailure>> containsKey(String key) async {
    return Result.ok(_storage.containsKey(key));
  }
}

/// Registry that manages isolated MemoryKeyValueStores.
class MemoryStorageRegistry implements StorageRegistry {
  final Map<String, MemoryKeyValueStore> _stores = {};

  @override
  KeyValueStore getStoreForModule(String moduleNamespace) {
    if (!moduleNamespace.startsWith('mod_') && !moduleNamespace.startsWith('sys_')) {
      throw ArgumentError(
        'Storage boundary violation: Module namespace must begin with "mod_" or "sys_": $moduleNamespace',
      );
    }
    return _stores.putIfAbsent(
      moduleNamespace,
      () => MemoryKeyValueStore(moduleNamespace),
    );
  }

  void clearAll() {
    for (final store in _stores.values) {
      store.clear();
    }
    _stores.clear();
  }
}
