import 'dart:convert';
import '../api/bot_api_server.dart';

/// Integration harness simulating Telegram Bot API webhook calls in sandbox environment (§14).
class TelegramIntegrationHarness {
  final BotApiServer _apiServer;

  TelegramIntegrationHarness({required BotApiServer apiServer}) : _apiServer = apiServer;

  /// Simulates an incoming text message update from Telegram.
  Future<HttpResponseContext> sendTextMessage({
    required int updateId,
    required int messageId,
    required int userId,
    required String text,
    String? secretToken,
  }) async {
    final payload = {
      'update_id': updateId,
      'message': {
        'message_id': messageId,
        'from': {'id': userId, 'first_name': 'TestUser'},
        'chat': {'id': userId, 'type': 'private'},
        'text': text,
        'date': DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
      },
    };

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (secretToken != null) {
      headers['X-Telegram-Bot-Api-Secret-Token'] = secretToken;
    }

    return _apiServer.handleRequest(HttpRequestContext(
      method: 'POST',
      path: '/bot/webhook/telegram',
      headers: headers,
      body: jsonEncode(payload),
    ));
  }

  /// Simulates an incoming button callback query from Telegram.
  Future<HttpResponseContext> sendCallbackQuery({
    required int updateId,
    required String callbackId,
    required int userId,
    required String callbackData,
    String? secretToken,
  }) async {
    final payload = {
      'update_id': updateId,
      'callback_query': {
        'id': callbackId,
        'from': {'id': userId, 'first_name': 'TestUser'},
        'data': callbackData,
      },
    };

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (secretToken != null) {
      headers['X-Telegram-Bot-Api-Secret-Token'] = secretToken;
    }

    return _apiServer.handleRequest(HttpRequestContext(
      method: 'POST',
      path: '/bot/webhook/telegram',
      headers: headers,
      body: jsonEncode(payload),
    ));
  }
}
