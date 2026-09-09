import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../errors/app_failure.dart';
import '../errors/result.dart';
import 'storage_contract.dart';

/// File-backed persistent implementation of KeyValueStore.
/// Keeps an in-memory cache for instant 0ms access, and persists changes to disk as JSON.
class PersistentKeyValueStore implements KeyValueStore {
  @override
  final String namespace;
  final Directory? _storageDir;
  final Map<String, dynamic> _cache = {};
  bool _isLoaded = false;

  PersistentKeyValueStore(this.namespace, [this._storageDir]) {
    if (!namespace.startsWith('mod_') && !namespace.startsWith('sys_')) {
      throw ArgumentError('Namespace must start with mod_ or sys_: $namespace');
    }
    _loadFromDiskSync();
  }

  File? get _file {
    if (_storageDir == null) return null;
    return File('${_storageDir.path}${Platform.pathSeparator}siraj_storage_$namespace.json');
  }

  void _loadFromDiskSync() {
    if (_isLoaded) return;
    try {
      final file = _file;
      if (file != null && file.existsSync()) {
        final content = file.readAsStringSync();
        if (content.isNotEmpty) {
          final decoded = jsonDecode(content);
          if (decoded is Map<String, dynamic>) {
            _cache.addAll(decoded);
          }
        }
      }
    } catch (e) {
      debugPrint('Error reading storage for $namespace: $e');
    } finally {
      _isLoaded = true;
    }
  }

  Future<void> _persistToDisk() async {
    final file = _file;
    if (file == null) return;
    try {
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      final jsonStr = jsonEncode(_cache);
      await file.writeAsString(jsonStr, flush: true);
    } catch (e) {
      debugPrint('Error saving storage for $namespace: $e');
    }
  }

  @override
  Future<Result<void, StorageFailure>> setString(String key, String value) async {
    _cache[key] = value;
    await _persistToDisk();
    return Result.ok(null);
  }

  @override
  Future<Result<String?, StorageFailure>> getString(String key) async {
    _loadFromDiskSync();
    final val = _cache[key];
    if (val == null) return Result.ok(null);
    if (val is String) return Result.ok(val);
    return Result.err(StorageFailure(message: 'Value for key "$key" is not a String in $namespace'));
  }

  @override
  Future<Result<void, StorageFailure>> setInt(String key, int value) async {
    _cache[key] = value;
    await _persistToDisk();
    return Result.ok(null);
  }

  @override
  Future<Result<int?, StorageFailure>> getInt(String key) async {
    _loadFromDiskSync();
    final val = _cache[key];
    if (val == null) return Result.ok(null);
    if (val is int) return Result.ok(val);
    return Result.err(StorageFailure(message: 'Value for key "$key" is not an int in $namespace'));
  }

  @override
  Future<Result<void, StorageFailure>> setBool(String key, bool value) async {
    _cache[key] = value;
    await _persistToDisk();
    return Result.ok(null);
  }

  @override
  Future<Result<bool?, StorageFailure>> getBool(String key) async {
    _loadFromDiskSync();
    final val = _cache[key];
    if (val == null) return Result.ok(null);
    if (val is bool) return Result.ok(val);
    return Result.err(StorageFailure(message: 'Value for key "$key" is not a bool in $namespace'));
  }

  @override
  Future<Result<void, StorageFailure>> remove(String key) async {
    _cache.remove(key);
    await _persistToDisk();
    return Result.ok(null);
  }

  @override
  Future<Result<void, StorageFailure>> clear() async {
    _cache.clear();
    await _persistToDisk();
    return Result.ok(null);
  }

  @override
  Future<Result<bool, StorageFailure>> containsKey(String key) async {
    _loadFromDiskSync();
    return Result.ok(_cache.containsKey(key));
  }
}

/// Registry managing persistent KeyValueStores with disk backing.
class PersistentStorageRegistry implements StorageRegistry {
  final Directory? _baseDirectory;
  final Map<String, PersistentKeyValueStore> _stores = {};

  static PersistentStorageRegistry? _defaultInstance;

  PersistentStorageRegistry([this._baseDirectory]);

  /// Returns the singleton default instance (or creates an in-memory fallback if not initialized).
  static PersistentStorageRegistry get defaultInstance {
    return _defaultInstance ??= PersistentStorageRegistry();
  }

  /// Sets or replaces the default instance (useful for tests or custom directories).
  static void setDefaultInstance(PersistentStorageRegistry registry) {
    _defaultInstance = registry;
  }

  /// Asynchronously initializes the persistent storage registry using the application's document directory.
  static Future<PersistentStorageRegistry> initialize({Directory? customDirectory}) async {
    Directory? dir = customDirectory;
    if (dir == null) {
      try {
        final docDir = await getApplicationDocumentsDirectory();
        dir = Directory('${docDir.path}${Platform.pathSeparator}siraj_storage');
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
      } catch (e) {
        debugPrint('PersistentStorageRegistry: path_provider unavailable, falling back to memory: $e');
      }
    }

    final registry = PersistentStorageRegistry(dir);
    _defaultInstance = registry;
    return registry;
  }

  @override
  KeyValueStore getStoreForModule(String moduleNamespace) {
    if (!moduleNamespace.startsWith('mod_') && !moduleNamespace.startsWith('sys_')) {
      throw ArgumentError(
        'Storage boundary violation: Module namespace must begin with "mod_" or "sys_": $moduleNamespace',
      );
    }
    return _stores.putIfAbsent(
      moduleNamespace,
      () => PersistentKeyValueStore(moduleNamespace, _baseDirectory),
    );
  }

  void clearAll() {
    for (final store in _stores.values) {
      store.clear();
    }
    _stores.clear();
  }
}
