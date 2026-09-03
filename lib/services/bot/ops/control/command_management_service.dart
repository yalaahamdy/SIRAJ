import '../../commands/command_registry.dart';
import '../../domain/unified_message.dart';

/// Service managing dynamic command enablement and discovery per channel (§17, §18).
class CommandManagementService {
  final BotCommandRegistry _commandRegistry;
  final Map<String, bool> _commandStatus = {};

  CommandManagementService({required BotCommandRegistry commandRegistry})
      : _commandRegistry = commandRegistry;

  void enableCommand(String commandName) {
    _commandStatus[commandName] = true;
  }

  void disableCommand(String commandName) {
    _commandStatus[commandName] = false;
  }

  bool isCommandEnabled(String commandName) {
    return _commandStatus[commandName] ?? true; // Enabled by default unless disabled
  }

  List<BotCommandDefinition> getAvailableCommandsForChannel(ChannelType channel) {
    return _commandRegistry.allCommands.where((cmd) => isCommandEnabled(cmd.name)).toList();
  }
}
