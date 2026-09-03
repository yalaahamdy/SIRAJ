import '../../domain/unified_message.dart';

/// The 7 distinct pilot personas representing real-world staging testers (§3).
enum PilotPersonaType {
  newUser, // Persona A: First contact, discovery, help
  quranUser, // Persona B: Quran reading, ayah search, memorization
  worshipRoutineUser, // Persona C: Prayer times, adhkar, fasting
  knowledgeLearner, // Persona D: Hadith, fiqh search, learning paths
  hajjUser, // Persona E: Hajj & Umrah ritual journeys
  powerUser, // Persona F: Advanced commands, natural language, buttons, multi-turn
  adversarialUser, // Persona G: Jailbreaks, prompt injections, fatwa elicitation, flood
}

/// A structured profile for a staging pilot tester (§2, §3).
class PilotPersona {
  final String testerId;
  final PilotPersonaType type;
  final ChannelType channel;
  final String descriptionArabic;
  final Set<String> enabledFeatures;

  const PilotPersona({
    required this.testerId,
    required this.type,
    required this.channel,
    required this.descriptionArabic,
    this.enabledFeatures = const {'all_staging_features'},
  });

  static List<PilotPersona> getStandardCohort() {
    return const [
      PilotPersona(
        testerId: 'pilot_persona_a_new',
        type: PilotPersonaType.newUser,
        channel: ChannelType.telegram,
        descriptionArabic: 'مستخدم جديد يتعرف على المنصة عبر /start و /help',
      ),
      PilotPersona(
        testerId: 'pilot_persona_b_quran',
        type: PilotPersonaType.quranUser,
        channel: ChannelType.telegram,
        descriptionArabic: 'مستخدم القرآن الكريم وتتبع ورد الحفظ اليومي',
      ),
      PilotPersona(
        testerId: 'pilot_persona_c_worship',
        type: PilotPersonaType.worshipRoutineUser,
        channel: ChannelType.whatsapp,
        descriptionArabic: 'مستخدم مواقيت الصلاة والأذكار وحساب أيام الصيام',
      ),
      PilotPersona(
        testerId: 'pilot_persona_d_learner',
        type: PilotPersonaType.knowledgeLearner,
        channel: ChannelType.webChat,
        descriptionArabic: 'طالب العلم الباحث في الأحاديث والمسائل الفقهية الموثقة',
      ),
      PilotPersona(
        testerId: 'pilot_persona_e_hajj',
        type: PilotPersonaType.hajjUser,
        channel: ChannelType.telegram,
        descriptionArabic: 'الحاج والمعتمر المستعرض لخطوات النسك والمواقيت',
      ),
      PilotPersona(
        testerId: 'pilot_persona_f_power',
        type: PilotPersonaType.powerUser,
        channel: ChannelType.api,
        descriptionArabic: 'المستخدم المتقدم الذي يدمج الأوامر والنصوص والأزرار',
      ),
      PilotPersona(
        testerId: 'pilot_persona_g_adversarial',
        type: PilotPersonaType.adversarialUser,
        channel: ChannelType.telegram,
        descriptionArabic: 'المختبر المعادي الذي يحاول تجاوز القيود واستدراج الفتاوى',
      ),
    ];
  }
}
