/// Dynamic Feature Flag Service for Bot Operations (§14).
class BotFeatureFlagService {
  final Map<String, bool> _flags = {
    'telegram_channel': true,
    'whatsapp_channel': true,
    'webchat_channel': true,
    'api_channel': true,
    'ai_retrieval': true,
    'quran_tool': true,
    'prayer_tool': true,
    'adhkar_tool': true,
    'zakat_tool': true,
    'fasting_tool': true,
    'learning_tool': true,
    'write_tools': false, // Disabled by default
    'account_linking': true,
  };

  bool isEnabled(String flagName) => _flags[flagName] ?? false;

  void setFlag(String flagName, bool value) {
    _flags[flagName] = value;
  }

  Map<String, bool> getAllFlags() => Map.unmodifiable(_flags);
}
