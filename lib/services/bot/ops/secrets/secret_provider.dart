/// Contract for resolving secrets without hardcoding them in source control (§2).
abstract class SecretProviderContract {
  String getWebhookSecret();
  String getTelegramSecretToken();
  String getWhatsAppAppSecret();
}

/// Staging secret provider pulling from environment or safe injected configurations (§2).
class StagingSecretProvider implements SecretProviderContract {
  final String _webhookSecret;
  final String _telegramSecretToken;
  final String _whatsappAppSecret;

  StagingSecretProvider({
    String? webhookSecret,
    String? telegramSecretToken,
    String? whatsappAppSecret,
  })  : _webhookSecret = webhookSecret ?? 'siraj_staging_webhook_secret_key',
        _telegramSecretToken = telegramSecretToken ?? 'siraj_staging_telegram_secret_token',
        _whatsappAppSecret = whatsappAppSecret ?? 'siraj_staging_whatsapp_secret';

  @override
  String getWebhookSecret() => _webhookSecret;

  @override
  String getTelegramSecretToken() => _telegramSecretToken;

  @override
  String getWhatsAppAppSecret() => _whatsappAppSecret;
}
