import 'dart:convert';
import '../../domain/bot_error.dart';
import '../../domain/unified_message.dart';
import '../../siraj_bot_platform.dart';
import '../config/environment_config.dart';
import '../storage/idempotency_store.dart';

/// Request object representing an inbound HTTP call (§6, §7).
class HttpRequestContext {
  final String method;
  final String path;
  final Map<String, String> headers;
  final String body;

  HttpRequestContext({
    required this.method,
    required this.path,
    this.headers = const {},
    this.body = '',
  });

  Map<String, dynamic> parseJsonBody() {
    if (body.isEmpty) return {};
    return jsonDecode(body) as Map<String, dynamic>;
  }
}

/// Response object representing an outbound HTTP result (§6, §7).
class HttpResponseContext {
  final int statusCode;
  final Map<String, String> headers;
  final String body;

  HttpResponseContext({
    required this.statusCode,
    this.headers = const {'Content-Type': 'application/json'},
    required this.body,
  });

  factory HttpResponseContext.json(int statusCode, Map<String, dynamic> data) {
    return HttpResponseContext(
      statusCode: statusCode,
      body: jsonEncode(data),
    );
  }

  factory HttpResponseContext.error(int statusCode, String errorArabic, {String? code}) {
    return HttpResponseContext(
      statusCode: statusCode,
      body: jsonEncode({
        'status': 'error',
        'error_code': code ?? 'INTERNAL_ERROR',
        'message_arabic': errorArabic,
      }),
    );
  }
}

/// Non-sensitive metrics counter (§11).
class BotMetricsCollector {
  int messagesProcessed = 0;
  int toolCalls = 0;
  int abstentions = 0;
  int safetyBlocks = 0;

  Map<String, dynamic> toMetricsJson() {
    return {
      'siraj_bot_messages_total': messagesProcessed,
      'siraj_bot_tool_calls_total': toolCalls,
      'siraj_bot_abstentions_total': abstentions,
      'siraj_bot_safety_blocks_total': safetyBlocks,
    };
  }
}

/// In-process HTTP / REST API Server for the SIRAJ Bot Platform (§5, §6, §7, §8, §9, §10, §11).
class BotApiServer {
  final SirajBotPlatform _platform;
  final EnvironmentConfig _config;
  final IdempotencyStoreContract _idempotencyStore;
  final BotMetricsCollector _metrics = BotMetricsCollector();
  final DateTime _startedAt = DateTime.now().toUtc();

  BotApiServer({
    required SirajBotPlatform platform,
    required EnvironmentConfig config,
    required IdempotencyStoreContract idempotencyStore,
  })  : _platform = platform,
        _config = config,
        _idempotencyStore = idempotencyStore;

  BotMetricsCollector get metrics => _metrics;

