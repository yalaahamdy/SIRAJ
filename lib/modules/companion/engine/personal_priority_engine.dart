import '../domain/companion_preferences.dart';
import '../domain/dashboard_card.dart';
import '../domain/module_status.dart';
import '../domain/personal_goal.dart';
import 'cognitive_load_guard.dart';

/// Engine synthesizing and prioritizing contextual dashboard cards (§10, §11).
class PersonalPriorityEngine {
  final CognitiveLoadGuard _loadGuard;

  const PersonalPriorityEngine({CognitiveLoadGuard? loadGuard})
      : _loadGuard = loadGuard ?? const CognitiveLoadGuard();

  List<DashboardCard> buildDashboard({
    required List<ModuleStatusSummary> moduleStatuses,
    required List<PersonalGoal> activeGoals,
    required CompanionPreferences preferences,
    required DateTime currentTime,
  }) {
    final rawCards = <DashboardCard>[];
    int currentOrder = 0;

    // 1. Check for Active Hajj/Umrah Journey (Context Priority §40)
    final hajjStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'hajj',
          orElse: () => null,
        );
    if (hajjStatus != null && hajjStatus.dueCount != null && hajjStatus.dueCount! > 0) {
      rawCards.add(DashboardCard(
        cardId: 'card_active_hajj_journey',
        section: CardSection.now,
        sourceModule: 'hajj',
        titleArabic: 'الرحلة النسكية النشطة',
        subtitleArabic: hajjStatus.progressSummary ?? 'خطوة نسك بانتظار إنجازك',
        badgeText: 'نسك مباشر',
        actionLabel: 'متابعة النسك',
        targetRoute: '/hajj',
        priorityOrder: currentOrder++,
      ));
    }

