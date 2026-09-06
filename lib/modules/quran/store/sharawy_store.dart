import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/sharawy_item.dart';

/// Store managing loading, filtering, persistence, and querying of Sheikh El-Sharawy's
/// Quran Tafsir Khawatir archive (§14, §20).
class SharawyStore {
  static const String assetPath = 'assets/quran/audio/sharawy_collection.json';

  static const String _customItemsFile = 'sharawy_custom_items.json';
  static const String _localPathsFile = 'sharawy_local_paths.json';
  static const String _favoritesFile = 'sharawy_favorites.json';

  final List<SharawyItem> _items = [];
  final Set<String> _favoriteIds = {};
  bool _isLoaded = false;

  List<SharawyItem> get allItems => List.unmodifiable(_items);
  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);
  bool get isLoaded => _isLoaded;

  /// Loads items from asset JSON or accepts custom pre-parsed items (useful for tests).
  Future<void> load({String? customJson, List<SharawyItem>? initialItems}) async {
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
          _items.add(SharawyItem.fromJson(obj));
        }
      }
      _isLoaded = true;
    } catch (_) {
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
      final file = File('${docDir.path}${Platform.pathSeparator}$_favoritesFile');
      await file.writeAsString(json.encode(_favoriteIds.toList()));
    } catch (_) {}
  }

  Future<void> _loadPersistedFavorites() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final file = File('${docDir.path}${Platform.pathSeparator}$_favoritesFile');
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
            final item = SharawyItem.fromJson(itemJson);
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

  /// Updates local file path for an item once downloaded and persists mapping.
  void updateLocalPath(String id, String path) {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(localFilePath: path);
      _persistLocalPaths();
    }
  }

  /// Adds a custom imported item and saves to custom items file.
  void addCustomItem(SharawyItem item) {
    final existingIdx = _items.indexWhere((it) => it.id == item.id);
    if (existingIdx != -1) {
      _items[existingIdx] = item;
    } else {
      _items.add(item);
    }
    _persistCustomItems();
  }

  /// Removes a custom imported item and deletes its file if present.
  Future<void> removeCustomItem(String id) async {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx != -1) {
      final item = _items[idx];
      if (item.localFilePath != null && File(item.localFilePath!).existsSync()) {
        try {
          await File(item.localFilePath!).delete();
        } catch (_) {}
      }
      _items.removeAt(idx);
      _favoriteIds.remove(id);
      await _persistCustomItems();
      await _persistFavorites();
    }
  }

  /// Deletes a downloaded local file and resets the item's local path.
  Future<void> deleteLocalFile(String id) async {
    final idx = _items.indexWhere((it) => it.id == id);
    if (idx != -1) {
      final item = _items[idx];
      if (item.localFilePath != null && File(item.localFilePath!).existsSync()) {
        try {
          await File(item.localFilePath!).delete();
        } catch (_) {}
      }
      _items[idx] = _items[idx].copyWith(localFilePath: null);
      await _persistLocalPaths();
    }
  }

  /// Returns unique list of categories and Surah names for chip filters.
  List<String> getSurahs() {
    final surahs = <String>['الكل', 'المفضلة', 'التنزيلات'];
    final seen = <String>{};
    for (final item in _items) {
      if (item.isCustomLocal) continue;
      if (item.surahName.isNotEmpty && !seen.contains(item.surahName)) {
        seen.add(item.surahName);
        surahs.add(item.surahName);
      }
    }
    return surahs;
  }

  /// Filters items by surah category and text query.
  List<SharawyItem> filter({String surah = 'الكل', String query = ''}) {
    return _items.where((item) {
      if (surah == 'المفضلة') {
        if (!_favoriteIds.contains(item.id)) return false;
      } else if (surah == 'التنزيلات') {
        if (!item.isOfflineAvailable && !item.isCustomLocal) return false;
      } else if (surah != 'الكل') {
        if (item.surahName != surah) return false;
      }

      if (query.trim().isNotEmpty) {
        final q = query.trim().toLowerCase();
        final matchTitle = item.cleanTitle.toLowerCase().contains(q);
        final matchSurah = item.surahName.toLowerCase().contains(q);
        final matchRange = item.verseRange.toLowerCase().contains(q);
        if (!matchTitle && !matchSurah && !matchRange) return false;
      }

      return true;
    }).toList();
  }

  static const List<SharawyItem> _fallbackSeedItems = [
    SharawyItem(
      id: 'sharawy_0001',
      cleanTitle: 'مقدمات التفسير - الدرس 1',
      fullTitle: 'مقدمات التفسير - الدرس 1',
      surahNumber: 0,
      surahName: 'المقدمات',
      verseRange: 'الدرس 1',
      scholar: 'الشيخ محمد متولي الشعراوي',
      duration: '40:40',
      durationSeconds: 2440.73,
      url: 'https://archive.org/download/Khwater.El-Sharawy.Fi.Tafsir.EL-Quran-Karim-Up_ReDa_MoHamMeD/000_Intro1.mp3',
      filename: '000_Intro1.mp3',
      sizeBytes: 7322200,
    ),
    SharawyItem(
      id: 'sharawy_0005',
      cleanTitle: 'سورة الفاتحة - الآية 1',
      fullTitle: 'سورة الفاتحة - الآية 1',
      surahNumber: 1,
      surahName: 'الفاتحة',
      verseRange: 'الآية 1',
      scholar: 'الشيخ محمد متولي الشعراوي',
      duration: '20:25',
      durationSeconds: 1225.31,
      url: 'https://archive.org/download/Khwater.El-Sharawy.Fi.Tafsir.EL-Quran-Karim-Up_ReDa_MoHamMeD/001_Al-Fatihah_001.mp3',
      filename: '001_Al-Fatihah_001.mp3',
      sizeBytes: 3675932,
    ),
  ];
}
