import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/ops/lifecycle/webhook_lifecycle_manager.dart';

void main() {
  group('M16 Bot Webhook Lifecycle & Secret Rotation Tests (§6, §7)', () {
    const initialSecret = 'initial_staging_secret_key_101';
    const newSecret = 'rotated_new_secret_key_202';
    late WebhookLifecycleManager manager;

    setUp(() {
      manager = WebhookLifecycleManager(
        initialSecrets: {ChannelType.telegram: initialSecret},
        rotationGracePeriod: const Duration(seconds: 2),
      );
    });

    String generateSig(String secret, String body) {
      final key = utf8.encode(secret);
      final bytes = utf8.encode(body);
      return Hmac(sha256, key).convert(bytes).toString();
    }

    test('Verifies signature with initial active secret', () {
      const body = '{"update_id": 1234}';
      final sig = generateSig(initialSecret, body);

      expect(
        manager.verifyHmacSignature(
          channel: ChannelType.telegram,
          rawBody: body,
          signature: sig,
        ),
        isTrue,
      );
    });

    test('Supports safe overlap grace period during secret rotation', () {
      const body = '{"update_id": 5678}';
      final oldSig = generateSig(initialSecret, body);
      final newSig = generateSig(newSecret, body);

      // Rotate secret
      manager.rotateSecret(ChannelType.telegram, newSecret);

      // Both new and old signatures are valid during grace period
      expect(
        manager.verifyHmacSignature(
          channel: ChannelType.telegram,
          rawBody: body,
          signature: newSig,
        ),
        isTrue,
      );

      expect(
        manager.verifyHmacSignature(
          channel: ChannelType.telegram,
          rawBody: body,
          signature: oldSig,
        ),
        isTrue,
      );
    });

    test('Disables webhook verification when channel endpoint is explicitly disabled', () {
      const body = '{"update_id": 9999}';
      final sig = generateSig(initialSecret, body);

      manager.disableWebhook(ChannelType.telegram);

      expect(
        manager.verifyHmacSignature(
          channel: ChannelType.telegram,
          rawBody: body,
          signature: sig,
        ),
        isFalse,
      );
    });
  });
}
