import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';

void main() {
  group('L3 Bot Unified Message Contract Tests (§5, §6)', () {
    test('UnifiedIncomingMessage identifies commands and arguments accurately', () {
      final msg = UnifiedIncomingMessage(
        messageId: 'msg_001',
        channel: ChannelType.telegram,
        externalUserId: 'user_123',
        text: '/search الصلاة والزكاة',
        timestamp: DateTime.now().toUtc(),
      );

      expect(msg.isCommand, isTrue);
      expect(msg.commandName, equals('/search'));
      expect(msg.commandArguments, equals('الصلاة والزكاة'));
    });

    test('UnifiedIncomingMessage correctly parses plain text inquiries', () {
      final msg = UnifiedIncomingMessage(
        messageId: 'msg_002',
        channel: ChannelType.webChat,
        externalUserId: 'web_usr_1',
        text: 'ما فضل صلاة الفجر؟',
        timestamp: DateTime.now().toUtc(),
      );

      expect(msg.isCommand, isFalse);
      expect(msg.commandName, isEmpty);
      expect(msg.commandArguments, isEmpty);
    });
  });
}
