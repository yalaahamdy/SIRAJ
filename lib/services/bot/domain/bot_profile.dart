import 'package:equatable/equatable.dart';

/// Supported bot capabilities (§12).
enum BotCapability {
  quranSearch,
  hadithLookup,
  adhkarRetrieval,
  prayerSchedule,
  fastingTracker,
  zakatCalculation,
  seerahEvents,
  learningPaths,
  hajjGuide,
  interactiveWorkflows;

  String get labelArabic {
    switch (this) {
      case BotCapability.quranSearch:
        return 'البحث القرآني';
      case BotCapability.hadithLookup:
        return 'استرجاع الحديث الشريف';
      case BotCapability.adhkarRetrieval:
        return 'الأذكار والأدعية المأثورة';
      case BotCapability.prayerSchedule:
        return 'مواقيت الصلاة واتجاه القبلة';
      case BotCapability.fastingTracker:
        return 'متابعة الصيام وقضاء رمضان';
      case BotCapability.zakatCalculation:
        return 'حساب الزكاة المعتمد';
      case BotCapability.seerahEvents:
        return 'السيرة النبوية والتاريخ';
      case BotCapability.learningPaths:
        return 'المناهج والمسارات التعليمية';
      case BotCapability.hajjGuide:
        return 'دليل مناسك الحج والعمرة';
      case BotCapability.interactiveWorkflows:
        return 'المسارات التفاعلية المؤكدة';
    }
  }
}

/// Profile configuration for a specialized or general Islamic bot (§12, §13).
class BotProfile extends Equatable {
  final String botId;
  final String displayNameArabic;
  final String descriptionArabic;
  final String defaultLocale;
  final Set<BotCapability> enabledCapabilities;
  final bool isDefault;

  const BotProfile({
    required this.botId,
    required this.displayNameArabic,
    required this.descriptionArabic,
    this.defaultLocale = 'ar',
    this.enabledCapabilities = const {
      BotCapability.quranSearch,
      BotCapability.hadithLookup,
      BotCapability.adhkarRetrieval,
      BotCapability.prayerSchedule,
      BotCapability.fastingTracker,
      BotCapability.zakatCalculation,
      BotCapability.seerahEvents,
      BotCapability.learningPaths,
      BotCapability.hajjGuide,
      BotCapability.interactiveWorkflows,
    },
    this.isDefault = true,
  });

  bool supports(BotCapability capability) => enabledCapabilities.contains(capability);

  @override
  List<Object?> get props => [
        botId,
        displayNameArabic,
        descriptionArabic,
        defaultLocale,
        enabledCapabilities,
        isDefault,
      ];
}
