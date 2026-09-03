import '../domain/bot_session.dart';
import '../domain/unified_message.dart';

/// Handler contract for executing typed bot commands (§14, §15).
typedef CommandHandler = Future<UnifiedBotResponse> Function({
  required UnifiedIncomingMessage message,
  required ConversationSession session,
  required String arguments,
});

/// Definition of a bot command (§14).
class BotCommandDefinition {
  final String name; // e.g. '/start'
  final String descriptionArabic;
  final CommandHandler handler;

  const BotCommandDefinition({
    required this.name,
    required this.descriptionArabic,
    required this.handler,
  });
}

/// Registry managing typed bot commands (§14, §15).
class BotCommandRegistry {
  final Map<String, BotCommandDefinition> _commands = {};

  BotCommandRegistry({List<BotCommandDefinition>? commands}) {
    if (commands != null) {
      for (final c in commands) {
        registerCommand(c);
      }
    }
  }

  void registerCommand(BotCommandDefinition command) {
    _commands[command.name.toLowerCase()] = command;
  }

  bool hasCommand(String commandName) => _commands.containsKey(commandName.toLowerCase());

  BotCommandDefinition? getCommand(String commandName) => _commands[commandName.toLowerCase()];

  List<BotCommandDefinition> get allCommands => _commands.values.toList();
}
