import 'package:flutter/material.dart';
import '../../core/storage/storage_contract.dart';

/// متحكم سمة ومظهر التطبيق (فاتح / داكن / تلقائي بحسب النظام) مع حفظ التفضيل محلياً
class AppThemeController extends ChangeNotifier {
  static const String _storageKey = 'app_theme_mode';
  static final AppThemeController instance = AppThemeController._internal();

  KeyValueStore? _store;
  ThemeMode _themeMode = ThemeMode.system;

  AppThemeController._internal();

  factory AppThemeController({StorageRegistry? storageRegistry}) {
    if (storageRegistry != null && instance._store == null) {
      instance.init(storageRegistry);
    }
    return instance;
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> init(StorageRegistry storageRegistry) async {
    _store = storageRegistry.getStoreForModule('mod_system_settings');
    if (_store != null) {
      try {
        final res = await _store!.getString(_storageKey);
        if (res.isSuccess && res.valueOrNull != null) {
          final savedName = res.valueOrNull!;
          _themeMode = ThemeMode.values.firstWhere(
            (m) => m.name == savedName,
            orElse: () => ThemeMode.system,
          );
          notifyListeners();
        }
      } catch (_) {}
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    if (_store != null) {
      try {
        await _store!.setString(_storageKey, mode.name);
      } catch (_) {}
    }
  }

  static String getLabelArabic(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'الوضع الفاتح';
      case ThemeMode.dark:
        return 'الوضع الداكن';
      case ThemeMode.system:
        return 'تلقائي (حسب النظام)';
    }
  }

  static IconData getIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.wb_sunny_rounded;
      case ThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ThemeMode.system:
        return Icons.settings_brightness_rounded;
    }
  }
}
