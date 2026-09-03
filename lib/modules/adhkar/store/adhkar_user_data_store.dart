import 'dart:convert';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/storage/storage_contract.dart';
import '../domain/dhikr_favorite.dart';
import '../domain/dhikr_user_progress.dart';

/// Isolated local-first storage for user Adhkar progress and favorites in `mod_adhkar` (§19, §21, §24).
class AdhkarUserDataStore {
  final StorageRegistry _storageRegistry;
  static const String _moduleNamespace = 'mod_adhkar';
  static const String _keyProgressPrefix = 'adhkar_progress_';
  static const String _keyFavorites = 'adhkar_favorites';

  const AdhkarUserDataStore({required StorageRegistry storageRegistry})
      : _storageRegistry = storageRegistry;

  Future<Result<void, Failure>> saveProgress(DhikrUserProgress progress) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final key = '$_keyProgressPrefix${progress.dateKey}_${progress.contentId}';
      final res = await store.setString(key, jsonEncode(progress.toMap()));
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to save Dhikr progress: $e'));
    }
  }

  Future<Result<DhikrUserProgress?, Failure>> getProgress({
    required String contentId,
    required String dateKey,
  }) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final key = '$_keyProgressPrefix${dateKey}_$contentId';
      final res = await store.getString(key);
      if (res.isFailure) return Result.err(res.failureOrNull!);

      final jsonStr = res.valueOrNull;
      if (jsonStr == null) return Result.ok(null);

      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        return Result.ok(DhikrUserProgress.fromMap(map));
      } catch (_) {
        return Result.ok(null);
      }
    } catch (e) {
      return Result.ok(null);
    }
  }

  Future<Result<List<DhikrFavorite>, Failure>> getFavorites() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.getString(_keyFavorites);
      if (res.isFailure) return Result.err(res.failureOrNull!);

      final jsonStr = res.valueOrNull;
      if (jsonStr == null) return Result.ok(const []);

      try {
        final rawList = jsonDecode(jsonStr) as List<dynamic>;
        final list = rawList
            .whereType<Map<String, dynamic>>()
            .map((m) => DhikrFavorite.fromMap(m))
            .toList();
        return Result.ok(List.unmodifiable(list));
      } catch (_) {
        return Result.ok(const []);
      }
    } catch (e) {
      return Result.ok(const []);
    }
  }

  Future<Result<bool, Failure>> toggleFavorite({
    required String contentId,
    required DateTime now,
  }) async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final favsRes = await getFavorites();
      if (favsRes.isFailure) return Result.err(favsRes.failureOrNull!);

      final favs = List<DhikrFavorite>.from(favsRes.valueOrNull!);
      final existingIndex = favs.indexWhere((f) => f.contentId == contentId);
      final isNowFavorite = existingIndex == -1;

      if (isNowFavorite) {
        favs.add(DhikrFavorite(contentId: contentId, addedAt: now));
      } else {
        favs.removeAt(existingIndex);
      }

      final saveRes = await store.setString(_keyFavorites, jsonEncode(favs.map((f) => f.toMap()).toList()));
      if (saveRes.isFailure) return Result.err(saveRes.failureOrNull!);
      return Result.ok(isNowFavorite);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to toggle favorite: $e'));
    }
  }

  Future<Result<bool, Failure>> isFavorite(String contentId) async {
    try {
      final favsRes = await getFavorites();
      if (favsRes.isFailure) return Result.err(favsRes.failureOrNull!);
      return Result.ok(favsRes.valueOrNull!.any((f) => f.contentId == contentId));
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to check favorite: $e'));
    }
  }

  Future<Result<void, Failure>> resetAllUserData() async {
    try {
      final store = _storageRegistry.getStoreForModule(_moduleNamespace);
      final res = await store.clear();
      if (res.isFailure) return Result.err(res.failureOrNull!);
      return Result.ok(null);
    } catch (e) {
      return Result.err(StorageFailure(message: 'Failed to reset Adhkar user data: $e'));
    }
  }
}
