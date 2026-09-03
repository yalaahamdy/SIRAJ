import '../domain/unified_message.dart';
import 'channel_adapter_contract.dart';

/// Adapter for Telegram Bot API (§4, §15, §35).
class TelegramAdapter implements ChannelAdapterContract {
  const TelegramAdapter();

  @override
  ChannelType get channelType => ChannelType.telegram;

  @override
  UnifiedIncomingMessage parseIncoming(Map<String, dynamic> rawPayload) {
    final message = rawPayload['message'] ?? rawPayload['callback_query']?['message'] ?? {};
    final from = rawPayload['message']?['from'] ?? rawPayload['callback_query']?['from'] ?? {};
    final callbackData = rawPayload['callback_query']?['data'] as String?;

    final messageId = message['message_id']?.toString() ?? 'tg_msg_${DateTime.now().millisecondsSinceEpoch}';
    final externalUserId = from['id']?.toString() ?? 'unknown_tg_user';
    final text = message['text'] as String? ?? (callbackData ?? '');

    return UnifiedIncomingMessage(
      messageId: messageId,
      channel: ChannelType.telegram,
      externalUserId: externalUserId,
      conversationId: message['chat']?['id']?.toString(),
      text: text,
      callbackPayload: callbackData,
      timestamp: DateTime.now().toUtc(),
      channelMetadata: {'chat_id': message['chat']?['id']},
    );
  }

  @override
  Map<String, dynamic> formatResponse(UnifiedBotResponse response) {
    final payload = <String, dynamic>{
      'text': response.textArabic,
      'parse_mode': 'HTML',
    };

    if (response.menu != null && response.menu!.rows.isNotEmpty) {
      final inlineKeyboard = <List<Map<String, dynamic>>>[];
      for (final row in response.menu!.rows) {
        final keyboardRow = <Map<String, dynamic>>[];
        for (final btn in row) {
          if (btn.url != null) {
            keyboardRow.add({'text': btn.labelArabic, 'url': btn.url});
          } else {
            keyboardRow.add({
              'text': btn.labelArabic,
              'callback_data': btn.callbackData ?? btn.id,
            });
          }
        }
        inlineKeyboard.add(keyboardRow);
      }
      payload['reply_markup'] = {'inline_keyboard': inlineKeyboard};
    } else if (response.quickReplies.isNotEmpty) {
      final keyboard = response.quickReplies
          .map((q) => [{'text': q.textArabic}])
          .toList();
      payload['reply_markup'] = {
        'keyboard': keyboard,
        'one_time_keyboard': true,
        'resize_keyboard': true,
      };
    }

    return payload;
  }
}
