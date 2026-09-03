import '../../adapters/channel_adapter_contract.dart';
import '../../domain/bot_error.dart';
import '../../domain/unified_message.dart';

/// Production-grade Telegram Staging Adapter supporting Webhooks, Commands, Inline Keyboards, and Callbacks (§3).
class TelegramStagingAdapter implements ChannelAdapterContract {
  const TelegramStagingAdapter();

  @override
  ChannelType get channelType => ChannelType.telegram;

  @override
  UnifiedIncomingMessage parseIncoming(Map<String, dynamic> rawPayload) {
    if (rawPayload.containsKey('message')) {
      final msg = rawPayload['message'] as Map<String, dynamic>;
      final from = msg['from'] as Map<String, dynamic>? ?? {};
      final chat = msg['chat'] as Map<String, dynamic>? ?? {};
      final text = msg['text'] as String? ?? '';
      final msgId = msg['message_id']?.toString() ?? 'unknown_tg_msg';
      final userId = from['id']?.toString() ?? chat['id']?.toString() ?? 'anonymous_tg';

      return UnifiedIncomingMessage(
        messageId: msgId,
        channel: ChannelType.telegram,
        externalUserId: userId,
        text: text,
        timestamp: DateTime.now().toUtc(),
      );
    } else if (rawPayload.containsKey('callback_query')) {
      final cb = rawPayload['callback_query'] as Map<String, dynamic>;
      final from = cb['from'] as Map<String, dynamic>? ?? {};
      final data = cb['data'] as String? ?? '';
      final cbId = cb['id']?.toString() ?? 'unknown_tg_cb';
      final userId = from['id']?.toString() ?? 'anonymous_tg';

      return UnifiedIncomingMessage(
        messageId: cbId,
        channel: ChannelType.telegram,
        externalUserId: userId,
        text: data,
        callbackPayload: data,
        timestamp: DateTime.now().toUtc(),
      );
    }

    throw const SafeBotException(BotFailureReason.channelError, 'Malformed Telegram update payload');
  }

  @override
  Map<String, dynamic> formatResponse(UnifiedBotResponse response) {
    final Map<String, dynamic> output = {
      'text': response.textArabic,
      'parse_mode': 'HTML',
    };

    if (response.menu != null && response.menu!.rows.isNotEmpty) {
      final List<List<Map<String, dynamic>>> inlineKeyboard = [];
      for (final row in response.menu!.rows) {
        final List<Map<String, dynamic>> keyboardRow = [];
        for (final btn in row) {
          keyboardRow.add({
            'text': btn.labelArabic,
            'callback_data': btn.callbackData ?? btn.id,
          });
        }
        inlineKeyboard.add(keyboardRow);
      }
      output['reply_markup'] = {'inline_keyboard': inlineKeyboard};
    }

    return output;
  }
}
