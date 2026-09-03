import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/services/bot/commands/command_registry.dart';
import 'package:siraj/services/bot/commands/standard_commands.dart';
import 'package:siraj/services/bot/domain/bot_session.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';

void main() {
  group('L3 Bot Command System Tests (§14, §15, §44)', () {
    late BotCommandRegistry registry;
    late ConversationSession dummySession;

    setUp(() {
      registry = BotCommandRegistry(commands: StandardBotCommands.createStandardSuite());
      dummySession = ConversationSession(
        sessionId: 'sess_test',
        internalUserId: 'usr_test',
        externalUserId: 'ext_test',
        channel: ChannelType.telegram,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
    });

    test('Executes /start and returns main menu', () async {
      final cmd = registry.getCommand('/start');
      expect(cmd, isNotNull);

      final res = await cmd!.handler(
        message: UnifiedIncomingMessage(
          messageId: 'm1',
          channel: ChannelType.telegram,
          externalUserId: 'u1',
          text: '/start',
          timestamp: DateTime.now().toUtc(),
        ),
        session: dummySession,
        arguments: '',
      );

      expect(res.menu, isNotNull);
      expect(res.menu!.rows.isNotEmpty, isTrue);
    });

    test('Executes /prayer, /quran, /adhkar commands accurately', () async {
      final prayerCmd = registry.getCommand('/prayer');
      final quranCmd = registry.getCommand('/quran');
      final adhkarCmd = registry.getCommand('/adhkar');

      final resPrayer = await prayerCmd!.handler(
        message: UnifiedIncomingMessage(
          messageId: 'm2',
          channel: ChannelType.telegram,
          externalUserId: 'u1',
          text: '/prayer',
          timestamp: DateTime.now().toUtc(),
        ),
        session: dummySession,
        arguments: '',
      );
      expect(resPrayer.textArabic, contains('مواقيت الصلاة'));

      final resQuran = await quranCmd!.handler(
        message: UnifiedIncomingMessage(
          messageId: 'm3',
          channel: ChannelType.telegram,
          externalUserId: 'u1',
          text: '/quran',
          timestamp: DateTime.now().toUtc(),
        ),
        session: dummySession,
        arguments: '',
      );
      expect(resQuran.textArabic, contains('المصحف الشريف'));

      final resAdhkar = await adhkarCmd!.handler(
        message: UnifiedIncomingMessage(
          messageId: 'm4',
          channel: ChannelType.telegram,
          externalUserId: 'u1',
          text: '/adhkar',
          timestamp: DateTime.now().toUtc(),
        ),
        session: dummySession,
        arguments: '',
      );
      expect(resAdhkar.textArabic, contains('الأذكار المأثورة'));
    });

    test('Executes /deletemydata and requests explicit confirmation', () async {
      final delCmd = registry.getCommand('/deletemydata');
      expect(delCmd, isNotNull);

      final res = await delCmd!.handler(
        message: UnifiedIncomingMessage(
          messageId: 'm5',
          channel: ChannelType.telegram,
          externalUserId: 'u1',
          text: '/deletemydata',
          timestamp: DateTime.now().toUtc(),
        ),
        session: dummySession,
        arguments: '',
      );

      expect(res.requiresConfirmation, isTrue);
      expect(res.confirmationActionId, equals('ACTION_DELETE_USER_DATA'));
    });
  });
}
