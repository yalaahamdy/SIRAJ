import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/adapters/api_adapter.dart';
import 'package:siraj/services/bot/adapters/telegram_adapter.dart';
import 'package:siraj/services/bot/adapters/webchat_adapter.dart';
import 'package:siraj/services/bot/adapters/whatsapp_adapter.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';

void main() {
  group('L3 Bot Channel Adapters Tests (§4, §35)', () {
    test('TelegramAdapter parses raw update and formats inline keyboard response', () {
      const adapter = TelegramAdapter();
      final rawUpdate = {
        'message': {
          'message_id': 101,
          'from': {'id': 999123},
          'chat': {'id': 999123},
          'text': '/start',
        },
      };

      final msg = adapter.parseIncoming(rawUpdate);
      expect(msg.channel, equals(ChannelType.telegram));
      expect(msg.externalUserId, equals('999123'));
      expect(msg.text, equals('/start'));

      const response = UnifiedBotResponse(
        requestId: 'req_1',
        textArabic: 'مرحباً بك',
        menu: BotMenu(
          title: 'القائمة',
          rows: [
            [BotButton(id: 'b1', labelArabic: 'الصلاة', callbackData: '/prayer')],
          ],
        ),
      );

      final formatted = adapter.formatResponse(response);
      expect(formatted['text'], equals('مرحباً بك'));
      expect(formatted['reply_markup']?['inline_keyboard'], isNotNull);
    });

    test('WhatsAppAdapter parses webhook payload and formats interactive button message', () {
      const adapter = WhatsAppAdapter();
      final rawPayload = {
        'entry': [
          {
            'changes': [
              {
                'value': {
                  'messages': [
                    {
                      'id': 'wamid_123',
                      'from': '966500000000',
                      'text': {'body': 'ما فضل الصيام؟'},
                    }
                  ]
                }
              }
            ]
          }
        ]
      };

      final msg = adapter.parseIncoming(rawPayload);
      expect(msg.channel, equals(ChannelType.whatsapp));
      expect(msg.externalUserId, equals('966500000000'));
      expect(msg.text, equals('ما فضل الصيام؟'));

      const response = UnifiedBotResponse(
        requestId: 'req_2',
        textArabic: 'الصيام جنة',
        menu: BotMenu(
          title: 'خيارات',
          rows: [
            [BotButton(id: 'btn_1', labelArabic: 'مواقيت الصيام')],
          ],
        ),
      );

      final formatted = adapter.formatResponse(response);
      expect(formatted['type'], equals('interactive'));
      expect(formatted['interactive']?['action']?['buttons'], isNotNull);
    });

    test('WebChatAdapter and APIAdapter format structured JSON accurately', () {
      const webAdapter = WebChatAdapter();
      const apiAdapter = APIAdapter();

      const response = UnifiedBotResponse(
        requestId: 'req_3',
        textArabic: 'جواب معرفي موثق',
      );

      final webOut = webAdapter.formatResponse(response);
      final apiOut = apiAdapter.formatResponse(response);

      expect(webOut['text'], equals('جواب معرفي موثق'));
      expect(apiOut['status'], equals('success'));
      expect(apiOut['answer'], equals('جواب معرفي موثق'));
    });
  });
}