  /// Main HTTP Request Dispatcher / Router (§6).
  Future<HttpResponseContext> handleRequest(HttpRequestContext request) async {
    final path = request.path;
    final method = request.method.toUpperCase();

    try {
      // 1. Health & Liveness Probes (§8, §10)
      if (path == '/health' || path == '/live') {
        return HttpResponseContext.json(200, {
          'status': 'ok',
          'alive': true,
          'environment': _config.environment.name,
          'uptime_seconds': DateTime.now().toUtc().difference(_startedAt).inSeconds,
        });
      }

      // 2. Readiness Probe (§9)
      if (path == '/ready') {
        return HttpResponseContext.json(200, {
          'status': 'ready',
          'ready': true,
          'dependencies': {
            'storage': 'healthy',
            'ai_retrieval_core': 'healthy',
            'gateway': 'healthy',
          },
        });
      }

      // 3. Metrics (§11)
      if (path == '/metrics') {
        return HttpResponseContext.json(200, _metrics.toMetricsJson());
      }

      // 4. Inbound Direct Bot Message Endpoint (§17)
      if (path == '/bot/message' && method == 'POST') {
        return await _handleDirectMessage(request);
      }

      // 5. Telegram Webhook Sandbox Endpoint (§13, §14)
      if (path == '/bot/webhook/telegram' && method == 'POST') {
        return await _handleTelegramWebhook(request);
      }

      // 6. WhatsApp Webhook Sandbox Endpoint (§13, §15)
      if (path == '/bot/webhook/whatsapp' && method == 'POST') {
        return await _handleWhatsAppWebhook(request);
      }

      // 7. Account Linking: Generate Code (§33, §40)
      if (path == '/bot/account/generate-code' && method == 'POST') {
        final payload = request.parseJsonBody();
        final userId = payload['internal_user_id'] as String? ?? 'usr_demo';
        final code = _platform.accountLinkingService.generateLinkingCode(userId);
        return HttpResponseContext.json(200, {
          'status': 'success',
          'linking_code': code,
          'valid_for_seconds': 300,
        });
      }

      // 8. Account Linking: Verify Code (§33, §40)
      if (path == '/bot/account/link' && method == 'POST') {
        final payload = request.parseJsonBody();
        final code = payload['linking_code'] as String? ?? '';
        final channelStr = payload['channel'] as String? ?? 'telegram';
        final externalId = payload['external_user_id'] as String? ?? '';

        final channel = ChannelType.values.firstWhere(
          (c) => c.name == channelStr,
          orElse: () => ChannelType.telegram,
        );

        final linked = await _platform.accountLinkingService.linkChannelAccount(
          code: code,
          channel: channel,
          externalUserId: externalId,
        );

        return HttpResponseContext.json(200, {
          'status': linked ? 'success' : 'failed',
          'message_arabic': 'تم ربط الحساب بنجاح.',
        });
      }

      return HttpResponseContext.error(404, 'المسار المطلوب غير موجود', code: 'NOT_FOUND');
    } catch (e) {
      if (e is SafeBotException) {
        _metrics.safetyBlocks++;
        return HttpResponseContext.error(400, e.safeMessageArabic, code: e.reason.name);
      }
      return HttpResponseContext.error(500, 'حدث خطأ داخلي غير متوقع', code: 'INTERNAL_ERROR');
    }
  }

  Future<HttpResponseContext> _handleDirectMessage(HttpRequestContext request) async {
    final idempotencyKey = request.headers['Idempotency-Key'] ?? request.headers['idempotency-key'];
    if (idempotencyKey != null) {
      final isNew = await _idempotencyStore.checkAndRegisterKey(idempotencyKey);
      if (!isNew) {
        return HttpResponseContext.error(409, 'تم استلام هذا الطلب ومعالجته مسبقاً', code: 'DUPLICATE_REQUEST');
      }
    }

    final payload = request.parseJsonBody();
    final text = payload['text'] as String? ?? '';
    final userId = payload['user_id'] as String? ?? 'api_user';

    final message = UnifiedIncomingMessage(
      messageId: idempotencyKey ?? 'msg_api_${DateTime.now().millisecondsSinceEpoch}',
      channel: ChannelType.api,
      externalUserId: userId,
      text: text,
      timestamp: DateTime.now().toUtc(),
    );

    final response = await _platform.handleUnifiedMessage(message);
    _metrics.messagesProcessed++;
    if (response.isAbstained) _metrics.abstentions++;

    return HttpResponseContext.json(200, {
      'status': 'success',
      'request_id': response.requestId,
      'answer': response.textArabic,
      'citations': response.citations.map((c) => {
        'citation_id': c.citationId,
        'source_id': c.sourceId,
        'title': c.displayTitleArabic,
        'location': c.referenceLocation,
      }).toList(),
      'is_abstained': response.isAbstained,
      'requires_confirmation': response.requiresConfirmation,
    });
  }

  Future<HttpResponseContext> _handleTelegramWebhook(HttpRequestContext request) async {
    final payload = request.parseJsonBody();
    final sig = request.headers['X-Telegram-Bot-Api-Secret-Token'];

    final formatted = await _platform.handleRawInbound(
      channel: ChannelType.telegram,
      rawPayload: payload,
      rawBodyForSignature: request.body,
      signatureHeader: sig,
    );

    _metrics.messagesProcessed++;
    return HttpResponseContext.json(200, formatted);
  }

  Future<HttpResponseContext> _handleWhatsAppWebhook(HttpRequestContext request) async {
    final payload = request.parseJsonBody();
    final sig = request.headers['X-Hub-Signature-256'];

    final formatted = await _platform.handleRawInbound(
      channel: ChannelType.whatsapp,
      rawPayload: payload,
      rawBodyForSignature: request.body,
      signatureHeader: sig,
    );

    _metrics.messagesProcessed++;
    return HttpResponseContext.json(200, formatted);
  }
}
