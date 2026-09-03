import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'canonical_quran_package.dart';
import '../domain/quran_tafsir.dart';
import '../domain/quran_translation.dart';

/// Deterministic, offline-first loader for the complete canonical Quran dataset and assets (§8, §9).
class CanonicalQuranLoader {
  CanonicalQuranLoader._();

  static CanonicalQuranPackage? _cachedPackage;
  static final Map<String, Map<String, String>> _cachedTranslationsByLang = {};
  static Map<String, dynamic>? _cachedTajweedRules;
  static Map<String, dynamic>? _cachedAudioManifest;
  static CanonicalTafsirPackage? _cachedTafsirPackage;

  /// Loads the complete 114 Surahs and 6,236 Ayahs package from assets or local filesystem.
  static Future<CanonicalQuranPackage> loadPackage({AssetBundle? bundle}) async {
    if (_cachedPackage != null) return _cachedPackage!;

    String jsonStr;
    try {
      if (bundle != null) {
        jsonStr = await bundle.loadString('assets/quran/quran_canonical_v1.json');
      } else {
        jsonStr = await rootBundle.loadString('assets/quran/quran_canonical_v1.json');
      }
    } catch (_) {
      // Offline fallback for unit tests and local CLI execution
      final file = File('assets/quran/quran_canonical_v1.json');
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      } else {
        rethrow;
      }
    }

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _cachedPackage = CanonicalQuranPackage.fromJson(map);
  }

  /// Synchronously loads the package if running in a command/file environment, or returns cached.
  static CanonicalQuranPackage loadPackageSync() {
    if (_cachedPackage != null) return _cachedPackage!;

    final file = File('assets/quran/quran_canonical_v1.json');
    if (file.existsSync()) {
      final jsonStr = file.readAsStringSync();
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return _cachedPackage = CanonicalQuranPackage.fromJson(map);
    }

    throw StateError('Canonical Quran dataset asset not found at assets/quran/quran_canonical_v1.json');
  }

  /// List of all 11 supported offline translations.
  static List<QuranTranslationInfo> get availableTranslations => kAvailableQuranTranslations;

  static String _resolveTranslationPath(String languageCode) {
    final info = kAvailableQuranTranslations.firstWhere(
      (e) => e.code == languageCode,
      orElse: () => kAvailableQuranTranslations.first,
    );
    return 'assets/quran/translations/${info.fileName}';
  }

  /// Loads translations for a specific language (default: 'en').
  static Future<Map<String, String>> loadTranslations({
    String languageCode = 'en',
    AssetBundle? bundle,
  }) async {
    if (_cachedTranslationsByLang.containsKey(languageCode)) {
      return Map<String, String>.from(_cachedTranslationsByLang[languageCode]!);
    }

    final path = _resolveTranslationPath(languageCode);
    String jsonStr;
    try {
      if (bundle != null) {
        jsonStr = await bundle.loadString(path);
      } else {
        jsonStr = await rootBundle.loadString(path);
      }
    } catch (_) {
      final file = File(path);
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      } else {
        return {};
      }
    }

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = (map['translations'] as List<dynamic>?) ?? [];
    final translationMap = <String, String>{};
    for (final item in list) {
      final s = item['surah_number'];
      final a = item['ayah_number'];
      final t = item['translation_text'] as String? ?? '';
      translationMap['$s:$a'] = t;
    }

    _cachedTranslationsByLang[languageCode] = translationMap;
    return translationMap;
  }

  /// Synchronously loads translations if running in test/file environment.
  static Map<String, String> loadTranslationsSync({String languageCode = 'en'}) {
    if (_cachedTranslationsByLang.containsKey(languageCode)) {
      return Map<String, String>.from(_cachedTranslationsByLang[languageCode]!);
    }

    final path = _resolveTranslationPath(languageCode);
    final file = File(path);
    if (!file.existsSync()) return {};

    final jsonStr = file.readAsStringSync();
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = (map['translations'] as List<dynamic>?) ?? [];
    final translationMap = <String, String>{};
    for (final item in list) {
      final s = item['surah_number'];
      final a = item['ayah_number'];
      final t = item['translation_text'] as String? ?? '';
      translationMap['$s:$a'] = t;
    }

    _cachedTranslationsByLang[languageCode] = translationMap;
    return translationMap;
  }

  /// Loads Tajweed rules offsets.
  static Future<Map<String, dynamic>> loadTajweedRules({AssetBundle? bundle}) async {
    if (_cachedTajweedRules != null) return _cachedTajweedRules!;

    String jsonStr;
    try {
      if (bundle != null) {
        jsonStr = await bundle.loadString('assets/quran/tajweed/tajweed_rules_v1.json');
      } else {
        jsonStr = await rootBundle.loadString('assets/quran/tajweed/tajweed_rules_v1.json');
      }
    } catch (_) {
      final file = File('assets/quran/tajweed/tajweed_rules_v1.json');
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      } else {
        return {};
      }
    }

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _cachedTajweedRules = (map['rules'] as Map<String, dynamic>?) ?? {};
  }

  /// Synchronously loads Tajweed rules if file exists.
  static Map<String, dynamic> loadTajweedRulesSync() {
    if (_cachedTajweedRules != null) return _cachedTajweedRules!;

    final file = File('assets/quran/tajweed/tajweed_rules_v1.json');
    if (!file.existsSync()) return {};

    final jsonStr = file.readAsStringSync();
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _cachedTajweedRules = (map['rules'] as Map<String, dynamic>?) ?? {};
  }

  /// Loads Audio Manifest mapping.
  static Future<Map<String, dynamic>> loadAudioManifest({AssetBundle? bundle}) async {
    if (_cachedAudioManifest != null) return _cachedAudioManifest!;

    String jsonStr;
    try {
      if (bundle != null) {
        jsonStr = await bundle.loadString('assets/quran/audio/audio_manifest_v1.json');
      } else {
        jsonStr = await rootBundle.loadString('assets/quran/audio/audio_manifest_v1.json');
      }
    } catch (_) {
      final file = File('assets/quran/audio/audio_manifest_v1.json');
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      } else {
        return {};
      }
    }

    return _cachedAudioManifest = jsonDecode(jsonStr) as Map<String, dynamic>;
  }

  /// Loads authentic, peer-reviewed Tafsir package (Al-Tafsir Al-Muyassar).
  static Future<CanonicalTafsirPackage> loadTafsir({AssetBundle? bundle}) async {
    if (_cachedTafsirPackage != null) return _cachedTafsirPackage!;

    String jsonStr;
    try {
      if (bundle != null) {
        jsonStr = await bundle.loadString('assets/quran/tafsir/ar_muyassar_v1.json');
      } else {
        jsonStr = await rootBundle.loadString('assets/quran/tafsir/ar_muyassar_v1.json');
      }
    } catch (_) {
      final file = File('assets/quran/tafsir/ar_muyassar_v1.json');
      if (file.existsSync()) {
        jsonStr = await file.readAsString();
      } else {
        rethrow;
      }
    }

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _cachedTafsirPackage = CanonicalTafsirPackage.fromJson(map);
  }

  /// Synchronously loads Tafsir package if cached or from file.
  static CanonicalTafsirPackage loadTafsirSync() {
    if (_cachedTafsirPackage != null) return _cachedTafsirPackage!;

    final file = File('assets/quran/tafsir/ar_muyassar_v1.json');
    if (file.existsSync()) {
      final jsonStr = file.readAsStringSync();
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return _cachedTafsirPackage = CanonicalTafsirPackage.fromJson(map);
    }

    throw StateError('Canonical Tafsir dataset asset not found or not preloaded.');
  }

  /// Clear caches if needed
  static void clearCache() {
    _cachedPackage = null;
    _cachedTranslationsByLang.clear();
    _cachedTajweedRules = null;
    _cachedAudioManifest = null;
    _cachedTafsirPackage = null;
  }
}
