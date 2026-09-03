import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/ops/adapters/telegram_staging_adapter.dart';
import 'package:siraj/services/bot/ops/adapters/whatsapp_staging_adapter.dart';

void main() {
  group('M16 Bot Staging Channel Adapters Tests (§3, §4)', () {
    const tgAdapter = TelegramStagingAdapter();
    const waAdapter = WhatsAppStagingAdapter();

    test('TelegramStagingAdapter parses commands and formats inline keyboards', () {
      final rawUpdate = {
        'update_id': 9901,
        'message': {
          'message_id': 1001,
          'from': {'id': 1234567},
          'text': '/prayer',
        },
      };

      final msg = tgAdapter.parseIncoming(rawUpdate);
      expect(msg.channel, equals(ChannelType.telegram));
      expect(msg.externalUserId, equals('1234567'));
      expect(msg.isCommand, isTrue);
      expect(msg.commandName, equals('/prayer'));

      const response = UnifiedBotResponse(
        requestId: 'req_tg_1',
        textArabic: 'مواقيت الصلاة',
        menu: BotMenu(
          title: 'خيارات',
          rows: [
            [BotButton(id: 'btn_qibla', labelArabic: 'القبلة', callbackData: '/qibla')],
          ],
        ),
      );

      final formatted = tgAdapter.formatResponse(response);
      expect(formatted['parse_mode'], equals('HTML'));
      expect(formatted['reply_markup']?['inline_keyboard'], isNotNull);
    });

    test('WhatsAppStagingAdapter parses interactive button replies and formats cloud API buttons', () {
      final rawInteractive = {
        'entry': [
          {
            'changes': [
              {
                'value': {
                  'messages': [
                    {
                      'id': 'wamid_btn_1',
                      'from': '966501234567',
                      'type': 'interactive',
                      'interactive': {
                        'button_reply': {'id': 'BTN_PRAYER_CONFIRM', 'title': 'مواقيت الصلاة'}
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      };

      final msg = waAdapter.parseIncoming(rawInteractive);
      expect(msg.channel, equals(ChannelType.whatsapp));
      expect(msg.externalUserId, equals('966501234567'));
      expect(msg.callbackPayload, equals('BTN_PRAYER_CONFIRM'));

      const response = UnifiedBotResponse(
        requestId: 'req_wa_1',
        textArabic: 'الخدمات المتاحة',
        menu: BotMenu(
          title: 'قائمة',
          rows: [
            [BotButton(id: 'btn1', labelArabic: 'الصلاة')],
          ],
        ),
      );

      final formatted = waAdapter.formatResponse(response);
      expect(formatted['type'], equals('interactive'));
      expect(formatted['interactive']?['action']?['buttons'], isNotNull);
    });
  });
}
