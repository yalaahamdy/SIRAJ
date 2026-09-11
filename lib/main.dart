import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/config/app_config.dart';
import 'core/i18n/locale_manager.dart';
import 'core/storage/persistent_storage.dart';
import 'modules/quran/store/canonical_quran_loader.dart';
import 'shell/siraj_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent local-first storage engine
  await PersistentStorageRegistry.initialize();

  // Pre-load the verified canonical Quran dataset (114 Surahs, 6,236 Ayahs) from assets
  await CanonicalQuranLoader.loadPackage();

  final config = kReleaseMode ? AppConfig.production() : AppConfig.development();
  final localeManager = LocaleManager();

  runApp(
    SirajApp(
      config: config,
      localeManager: localeManager,
    ),
  );
}
