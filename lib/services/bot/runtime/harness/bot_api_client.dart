import 'dart:convert';
import '../api/bot_api_server.dart';

/// Test client interacting directly with the Bot API Server in sandbox environment (§17).
class BotApiClient {
  final BotApiServer _server;

  BotApiClient({required BotApiServer server}) : _server = server;

  Future<HttpResponseContext> postMessage({
    required String userId,
    required String text,
    String? idempotencyKey,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (idempotencyKey != null) {
      headers['Idempotency-Key'] = idempotencyKey;
    }

    final body = jsonEncode({
      'user_id': userId,
      'text': text,
    });

    return _server.handleRequest(HttpRequestContext(
      method: 'POST',
      path: '/bot/message',
      headers: headers,
      body: body,
    ));
  }

  Future<HttpResponseContext> checkHealth() async {
    return _server.handleRequest(HttpRequestContext(
      method: 'GET',
      path: '/health',
    ));
  }

  Future<HttpResponseContext> checkReadiness() async {
    return _server.handleRequest(HttpRequestContext(
      method: 'GET',
      path: '/ready',
    ));
  }

  Future<HttpResponseContext> getMetrics() async {
    return _server.handleRequest(HttpRequestContext(
      method: 'GET',
      path: '/metrics',
    ));
  }
}
