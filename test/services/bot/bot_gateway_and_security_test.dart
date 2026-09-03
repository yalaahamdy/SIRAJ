import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/domain/bot_error.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/gateway/bot_gateway.dart';
import 'package:siraj/services/bot/gateway/bot_quota_service.dart';

void main() {
  group('L3 Bot Gateway & Security Tests (§7, §45, §56, §57)', () {
    const secret = 'test_secret_key_123';
    late BotGateway gateway;

    setUp(() {
      gateway = BotGateway(
        webhookSecret: secret,
        quotaService: BotQuotaService(maxRequestsPerMinutePerUser: 5),
      );
    });

    test('Validates legitimate HMAC-SHA256 webhook signatures and rejects invalid ones', () {
      const payload = '{"update_id": 12345}';
      final key = utf8.encode(secret);
      final bytes = utf8.encode(payload);
      final validSignature = Hmac(sha256, key).convert(bytes).toString();

      expect(gateway.verifyWebhookSignature(payload, validSignature), isTrue);
      expect(gateway.verifyWebhookSignature(payload, 'wrong_signature'), isFalse);
    });

    test('Rejects replayed or duplicate message IDs (Idempotency defense)', () {
      final rawPayload = {
        'message_id': 'idempotency_msg_100',
        'user_id': 'user_1',
        'text': 'السلام عليكم',
      };

      // First delivery succeeds
      final msg1 = gateway.processInbound(
        channel: ChannelType.webChat,
        rawPayload: rawPayload,
      );
      expect(msg1.messageId, equals('idempotency_msg_100'));

      // Duplicate delivery is rejected
      expect(
        () => gateway.processInbound(
          channel: ChannelType.webChat,
          rawPayload: rawPayload,
        ),
        throwsA(isA<SafeBotException>().having(
          (e) => e.reason,
          'reason',
          equals(BotFailureReason.safetyBlock),
        )),
      );
    });

    test('Enforces user rate limits when quota is exceeded', () {
      for (int i = 0; i < 5; i++) {
        final rawPayload = {
          'message_id': 'rate_msg_$i',
          'user_id': 'heavy_user',
          'text': 'سؤال رقم $i',
        };
        gateway.processInbound(
          channel: ChannelType.webChat,
          rawPayload: rawPayload,
        );
      }

      // 6th request exceeds quota
      final burstPayload = {
        'message_id': 'rate_msg_burst',
        'user_id': 'heavy_user',
        'text': 'سؤال يتجاوز الحد',
      };

      expect(
        () => gateway.processInbound(
          channel: ChannelType.webChat,
          rawPayload: burstPayload,
        ),
        throwsA(isA<SafeBotException>().having(
          (e) => e.reason,
          'reason',
          equals(BotFailureReason.rateLimitExceeded),
        )),
      );
    });
  });
}
