import '../../adapters/channel_adapter_contract.dart';
import '../../domain/bot_error.dart';
import '../../domain/unified_message.dart';

/// Production-grade WhatsApp Cloud API Staging Adapter supporting Webhooks and Interactive Messages (§4).
class WhatsAppStagingAdapter implements ChannelAdapterContract {
  const WhatsAppStagingAdapter();

  @override
  ChannelType get channelType => ChannelType.whatsapp;

  @override
  UnifiedIncomingMessage parseIncoming(Map<String, dynamic> rawPayload) {
    try {
      final entries = rawPayload['entry'] as List? ?? [];
      if (entries.isEmpty) {
        throw const SafeBotException(BotFailureReason.channelError, 'Empty WhatsApp entry');
      }

      final changes = entries.first['changes'] as List? ?? [];
      if (changes.isEmpty) {
        throw const SafeBotException(BotFailureReason.channelError, 'Empty WhatsApp changes');
      }

      final value = changes.first['value'] as Map<String, dynamic>? ?? {};
      final messages = value['messages'] as List? ?? [];

      if (messages.isEmpty) {
        throw const SafeBotException(BotFailureReason.channelError, 'No messages in WhatsApp payload');
      }

      final msg = messages.first as Map<String, dynamic>;
      final from = msg['from']?.toString() ?? 'anonymous_wa';
      final msgId = msg['id']?.toString() ?? 'unknown_wa_msg';
      final type = msg['type'] as String? ?? 'text';

      String text = '';
      String? callback;

      if (type == 'text') {
        text = msg['text']?['body'] as String? ?? '';
      } else if (type == 'interactive') {
        final interactive = msg['interactive'] as Map<String, dynamic>? ?? {};
        final buttonReply = interactive['button_reply'] as Map<String, dynamic>?;
        if (buttonReply != null) {
          text = buttonReply['title'] as String? ?? '';
          callback = buttonReply['id'] as String?;
        }
      }

      return UnifiedIncomingMessage(
        messageId: msgId,
        channel: ChannelType.whatsapp,
        externalUserId: from,
        text: text,
        callbackPayload: callback,
        timestamp: DateTime.now().toUtc(),
      );
    } catch (e) {
      if (e is SafeBotException) rethrow;
      throw const SafeBotException(BotFailureReason.channelError, 'Malformed WhatsApp payload');
    }
  }

  @override
  Map<String, dynamic> formatResponse(UnifiedBotResponse response) {
    if (response.menu != null && response.menu!.rows.isNotEmpty) {
      final buttons = <Map<String, dynamic>>[];
      for (final row in response.menu!.rows) {
        for (final btn in row) {
          if (buttons.length < 3) {
            // WhatsApp Cloud API supports up to 3 quick reply buttons per message
            buttons.add({
              'type': 'reply',
              'reply': {
                'id': btn.callbackData ?? btn.id,
                'title': btn.labelArabic.length > 20 ? btn.labelArabic.substring(0, 20) : btn.labelArabic,
              },
            });
          }
        }
      }

      return {
        'messaging_product': 'whatsapp',
        'type': 'interactive',
        'interactive': {
          'type': 'button',
          'body': {'text': response.textArabic},
          'action': {'buttons': buttons},
        },
      };
    }

    return {
      'messaging_product': 'whatsapp',
      'type': 'text',
      'text': {'body': response.textArabic},
    };
  }
}
