import '../../domain/unified_message.dart';

class BotRegistration {
  final String botId;
  final String nameArabic;
  final String descriptionArabic;
  final String defaultLocale;
  final Set<ChannelType> enabledChannels;
  final Set<String> enabledTools;
  final bool isAiEnabled;
  final String safetyProfile;

  const BotRegistration({
    required this.botId,
    required this.nameArabic,
    required this.descriptionArabic,
    this.defaultLocale = 'ar',
    required this.enabledChannels,
    required this.enabledTools,
    this.isAiEnabled = true,
    this.safetyProfile = 'STRICT_CANONICAL_M12',
  });

  Map<String, dynamic> toJson() {
    return {
      'bot_id': botId,
      'name_arabic': nameArabic,
      'description_arabic': descriptionArabic,
      'default_locale': defaultLocale,
      'enabled_channels': enabledChannels.map((c) => c.name).toList(),
      'enabled_tools': enabledTools.toList(),
      'is_ai_enabled': isAiEnabled,
      'safety_profile': safetyProfile,
    };
  }
}

/// Central registry managing multiple bot identities sharing the core engine (§10, §11, §12).
class BotRegistry {
  final Map<String, BotRegistration> _bots = {};

  BotRegistry({List<BotRegistration>? initialBots}) {
    if (initialBots != null) {
      for (final bot in initialBots) {
        _bots[bot.botId] = bot;
      }
    } else {
      _initStandardBots();
    }
  }

  void _initStandardBots() {
    registerBot(const BotRegistration(
      botId: 'siraj_general',
      nameArabic: 'سِراج — الرفيق الإسلامي العام',
      descriptionArabic: 'البوت الإسلامي الموحد للاسترجاع المعرفي الموثق والعبادات اليومية',
      enabledChannels: {ChannelType.telegram, ChannelType.whatsapp, ChannelType.webChat, ChannelType.api},
      enabledTools: {'prayer', 'quran', 'adhkar', 'fasting', 'zakat', 'hajj', 'knowledge', 'learning'},
    ));

    registerBot(const BotRegistration(
      botId: 'siraj_quran',
      nameArabic: 'سِراج — خادم القرآن الكريم',
      descriptionArabic: 'بوت متخصص في تلاوة وتدبر والبحث في المصحف الشريف المعتمد برواية حفص',
      enabledChannels: {ChannelType.telegram, ChannelType.whatsapp, ChannelType.webChat},
      enabledTools: {'quran', 'memorization', 'learning'},
    ));

    registerBot(const BotRegistration(
      botId: 'siraj_ramadan',
      nameArabic: 'سِراج — رفيق الصيام ورمضان',
      descriptionArabic: 'بوت مواقيت الصيام والإمساك والإفطار والسنن والزكاة',
      enabledChannels: {ChannelType.telegram, ChannelType.whatsapp},
      enabledTools: {'fasting', 'prayer', 'adhkar', 'zakat'},
    ));

    registerBot(const BotRegistration(
      botId: 'siraj_learning',
      nameArabic: 'سِراج — أكاديمية المعرفة',
      descriptionArabic: 'بوت المسارات التعليمية والاختبارات التفاعلية الموثقة',
      enabledChannels: {ChannelType.webChat, ChannelType.api, ChannelType.telegram},
      enabledTools: {'learning', 'knowledge', 'seerah'},
    ));
  }

  void registerBot(BotRegistration bot) {
    _bots[bot.botId] = bot;
  }

  BotRegistration? getBot(String botId) => _bots[botId];

  List<BotRegistration> getAllBots() => _bots.values.toList();
}
