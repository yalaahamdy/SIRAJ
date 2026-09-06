import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/tawasheeh_item.dart';

/// Store managing loading, filtering, favorites, and querying of historic Tawasheeh items (§14, §20).
class TawasheehStore {
  static const String assetPath = 'assets/quran/audio/tawasheeh_collection.json';

  static const String _customItemsFile = 'tawasheeh_custom_items.json';
  static const String _localPathsFile = 'tawasheeh_local_paths.json';

  final List<TawasheehItem> _items = [];
  final Set<String> _favoriteIds = {};
  bool _isLoaded = false;

  List<TawasheehItem> get allItems => List.unmodifiable(_items);
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  bool get isLoaded => _isLoaded;

  /// Loads items from asset JSON or accepts custom pre-parsed items (useful for tests).
  Future<void> load({String? customJson, List<TawasheehItem>? initialItems}) async {
    if (_isLoaded && initialItems == null && customJson == null) return;

    if (initialItems != null) {
      _items.clear();
      _items.addAll(initialItems);
      _isLoaded = true;
      return;
    }

    try {
      final jsonStr = customJson ?? await rootBundle.loadString(assetPath);
      final List<dynamic> decoded = json.decode(jsonStr) as List<dynamic>;
      _items.clear();
      for (final obj in decoded) {
        if (obj is Map<String, dynamic>) {
          _items.add(TawasheehItem.fromJson(obj));
        }
      }
      _isLoaded = true;
    } catch (_) {
      // Safe fallback if asset is unavailable in test environment
      if (_items.isEmpty) {
        _items.addAll(_fallbackSeedItems);
      }
      _isLoaded = true;
    }
    await _loadPersistedFavorites();
    await _loadPersistedCustomItems();
    await _loadPersistedLocalPaths();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  /// Toggles favorite status for a given recording and saves to local disk.
  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    await _persistFavorites();
  }

