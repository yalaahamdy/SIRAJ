import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/market_data_snapshot.dart';
import '../domain/zakat_asset.dart';
import '../domain/zakat_calculation_snapshot.dart';

/// Isolated local-first storage for user Zakat financial assets, snapshots, and preferences in `mod_zakat` (§5, §6).
class ZakatUserDataStore {
  final StorageRegistry _storageRegistry;
  static const String _moduleNamespace = 'mod_zakat';
  static const String _keyAssets = 'zakat_assets';
  static const String _keySnapshots = 'zakat_snapshots';
  static const String _keySelectedPolicy = 'zakat_selected_policy';
  static const String _keyMarketSnapshot = 'zakat_market_snapshot';

  const ZakatUserDataStore({required StorageRegistry storageRegistry})
      : _storageRegistry = storageRegistry;

  Future<Result<void, Failure>> saveAsset(ZakatAsset asset) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final assetsRes = await getAssets();
      if (assetsRes.isFailure) return Result.err(assetsRes.failureOrNull!);

      final assets = List<ZakatAsset>.from(assetsRes.valueOrNull!);
      final idx = assets.indexWhere((a) => a.id == asset.id);
      if (idx >= 0) {
        assets[idx] = asset;
      } else {
        assets.add(asset);
      }

      final saveRes = await store.setString(_keyAssets, jsonEncode(assets.map((a) => a.toMap()).toList()));
      if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save Zakat asset: $e'));
    }
  }

  Future<Result<List<ZakatAsset>, Failure>> getAssets() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyAssets);
      if (res.isFailure) return Result.err(res.failureOrNull!);

      final jsonStr = res.valueOrNull;
      if (jsonStr == null) return Result.ok(const []);

      final rawList = jsonDecode(jsonStr) as List<dynamic>;
      final list = rawList
          .map((m) => ZakatAsset.fromMap(m as Map<String, dynamic>))
          .toList();
      return Result.ok(list);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to get Zakat assets: $e'));
    }
  }

  Future<Result<void, Failure>> deleteAsset(String id) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final assetsRes = await getAssets();
      if (assetsRes.isFailure) return Result.err(assetsRes.failureOrNull!);

      final assets = List<ZakatAsset>.from(assetsRes.valueOrNull!);
      assets.removeWhere((a) => a.id == id);

      final saveRes = await store.setString(_keyAssets, jsonEncode(assets.map((a) => a.toMap()).toList()));
      if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to delete Zakat asset: $e'));
    }
  }

  Future<Result<void, Failure>> saveSnapshot(ZakatCalculationSnapshot snapshot) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final snapsRes = await getSnapshots();
      if (snapsRes.isFailure) return Result.err(snapsRes.failureOrNull!);

      final snapshots = List<ZakatCalculationSnapshot>.from(snapsRes.valueOrNull!);
      snapshots.insert(0, snapshot);

      final saveRes = await store.setString(_keySnapshots, jsonEncode(snapshots.map((s) => s.toMap()).toList()));
      if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save Zakat snapshot: $e'));
    }
  }

  Future<Result<List<ZakatCalculationSnapshot>, Failure>> getSnapshots() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keySnapshots);
      if (res.isFailure) return Result.err(res.failureOrNull!);

      final jsonStr = res.valueOrNull;
      if (jsonStr == null) return Result.ok(const []);

      final rawList = jsonDecode(jsonStr) as List<dynamic>;
      final list = rawList
          .map((m) => ZakatCalculationSnapshot.fromMap(m as Map<String, dynamic>))
          .toList();
      return Result.ok(list);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to get Zakat snapshots: $e'));
    }
  }

  Future<Result<String?, Failure>> getSelectedPolicyId() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keySelectedPolicy);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(res.valueOrNull);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to get selected policy: $e'));
    }
  }

  Future<Result<void, Failure>> setSelectedPolicyId(String policyId) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.setString(_keySelectedPolicy, policyId);
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to set selected policy: $e'));
    }
  }

  Future<Result<MarketDataSnapshot?, Failure>> getMarketSnapshot() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyMarketSnapshot);
      if (res.isFailure) return Result.err(res.failureOrNull!);

      final jsonStr = res.valueOrNull;
      if (jsonStr == null) return Result.ok(null);

      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return Result.ok(MarketDataSnapshot.fromMap(map));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to get market snapshot: $e'));
    }
  }

  Future<Result<void, Failure>> setMarketSnapshot(MarketDataSnapshot snapshot) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.setString(_keyMarketSnapshot, jsonEncode(snapshot.toMap()));
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to set market snapshot: $e'));
    }
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.clear();
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to reset Zakat user data: $e'));
    }
  }
}