    // 2. Prayer Card (High Priority §11)
    final prayerStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'prayer',
          orElse: () => null,
        );
    if (prayerStatus != null && prayerStatus.isOperational) {
      rawCards.add(DashboardCard(
        cardId: 'card_prayer_now',
        section: CardSection.now,
        sourceModule: 'prayer',
        titleArabic: 'مواقيت الصلاة والقبلة',
        subtitleArabic: prayerStatus.progressSummary ?? 'وقت الصلاة القادمة محدد بدقة',
        actionLabel: 'عرض المواقيت والقبلة',
        targetRoute: '/prayer',
        priorityOrder: currentOrder++,
      ));
    }

    // 3. Adhkar Card (Contextual by time §34)
    final hour = currentTime.hour;
    final isMorning = hour >= 4 && hour < 15;
    final adhkarTitle = isMorning ? 'أذكار الصباح' : 'أذكار المساء';
    final adhkarSubtitle = isMorning
        ? 'ابدأ يومك بذكر الله وحصنه المأثور'
        : 'اختم يومك بالذكر والاستغفار المأثور';

    rawCards.add(DashboardCard(
      cardId: 'card_adhkar_contextual',
      section: CardSection.today,
      sourceModule: 'adhkar',
      titleArabic: adhkarTitle,
      subtitleArabic: adhkarSubtitle,
      actionLabel: 'فتح الأذكار',
      targetRoute: '/adhkar',
      priorityOrder: currentOrder++,
    ));

    // 4. Quran Reading Card (§35)
    final quranStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'quran',
          orElse: () => null,
        );
    if (quranStatus != null && quranStatus.isOperational) {
      rawCards.add(DashboardCard(
        cardId: 'card_quran_reading',
        section: CardSection.continueSection,
        sourceModule: 'quran',
        titleArabic: 'الورد القرآني اليومي',
        subtitleArabic: quranStatus.progressSummary ?? 'تابع تلاوتك وتدبرك من حيث توقفت',
        actionLabel: 'فتح المصحف',
        targetRoute: '/quran',
        priorityOrder: currentOrder++,
      ));
    }

    // 5. Memorization Card (§34)
    final memorizationStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'memorization',
          orElse: () => null,
        );
    if (memorizationStatus != null && memorizationStatus.isOperational) {
      rawCards.add(DashboardCard(
        cardId: 'card_memorization_review',
        section: CardSection.continueSection,
        sourceModule: 'memorization',
        titleArabic: 'مراجعة وتثبيت الحفظ',
        subtitleArabic: memorizationStatus.progressSummary ?? 'جلسات المراجعة المتباعدة المجدولة',
        actionLabel: 'متابعة الحفظ',
        targetRoute: '/memorization',
        priorityOrder: currentOrder++,
      ));
    }

    // 6. Active Goals Cards (§12, §13)
    for (final goal in activeGoals) {
      rawCards.add(DashboardCard(
        cardId: 'card_goal_${goal.goalId}',
        section: CardSection.goals,
        sourceModule: goal.sourceModule,
        titleArabic: goal.title,
        subtitleArabic: 'التقدم: ${goal.currentProgress.toInt()} من ${goal.target.toInt()} ${goal.unitArabic} (${goal.progressPercentage.toStringAsFixed(0)}%)',
        badgeText: goal.type.labelArabic,
        actionLabel: 'تحديث الهدف',
        priorityOrder: currentOrder++,
        metadata: {'goal_id': goal.goalId},
      ));
    }

    // 7. Fasting Card (if relevant §39)
    final fastingStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'fasting',
          orElse: () => null,
        );
    if (fastingStatus != null && fastingStatus.isOperational) {
      rawCards.add(DashboardCard(
        cardId: 'card_fasting_status',
        section: CardSection.today,
        sourceModule: 'fasting',
        titleArabic: 'متابعة الصيام ورمضان',
        subtitleArabic: fastingStatus.progressSummary ?? 'سجل يومك وخطط لقضاء الصيام',
        actionLabel: 'عرض الصيام',
        targetRoute: '/fasting',
        priorityOrder: currentOrder++,
      ));
    }

    // 8. Learning & Knowledge Card (§37)
    final learningStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'learning',
          orElse: () => null,
        );
    if (learningStatus != null && learningStatus.isOperational) {
      rawCards.add(DashboardCard(
        cardId: 'card_learning_continue',
        section: CardSection.continueSection,
        sourceModule: 'learning',
        titleArabic: 'مسارات التعلم والتفقه',
        subtitleArabic: learningStatus.progressSummary ?? 'تابع دروسك ومناهجك التعليمية',
        actionLabel: 'متابعة التعلم',
        targetRoute: '/learning',
        priorityOrder: currentOrder++,
      ));
    }

    // 9. Seerah Card (§38)
    final seerahStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'seerah',
          orElse: () => null,
        );
    if (seerahStatus != null && seerahStatus.isOperational) {
      rawCards.add(DashboardCard(
        cardId: 'card_seerah_stations',
        section: CardSection.explore,
        sourceModule: 'seerah',
        titleArabic: 'محطات السيرة النبوية',
        subtitleArabic: seerahStatus.progressSummary ?? 'استكشف محطات التاريخ والقدوة النبوية',
        actionLabel: 'عرض السيرة',
        targetRoute: '/seerah',
        priorityOrder: currentOrder++,
      ));
    }

    // 10. Zakat Card (§36)
    final zakatStatus = moduleStatuses.cast<ModuleStatusSummary?>().firstWhere(
          (m) => m?.moduleId == 'zakat',
          orElse: () => null,
        );
    if (zakatStatus != null && zakatStatus.isOperational) {
      rawCards.add(DashboardCard(
        cardId: 'card_zakat_check',
        section: CardSection.today,
        sourceModule: 'zakat',
        titleArabic: 'مراجعة الزكاة والحول',
        subtitleArabic: zakatStatus.progressSummary ?? 'حساب النصاب وحول الأصول المالية',
        actionLabel: 'مراجعة الزكاة',
        targetRoute: '/zakat',
        priorityOrder: currentOrder++,
      ));
    }

    // 11. Hajj Guide Card if not currently in active journey (§39)
    if (hajjStatus != null && hajjStatus.isOperational && (hajjStatus.dueCount == null || hajjStatus.dueCount == 0)) {
      rawCards.add(DashboardCard(
        cardId: 'card_hajj_guide',
        section: CardSection.explore,
        sourceModule: 'hajj',
        titleArabic: 'دليل الحج والعمرة',
        subtitleArabic: hajjStatus.progressSummary ?? 'دليل المناسك والمواقيت والمشاعر',
        actionLabel: 'فتح الدليل',
        targetRoute: '/hajj',
        priorityOrder: currentOrder++,
      ));
    }

    // 12. Apply Cognitive Load Guard (§32)
    return _loadGuard.guardCards(rawCards: rawCards, preferences: preferences);
  }
}
