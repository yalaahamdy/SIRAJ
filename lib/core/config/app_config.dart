import 'package:equatable/equatable.dart';
import 'feature_flags.dart';

enum Environment {
  development,
  staging,
  production,
  test,
}

/// Central application configuration contract.
class AppConfig extends Equatable {
  final String appName;
  final String appVersion;
  final Environment environment;
  final FeatureFlags flags;
  final String defaultLocale;
  final bool failClosedOnContentError;

  const AppConfig({
    required this.appName,
    required this.appVersion,
    required this.environment,
    required this.flags,
    this.defaultLocale = 'ar',
    this.failClosedOnContentError = true,
  });

  /// Factory for Phase 1 development environment
  factory AppConfig.development() {
    return const AppConfig(
      appName: 'SIRAJ (Dev)',
      appVersion: '1.0.0-dev',
      environment: Environment.development,
      flags: FeatureFlags.foundationDefaults,
      defaultLocale: 'ar',
      failClosedOnContentError: true,
    );
  }

  /// Factory for test environments
  factory AppConfig.test({FeatureFlags? flags}) {
    return AppConfig(
      appName: 'SIRAJ (Test)',
      appVersion: '1.0.0-test',
      environment: Environment.test,
      flags: flags ?? FeatureFlags.foundationDefaults,
      defaultLocale: 'ar',
      failClosedOnContentError: true,
    );
  }

  /// Factory for production environment
  factory AppConfig.production({FeatureFlags? flags}) {
    return AppConfig(
      appName: 'SIRAJ',
      appVersion: '1.0.0',
      environment: Environment.production,
      flags: flags ?? FeatureFlags.foundationDefaults,
      defaultLocale: 'ar',
      failClosedOnContentError: true,
    );
  }

  @override
  List<Object?> get props => [
        appName,
        appVersion,
        environment,
        flags,
        defaultLocale,
        failClosedOnContentError,
      ];
}
