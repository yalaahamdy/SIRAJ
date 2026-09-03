import '../domain/unified_message.dart';
import 'channel_adapter_contract.dart';

/// Adapter for WhatsApp Cloud API (§4, §35).
class WhatsAppAdapter implements ChannelAdapterContract {
  const WhatsAppAdapter();

  @override
  ChannelType get channelType => ChannelType.whatsapp;

  @override
  UnifiedIncomingMessage parseIncoming(Map<String, dynamic> rawPayload) {
    final entry = (rawPayload['entry'] as List?)?.firstOrNull ?? {};
    final changes = (entry['changes'] as List?)?.firstOrNull ?? {};
    final value = changes['value'] ?? {};
    final message = (value['messages'] as List?)?.firstOrNull ?? {};

    final messageId = message['id']?.toString() ?? 'wa_msg_${DateTime.now().millisecondsSinceEpoch}';
    final externalUserId = message['from']?.toString() ?? 'unknown_wa_user';
    final text = message['text']?['body'] as String? ??
        message['interactive']?['button_reply']?['id'] as String? ??
        '';

    return UnifiedIncomingMessage(
      messageId: messageId,
      channel: ChannelType.whatsapp,
      externalUserId: externalUserId,
      conversationId: externalUserId,
      text: text,
      callbackPayload: message['interactive']?['button_reply']?['id'] as String?,
      timestamp: DateTime.now().toUtc(),
      channelMetadata: {'phone': externalUserId},
    );
  }

  @override
  Map<String, dynamic> formatResponse(UnifiedBotResponse response) {
    final payload = <String, dynamic>{
      'messaging_product': 'whatsapp',
      'type': 'text',
      'text': {'body': response.textArabic},
    };

    if (response.menu != null && response.menu!.rows.isNotEmpty) {
      final buttons = <Map<String, dynamic>>[];
      for (final row in response.menu!.rows) {
        for (final btn in row) {
          buttons.add({
            'type': 'reply',
            'reply': {'id': btn.id, 'title': btn.labelArabic},
          });
          if (buttons.length >= 3) break; // WhatsApp max 3 reply buttons
        }
        if (buttons.length >= 3) break;
      }
      payload['type'] = 'interactive';
      payload['interactive'] = {
        'type': 'button',
        'body': {'text': response.textArabic},
        'action': {'buttons': buttons},
      };
      payload.remove('text');
    }

    return payload;
  }
}
