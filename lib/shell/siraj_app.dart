import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/config/app_config.dart';
import '../core/i18n/locale_manager.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';
import 'theme/app_theme_controller.dart';
import 'widgets/error_boundary.dart';

/// Root Widget for the SIRAJ application with dynamic ThemeMode support.
class SirajApp extends StatelessWidget {
  final AppConfig config;
  final LocaleManager localeManager;
  final AppThemeController? themeController;

  const SirajApp({
    super.key,
    required this.config,
    required this.localeManager,
    this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveController = themeController ?? AppThemeController.instance;

    return AppErrorBoundary(
      child: ListenableBuilder(
        listenable: effectiveController,
        builder: (context, _) {
          return MaterialApp(
            title: config.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: effectiveController.themeMode,
            locale: localeManager.currentLocale,
            supportedLocales: LocaleManager.supportedLocales,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: AppRouter.home,
            onGenerateRoute: AppRouter.generateRoute,
            builder: (context, child) {
              return Directionality(
                textDirection: localeManager.textDirection,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
