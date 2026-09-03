/// Global Emergency Kill Switch for Safety & Incident Mitigation (§15).
class GlobalSafetyKillSwitch {
  bool _isGlobalAiKilled = false;
  final Set<String> _killedTools = {};
  final Set<String> _killedChannels = {};
  bool _isAllWriteActionsKilled = false;

  bool get isGlobalAiKilled => _isGlobalAiKilled;
  bool get isAllWriteActionsKilled => _isAllWriteActionsKilled;

  void killAi({required String reason}) {
    _isGlobalAiKilled = true;
  }

  void restoreAi() {
    _isGlobalAiKilled = false;
  }

  void killTool(String toolName) {
    _killedTools.add(toolName);
  }

  void restoreTool(String toolName) {
    _killedTools.remove(toolName);
  }

  void killChannel(String channelName) {
    _killedChannels.add(channelName);
  }

  void restoreChannel(String channelName) {
    _killedChannels.remove(channelName);
  }

  void killAllWriteActions() {
    _isAllWriteActionsKilled = true;
  }

  void restoreAllWriteActions() {
    _isAllWriteActionsKilled = false;
  }

  bool isToolKilled(String toolName) => _killedTools.contains(toolName);
  bool isChannelKilled(String channelName) => _killedChannels.contains(channelName);

  Map<String, dynamic> getStatus() {
    return {
      'is_global_ai_killed': _isGlobalAiKilled,
      'is_all_write_actions_killed': _isAllWriteActionsKilled,
      'killed_tools': _killedTools.toList(),
      'killed_channels': _killedChannels.toList(),
    };
  }
}
