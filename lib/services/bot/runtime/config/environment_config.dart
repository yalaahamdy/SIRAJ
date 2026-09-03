/// Supported deployment environments for the SIRAJ Bot Platform (§1, §3).
enum EnvironmentType {
  local,
  development,
  test,
  staging,
  production;

  bool get isProduction => this == EnvironmentType.production;
  bool get isStaging => this == EnvironmentType.staging;
  bool get isTest => this == EnvironmentType.test;
}

class DatabaseConfig {
  final String driver;
  final String host;
  final int port;
  final String database;

  const DatabaseConfig({
    this.driver = 'memory',
    this.host = '127.0.0.1',
    this.port = 5432,
    this.database = 'siraj_bot_sandbox',
  });
}

class RedisConfig {
  final bool enabled;
  final String host;
  final int port;

  const RedisConfig({
    this.enabled = false,
    this.host = '127.0.0.1',
    this.port = 6379,
  });
}

class ChannelConfig {
  final bool telegramEnabled;
  final bool whatsappEnabled;
  final bool webChatEnabled;
  final bool apiEnabled;

  const ChannelConfig({
    this.telegramEnabled = true,
    this.whatsappEnabled = true,
    this.webChatEnabled = true,
    this.apiEnabled = true,
  });
}

class LLMConfig {
  final String provider; // 'mock' | 'local' | 'disabled'
  final int maxTokens;
  final bool strictGrounding;

  const LLMConfig({
    this.provider = 'mock',
    this.maxTokens = 1000,
    this.strictGrounding = true,
  });
}

class SecurityConfig {
  final String webhookSecret;
  final String telegramSecretToken;
  final String whatsappAppSecret;
  final int maxPayloadSizeBytes;
  final int userRateLimitRpm;
  final int channelRateLimitRpm;

  const SecurityConfig({
    this.webhookSecret = 'siraj_test_sandbox_webhook_secret_key',
    this.telegramSecretToken = 'siraj_test_telegram_sandbox_token',
    this.whatsappAppSecret = 'siraj_test_whatsapp_sandbox_secret',
    this.maxPayloadSizeBytes = 2 * 1024 * 1024,
    this.userRateLimitRpm = 30,
    this.channelRateLimitRpm = 300,
  });
}

class FeatureFlags {
  final bool enableAccountLinking;
  final bool enableDeterministicFallback;
  final bool enableQueueProcessing;

  const FeatureFlags({
    this.enableAccountLinking = true,
    this.enableDeterministicFallback = true,
    this.enableQueueProcessing = true,
  });
}

class LoggingConfig {
  final String logLevel;
  final bool enableRedaction;

  const LoggingConfig({
    this.logLevel = 'info',
    this.enableRedaction = true,
  });
}

/// Comprehensive, typed environment configuration container (§3, §4).
class EnvironmentConfig {
  final EnvironmentType environment;
  final String apiBaseUrl;
  final DatabaseConfig databaseConfig;
  final RedisConfig redisConfig;
  final ChannelConfig channelConfig;
  final LLMConfig llmConfig;
  final SecurityConfig securityConfig;
  final FeatureFlags featureFlags;
  final LoggingConfig loggingConfig;

  const EnvironmentConfig({
    this.environment = EnvironmentType.local,
    this.apiBaseUrl = 'http://127.0.0.1:8080',
    this.databaseConfig = const DatabaseConfig(),
    this.redisConfig = const RedisConfig(),
    this.channelConfig = const ChannelConfig(),
    this.llmConfig = const LLMConfig(),
    this.securityConfig = const SecurityConfig(),
    this.featureFlags = const FeatureFlags(),
    this.loggingConfig = const LoggingConfig(),
  });

  /// Validates configuration and fails fast if requirements are violated (§4).
  void validateAndFailFast() {
    if (environment.isProduction) {
      if (securityConfig.webhookSecret == 'siraj_test_sandbox_webhook_secret_key') {
        throw StateError('Production startup blocked: Insecure default webhook secret detected.');
      }
      if (llmConfig.provider != 'mock' && llmConfig.provider != 'local') {
        throw StateError('Production startup blocked: External cloud LLM provider is currently disabled by governance.');
      }
    }
  }

  factory EnvironmentConfig.localSandbox() {
    return const EnvironmentConfig(
      environment: EnvironmentType.local,
    );
  }

  factory EnvironmentConfig.test() {
    return const EnvironmentConfig(
      environment: EnvironmentType.test,
    );
  }
}
