import 'dart:convert';
import '../api/bot_api_server.dart';

/// Integration harness simulating WhatsApp Cloud API webhook calls in sandbox environment (§15).
class WhatsAppIntegrationHarness {
  final BotApiServer _apiServer;

  WhatsAppIntegrationHarness({required BotApiServer apiServer}) : _apiServer = apiServer;

  /// Simulates an incoming text message webhook from WhatsApp.
  Future<HttpResponseContext> sendTextMessage({
    required String messageId,
    required String senderPhone,
    required String text,
    String? hubSignature,
  }) async {
    final payload = {
      'object': 'whatsapp_business_account',
      'entry': [
        {
          'id': 'entry_123',
          'changes': [
            {
              'value': {
                'messaging_product': 'whatsapp',
                'metadata': {'display_phone_number': '12345', 'phone_number_id': '67890'},
                'contacts': [{'profile': {'name': 'Tester'}, 'wa_id': senderPhone}],
                'messages': [
                  {
                    'from': senderPhone,
                    'id': messageId,
                    'timestamp': (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000).toString(),
                    'text': {'body': text},
                    'type': 'text',
                  }
                ],
              },
              'field': 'messages',
            }
          ],
        }
      ],
    };

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (hubSignature != null) {
      headers['X-Hub-Signature-256'] = hubSignature;
    }

    return _apiServer.handleRequest(HttpRequestContext(
      method: 'POST',
      path: '/bot/webhook/whatsapp',
      headers: headers,
      body: jsonEncode(payload),
    ));
  }
}