  Future<void> _persistFavorites() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}${Platform.pathSeparator}tawasheeh_favorites.json');
      await file.writeAsString(json.encode(_favoriteIds.toList()));
    } catch (_) {}
  }

  Future<void> _loadPersistedFavorites() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}${Platform.pathSeparator}tawasheeh_favorites.json');
      if (file.existsSync()) {
        final decoded = json.decode(await file.readAsString()) as List<dynamic>;
        _favoriteIds.clear();
        for (final item in decoded) {
          if (item is String) _favoriteIds.add(item);
        }
      }
    } catch (_) {}
  }

  Future<void> _persistCustomItems() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}${Platform.pathSeparator}$_customItemsFile');
      final customs = _items.where((it) => it.isCustomLocal).map((it) => it.toJson()).toList();
      await file.writeAsString(json.encode(customs));
    } catch (_) {}
  }

  Future<void> _loadPersistedCustomItems() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}${Platform.pathSeparator}$_customItemsFile');
      if (file.existsSync()) {
        final decoded = json.decode(await file.readAsString()) as List<dynamic>;
        for (final itemJson in decoded) {
          if (itemJson is Map<String, dynamic>) {
            final item = TawasheehItem.fromJson(itemJson);
            // Verify file still exists if localFilePath is set
            if (item.localFilePath != null && item.localFilePath!.isNotEmpty) {
              if (File(item.localFilePath!).existsSync()) {
                if (!_items.any((existing) => existing.id == item.id)) {
                  _items.add(item);
                }
              }
            }
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _persistLocalPaths() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}${Platform.pathSeparator}$_localPathsFile');
      final pathMap = <String, String>{};
      for (final it in _items) {
        if (!it.isCustomLocal && it.localFilePath != null && it.localFilePath!.isNotEmpty) {
          pathMap[it.id] = it.localFilePath!;
        }
      }
      await file.writeAsString(json.encode(pathMap));
    } catch (_) {}
  }

  Future<void> _loadPersistedLocalPaths() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}${Platform.pathSeparator}$_localPathsFile');
      if (file.existsSync()) {
        final decoded = json.decode(await file.readAsString()) as Map<String, dynamic>;
        for (final entry in decoded.entries) {
          final idx = _items.indexWhere((it) => it.id == entry.key);
          if (idx != -1 && File(entry.value.toString()).existsSync()) {
            _items[idx] = _items[idx].copyWith(localFilePath: entry.value.toString());
          }
        }
      }
    } catch (_) {}
  }

  /// Filters items by search query, reciter name, and favorite status.
  List<TawasheehItem> filter({
    String? query,
    String? reciter,
    bool onlyFavorites = false,
    bool onlyDownloads = false,
  }) {
    return _items.where((item) {
      if (onlyFavorites || reciter == 'المفضلة') {
        if (!_favoriteIds.contains(item.id)) return false;
      }

      if (onlyDownloads || reciter == 'التنزيلات') {
        if (!item.isCustomLocal && !item.isOfflineAvailable) return false;
      }

      final matchesReciter = reciter == null ||
          reciter.isEmpty ||
          reciter == 'الكل' ||
          reciter == 'المفضلة' ||
          reciter == 'التنزيلات' ||
          item.reciter == reciter;

      final q = (query ?? '').trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.cleanTitle.toLowerCase().contains(q) ||
          item.reciter.toLowerCase().contains(q);

      return matchesReciter && matchesQuery;
    }).toList();
  }

  /// Returns unique sorted list of all available reciter names, with favorites and downloads if any.
  List<String> getReciters() {
    final set = <String>{};
    for (final item in _items) {
      if (item.reciter.isNotEmpty) {
        set.add(item.reciter);
      }
    }
    final list = set.toList();
    list.sort();
    final hasDownloads = _items.any((it) => it.isCustomLocal || it.isOfflineAvailable);
    return [
      'الكل',
      if (_favoriteIds.isNotEmpty) 'المفضلة',
      if (hasDownloads) 'التنزيلات',
      ...list,
    ];
  }

  TawasheehItem? getById(String id) {
    try {
      return _items.firstWhere((it) => it.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Updates local file path for a specific Tawasheeh item.
  void updateLocalPath(String id, String localPath) {
    final index = _items.indexWhere((it) => it.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(localFilePath: localPath);
      _persistLocalPaths();
    }
  }

  /// Appends custom user-imported recordings to the store and persists them.
  Future<void> addCustomItems(List<TawasheehItem> newItems) async {
    for (final it in newItems) {
      final exists = _items.any((existing) => existing.id == it.id || (existing.localFilePath != null && existing.localFilePath == it.localFilePath));
      if (!exists) {
        _items.add(it);
      }
    }
    await _persistCustomItems();
  }

  /// Removes a custom imported recording from the store and storage.
  Future<void> removeCustomItem(String id) async {
    final index = _items.indexWhere((it) => it.id == id);
    if (index != -1) {
      final item = _items[index];
      if (item.localFilePath != null && item.localFilePath!.isNotEmpty) {
        try {
          final file = File(item.localFilePath!);
          if (file.existsSync()) {
            await file.delete();
          }
        } catch (_) {}
      }
      _items.removeAt(index);
      await _persistCustomItems();
    }
  }

  /// Resets all local file associations in the store.
  Future<void> clearLocalPaths() async {
    for (int i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(localFilePath: '');
    }
    _items.removeWhere((it) => it.isCustomLocal);
    await _persistCustomItems();
    await _persistLocalPaths();
  }

  static const List<TawasheehItem> _fallbackSeedItems = [
    TawasheehItem(
      id: 'tawasheeh_001',
      cleanTitle: 'ابتهال: إلهى . إن يكن ذنبى عظيما',
      fullTitle: 'إبتهال 270214 // إلهى . إن يكن ذنبى عظيما // محمد عمران',
      reciter: 'محمد عمران',
      duration: '03:59',
      durationSeconds: 239.39,
      url: 'https://archive.org/download/2071215/01%20-%20%D8%A5%D8%A8%D8%AA%D9%87%D8%A7%D9%84%20270214%20--%20%D8%A5%D9%84%D9%87%D9%89%20.%20%D8%A5%D9%86%20%D9%8A%D9%83%D9%86%20%D8%B0%D9%86%D8%A8%D9%89%20%D8%B9%D8%B8%D9%8A%D9%85%D8%A7%20--%20%D9%85%D8%AD%D9%85%D8%AF%20%D8%B9%D9%85%D8%B1%D8%A7%D9%86.mp3',
    ),
    TawasheehItem(
      id: 'tawasheeh_004',
      cleanTitle: 'يا رب ساعدنا واهدينا',
      fullTitle: 'يا رب ساعدنا واهدينا - الشيخ كامل يوسف البهتيمي',
      reciter: 'كامل يوسف البهتيمي',
      duration: '02:59',
      durationSeconds: 179.83,
      url: 'https://archive.org/download/2071215/01%20-%20%D9%8A%D8%A7%20%D8%B1%D8%A8%20%D8%B3%D8%A7%D8%B9%D8%AF%D9%86%D8%A7%20%D9%88%D8%A7%D9%87%D8%AF%D9%8A%D9%86%D8%A7%20-%20%D8%A7%D9%84%D8%B4%D9%8A%D8%AE%20%D9%83%D8%A7%D9%85%D9%84%20%D9%8A%D9%88%D8%B3%D9%81%20%D8%A7%D9%84%D8%A8%D9%87%D8%AA%D9%8A%D9%85%D9%8A.mp3',
    ),
    TawasheehItem(
      id: 'tawasheeh_013',
      cleanTitle: 'ابتهال: تسبح لك الأرض',
      fullTitle: 'إبتهال // م. تسبح لك الأرض // نصرالدين طوبار',
      reciter: 'نصر الدين طوبار',
      duration: '01:57',
      durationSeconds: 117.17,
      url: 'https://archive.org/download/2071215/04%20-%20%D8%A5%D8%A8%D8%AA%D9%87%D8%A7%D9%84%20--%20%D9%85.%20%D8%AA%D8%B3%D8%A8%D8%AD%20%D9%84%D9%83%20%D8%A7%D9%84%D8%A3%D8%B1%D8%B6%20--%20%D9%86%D8%B5%D8%B1%D8%A7%D9%84%D8%AF%D9%8A%D9%86%20%D8%B7%D9%88%D8%A8%D8%A7%D8%B1.mp3',
    ),
  ];
}
