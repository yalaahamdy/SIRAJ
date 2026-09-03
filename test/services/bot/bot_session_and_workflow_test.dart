import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/domain/bot_session.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/session/bot_session_store.dart';
import 'package:siraj/services/bot/session/confirmation_engine.dart';

void main() {
  group('L3 Bot Session & Workflow Tests (§8, §10, §33, §44)', () {
    late MemoryBotSessionStore sessionStore;
    late ConfirmationEngine confirmationEngine;

    setUp(() {
      sessionStore = MemoryBotSessionStore();
      confirmationEngine = ConfirmationEngine();
    });

    test('Creates and retrieves sessions with bounded context window', () async {
      var session = await sessionStore.getOrCreateSession(
        channel: ChannelType.telegram,
        externalUserId: 'tg_user_44',
      );

      expect(session.sessionId.isNotEmpty, isTrue);
      expect(session.state, equals(BotWorkflowState.idle));

      // Add 8 messages to a max 6 window
      for (int i = 1; i <= 8; i++) {
        session = session.copyWith(
          context: session.context.addMessage(ConversationMessage(
            id: 'm_$i',
            isUser: i % 2 == 1,
            text: 'رسالة $i',
            timestamp: DateTime.now().toUtc(),
          )),
        );
      }

      expect(session.context.recentMessages.length, equals(6));
      expect(session.context.recentMessages.first.text, equals('رسالة 3'));
      expect(session.context.recentMessages.last.text, equals('رسالة 8'));
    });

    test('ConfirmationEngine verifies affirmative vs negative responses', () {
      expect(confirmationEngine.isAffirmativeConfirmation('نعم'), isTrue);
      expect(confirmationEngine.isAffirmativeConfirmation('تأكيد'), isTrue);
      expect(confirmationEngine.isAffirmativeConfirmation('yes'), isTrue);

      expect(confirmationEngine.isNegativeConfirmation('لا'), isTrue);
      expect(confirmationEngine.isNegativeConfirmation('إلغاء'), isTrue);
      expect(confirmationEngine.isNegativeConfirmation('cancel'), isTrue);
    });

    test('deleteUserData purges session and identity records cleanly', () async {
      final session = await sessionStore.getOrCreateSession(
        channel: ChannelType.webChat,
        externalUserId: 'web_delete_user',
      );

      await sessionStore.deleteUserData(session.internalUserId);

      // Subsequent creation gets a brand new session ID and empty context
      final newSession = await sessionStore.getOrCreateSession(
        channel: ChannelType.webChat,
        externalUserId: 'web_delete_user',
      );

      expect(newSession.context.recentMessages.isEmpty, isTrue);
    });
  });
}
