import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../adapters/api_adapter.dart';
import '../adapters/channel_adapter_contract.dart';
import '../adapters/telegram_adapter.dart';
import '../adapters/webchat_adapter.dart';
import '../adapters/whatsapp_adapter.dart';
import '../domain/bot_error.dart';
import '../domain/unified_message.dart';
import 'bot_quota_service.dart';

/// Central Gateway handling authentication, webhook signatures, idempotency, and rate limits (§7, §45, §56, §57).
class BotGateway {
  final Map<ChannelType, ChannelAdapterContract> _adapters;
  final BotQuotaService _quotaService;
  final Set<String> _processedMessageIds = {};
  final String _webhookSecret;
  final int maxPayloadSizeBytes;

  BotGateway({
    Map<ChannelType, ChannelAdapterContract>? adapters,
    BotQuotaService? quotaService,
    String webhookSecret = 'siraj_default_webhook_secret_key',
    this.maxPayloadSizeBytes = 2 * 1024 * 1024, // 2MB
  })  : _adapters = adapters ??
            {
              ChannelType.telegram: const TelegramAdapter(),
              ChannelType.whatsapp: const WhatsAppAdapter(),
              ChannelType.webChat: const WebChatAdapter(),
              ChannelType.api: const APIAdapter(),
            },
        _quotaService = quotaService ?? BotQuotaService(),
        _webhookSecret = webhookSecret;

  BotQuotaService get quotaService => _quotaService;

  /// Verifies HMAC-SHA256 signature for incoming webhooks (§56).
  bool verifyWebhookSignature(String rawBody, String signature) {
    if (signature.isEmpty || rawBody.isEmpty) return false;
    final key = utf8.encode(_webhookSecret);
    final bytes = utf8.encode(rawBody);
    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);
    return digest.toString() == signature;
  }

  /// Validates timestamp drift to prevent replay attacks and future skew (§56).
  bool isTimestampValid(DateTime timestamp, {Duration maxDrift = const Duration(minutes: 5)}) {
    final now = DateTime.now().toUtc();
    final difference = (now.difference(timestamp)).abs();
    return difference <= maxDrift;
  }

  /// Processes and normalizes an incoming request safely (§7, §57).
  UnifiedIncomingMessage processInbound({
    required ChannelType channel,
    required Map<String, dynamic> rawPayload,
    String? rawBodyForSignature,
    String? signatureHeader,
  }) {
    // 1. Oversized Payload Defense (§5, §48)
    if (rawBodyForSignature != null && rawBodyForSignature.length > maxPayloadSizeBytes) {
      throw const SafeBotException(BotFailureReason.safetyBlock, 'Oversized payload rejected');
    }

    // 2. Webhook Signature Check if signature provided (§56)
    if (signatureHeader != null && rawBodyForSignature != null) {
      if (!verifyWebhookSignature(rawBodyForSignature, signatureHeader)) {
        throw const SafeBotException(BotFailureReason.safetyBlock, 'Invalid webhook signature');
      }
    }

    final adapter = _adapters[channel];
    if (adapter == null) {
      throw SafeBotException(BotFailureReason.channelError, 'Unsupported channel: ${channel.name}');
    }

    // 3. Parse Incoming Message
    final message = adapter.parseIncoming(rawPayload);

    // 4. Timestamp Replay & Future Skew Validation (§27, §56)
    if (!isTimestampValid(message.timestamp)) {
      throw const SafeBotException(BotFailureReason.safetyBlock, 'Expired or replayed timestamp');
    }

    // 5. Idempotency Check (§57)
    if (_processedMessageIds.contains(message.messageId)) {
      throw const SafeBotException(BotFailureReason.safetyBlock, 'Duplicate message detected');
    }

    // 6. Rate Limiting Check (§45)
    if (!_quotaService.checkAndConsumeUserQuota(message.externalUserId)) {
      throw const SafeBotException(BotFailureReason.rateLimitExceeded, 'User rate limit reached');
    }
    if (!_quotaService.checkAndConsumeChannelQuota(channel.name)) {
      throw const SafeBotException(BotFailureReason.rateLimitExceeded, 'Channel rate limit reached');
    }

    // Register message ID as processed
    _processedMessageIds.add(message.messageId);

    return message;
  }

  /// Formats outbound bot response for a specific channel.
  Map<String, dynamic> formatOutbound(ChannelType channel, UnifiedBotResponse response) {
    final adapter = _adapters[channel];
    if (adapter == null) {
      throw SafeBotException(BotFailureReason.channelError, 'Unsupported channel: ${channel.name}');
    }
    return adapter.formatResponse(response);
  }
}
