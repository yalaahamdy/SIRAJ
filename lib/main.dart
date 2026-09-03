import 'package:flutter/material.dart';
import 'core/config/app_config.dart';
import 'core/i18n/locale_manager.dart';
import 'modules/quran/store/canonical_quran_loader.dart';
import 'shell/siraj_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-load the verified canonical Quran dataset (114 Surahs, 6,236 Ayahs) from assets
  await CanonicalQuranLoader.loadPackage();
  await CanonicalQuranLoader.loadTafsir();

  final config = AppConfig.development();
  final localeManager = LocaleManager();

  runApp(
    SirajApp(
      config: config,
      localeManager: localeManager,
    ),
  );
}
