import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/location/location_models.dart';
import '../../../core/storage/storage_contract.dart';
import '../adhkar/adhkar_module.dart';
import '../fasting/fasting_module.dart';
import '../hajj/hajj_module.dart';
import '../knowledge/knowledge_module.dart';
import '../learning/learning_module.dart';
import '../memorization/memorization_module.dart';
import '../prayer/domain/calculation_parameters.dart';
import '../prayer/domain/prayer_type.dart';
import '../prayer/prayer_module.dart';
import '../quran/quran_module.dart';
import '../seerah/seerah_module.dart';
import '../zakat/zakat_module.dart';
import 'domain/companion_preferences.dart';
import 'domain/companion_reminder.dart';
import 'domain/daily_journey.dart';
import 'domain/dashboard_card.dart';
import 'domain/federated_search_result.dart';
import 'domain/module_status.dart';
import 'domain/personal_goal.dart';
import 'domain/personal_habit.dart';
import 'engine/cognitive_load_guard.dart';
import 'engine/goal_engine.dart';
import 'engine/personal_priority_engine.dart';
import 'engine/reminder_orchestrator.dart';
import 'services/search_federation_service.dart';
import 'store/companion_user_data_store.dart';

/// Unified Facade for SIRAJ Personal Islamic Life Companion (§9, §10, §22).
class CompanionModule {
  final CompanionUserDataStore _userDataStore;
  final GoalEngine _goalEngine;
  final ReminderOrchestrator _reminderOrchestrator;
  final PersonalPriorityEngine _priorityEngine;
  final SearchFederationService _searchService;

  final PrayerModule? _prayerModule;
  final QuranModule? _quranModule;
  final MemorizationModule? _memorizationModule;
  final AdhkarModule? _adhkarModule;
  final ZakatModule? _zakatModule;
  final FastingModule? _fastingModule;
  final KnowledgeModule? _knowledgeModule;
  final LearningModule? _learningModule;
  final SeerahModule? _seerahModule;
  final HajjModule? _hajjModule;

  CompanionModule({
    required StorageRegistry storageRegistry,
    PrayerModule? prayerModule,
    QuranModule? quranModule,
    MemorizationModule? memorizationModule,
    AdhkarModule? adhkarModule,
    ZakatModule? zakatModule,
    FastingModule? fastingModule,
    KnowledgeModule? knowledgeModule,
    LearningModule? learningModule,
    SeerahModule? seerahModule,
    HajjModule? hajjModule,
    CognitiveLoadGuard? cognitiveLoadGuard,
  })  : _prayerModule = prayerModule,
        _quranModule = quranModule,
        _memorizationModule = memorizationModule,
        _adhkarModule = adhkarModule,
        _zakatModule = zakatModule,
        _fastingModule = fastingModule,
        _knowledgeModule = knowledgeModule,
        _learningModule = learningModule,
        _seerahModule = seerahModule,
        _hajjModule = hajjModule,
        _userDataStore = CompanionUserDataStore(registry: storageRegistry),
        _goalEngine = GoalEngine(store: CompanionUserDataStore(registry: storageRegistry)),
        _reminderOrchestrator = const ReminderOrchestrator(),
        _priorityEngine = PersonalPriorityEngine(loadGuard: cognitiveLoadGuard ?? const CognitiveLoadGuard()),
        _searchService = SearchFederationService(
          quranModule: quranModule,
          adhkarModule: adhkarModule,
          knowledgeModule: knowledgeModule,
          learningModule: learningModule,
          seerahModule: seerahModule,
          hajjModule: hajjModule,
        );

  CompanionUserDataStore get userDataStore => _userDataStore;
  GoalEngine get goalEngine => _goalEngine;
  SearchFederationService get searchService => _searchService;

  /// Gathers minimal aggregate status summaries across all 10 modules (§22, §23, §49).
  Future<List<ModuleStatusSummary>> getModuleStatuses() async {
    final now = DateTime.now();
    final summaries = <ModuleStatusSummary>[];

    // M1: Prayer
    if (_prayerModule != null) {
      String progress = 'المواقيت محددة فلكياً وجغرافياً';
      try {
        final scheduleRes = await _prayerModule.getSchedule(
          date: now,
          location: const GeoCoordinates(
            latitude: 24.7136,
            longitude: 46.6753,
            source: LocationSource.manual,
          ),
          parameters: CalculationParameters.muslimWorldLeague,
        );

        if (scheduleRes.isSuccess && scheduleRes.valueOrNull != null) {
          final sched = scheduleRes.valueOrNull!;
          final next = _prayerModule.scheduleService.getNextPrayer(
            currentTime: now,
            todaySchedule: sched,
          );
          final current = _prayerModule.scheduleService.getCurrentPrayer(
            currentTime: now,
            todaySchedule: sched,
          );
          final countdown = _prayerModule.countdownService.getCountdownState(
            time: now,
            todaySchedule: sched,
          );

          if (next != null) {
            if (current != null) {
              progress = 'الحالية: ${current.type.nameArabic} • القادمة: ${next.type.nameArabic} (${countdown.formattedTimer})';
            } else {
              progress = 'الصلاة القادمة: ${next.type.nameArabic} (متبقي ${countdown.formattedTimer})';
            }
          }
        }
      } catch (_) {
        progress = 'مواقيت الصلاة محددة بدقة';
      }

      summaries.add(ModuleStatusSummary(
        moduleId: 'prayer',
        moduleTitleArabic: 'مواقيت الصلاة والقبلة',
        status: ModuleAvailabilityStatus.available,
        progressSummary: progress,
        timestamp: now,
      ));
    } else {
      summaries.add(ModuleStatusSummary(
        moduleId: 'prayer',
        moduleTitleArabic: 'مواقيت الصلاة والقبلة',
        status: ModuleAvailabilityStatus.notConfigured,
        timestamp: now,
      ));
    }

    // M2: Quran
    if (_quranModule != null && _quranModule.store.isMounted) {
      String quranProgress = 'المصحف الكنسي برواية حفص متاح';
      try {
        final progressRes = await _quranModule.getReadingProgress();
        if (progressRes.isSuccess && progressRes.valueOrNull != null) {
          final p = progressRes.valueOrNull!;
          quranProgress = 'آخر موضع: سورة ${p.surahNameArabic} (الآية ${p.lastReadAyah} • ص ${p.lastReadPage})';
        }
      } catch (_) {}

      summaries.add(ModuleStatusSummary(
        moduleId: 'quran',
        moduleTitleArabic: 'المصحف الشريف',
        status: ModuleAvailabilityStatus.available,
        progressSummary: quranProgress,
        timestamp: now,
      ));
    } else {
      summaries.add(ModuleStatusSummary(
        moduleId: 'quran',
        moduleTitleArabic: 'المصحف الشريف',
        status: ModuleAvailabilityStatus.offline,
        timestamp: now,
      ));
    }

    // M3: Memorization
    if (_memorizationModule != null) {
      final snapRes = await _memorizationModule.getMasterySnapshot();
      final streakRes = await _memorizationModule.getConsistencyStreak();
      summaries.add(ModuleStatusSummary(
        moduleId: 'memorization',
        moduleTitleArabic: 'حفظ ومراجعة القرآن',
        status: ModuleAvailabilityStatus.available,
        dueCount: snapRes.isSuccess ? snapRes.valueOrNull!.needsReviewCount : 0,
        progressSummary: streakRes.isSuccess
            ? 'سلسلة الاستمرارية: ${streakRes.valueOrNull} أيام'
            : 'برنامج الحفظ والمراجعة متاح',
        timestamp: now,
      ));
    }

    // M4: Adhkar
    if (_adhkarModule != null && _adhkarModule.store.isMounted) {
      final occ = _adhkarModule.getCurrentOccasion();
      summaries.add(ModuleStatusSummary(
        moduleId: 'adhkar',
        moduleTitleArabic: 'الأذكار والأدعية',
        status: ModuleAvailabilityStatus.available,
        progressSummary: 'المناسبة الحالية: ${occ.labelArabic}',
        timestamp: now,
      ));
    }

    // M5: Zakat
    if (_zakatModule != null) {
      summaries.add(ModuleStatusSummary(
        moduleId: 'zakat',
        moduleTitleArabic: 'حساب الزكاة',
        status: ModuleAvailabilityStatus.available,
        progressSummary: 'حاسبة الزكاة والحول متاحة محلياً',
        timestamp: now,
      ));
    }

    // M6: Fasting
    if (_fastingModule != null) {
      summaries.add(ModuleStatusSummary(
        moduleId: 'fasting',
        moduleTitleArabic: 'الصيام وقضاء رمضان',
        status: ModuleAvailabilityStatus.available,
        progressSummary: 'سجل الصيام والتذكير متاح',
        timestamp: now,
      ));
    }

    // M7: Knowledge
    if (_knowledgeModule != null && _knowledgeModule.store.isMounted) {
      summaries.add(ModuleStatusSummary(
        moduleId: 'knowledge',
        moduleTitleArabic: 'المعرفة والحديث والفقه',
        status: ModuleAvailabilityStatus.available,
        timestamp: now,
      ));
    }

    // M8: Learning
    if (_learningModule != null && _learningModule.store.isMounted) {
      summaries.add(ModuleStatusSummary(
        moduleId: 'learning',
        moduleTitleArabic: 'المناهج والمسارات',
        status: ModuleAvailabilityStatus.available,
        timestamp: now,
      ));
    }

    // M9: Seerah
    if (_seerahModule != null && _seerahModule.store.isMounted) {
      summaries.add(ModuleStatusSummary(
        moduleId: 'seerah',
        moduleTitleArabic: 'السيرة النبوية والتاريخ',
        status: ModuleAvailabilityStatus.available,
        timestamp: now,
      ));
    }

    // M10: Hajj
    if (_hajjModule != null && _hajjModule.store.isMounted) {
      final hajjProgRes = await _hajjModule.getUserProgress();
      final hasActive = hajjProgRes.isSuccess &&
          hajjProgRes.valueOrNull!.completedStepIds.isNotEmpty;
      summaries.add(ModuleStatusSummary(
        moduleId: 'hajj',
        moduleTitleArabic: 'الحج والعمرة',
        status: ModuleAvailabilityStatus.available,
        dueCount: hasActive ? 1 : 0,
        progressSummary: hasActive ? 'رحلة نسك جارية' : 'دليل المناسك متاح',
        timestamp: now,
      ));
    }

    return List.unmodifiable(summaries);
  }

  /// Builds the prioritized contextual dashboard cards (§4, §10, §47).
  Future<Result<List<DashboardCard>, Failure>> getDashboardCards({DateTime? currentTime}) async {
    final time = currentTime ?? DateTime.now();
    final prefsRes = await _userDataStore.getPreferences();
    final prefs = prefsRes.isSuccess ? prefsRes.valueOrNull! : const CompanionPreferences();

    final goalsRes = await _goalEngine.getActiveGoals();
    final goals = goalsRes.isSuccess ? goalsRes.valueOrNull! : const <PersonalGoal>[];

    final statuses = await getModuleStatuses();

    final cards = _priorityEngine.buildDashboard(
      moduleStatuses: statuses,
      activeGoals: goals,
      preferences: prefs,
      currentTime: time,
    );

    return Result.ok(cards);
  }

  /// Generates the customizable daily journey routine (§7, §30).
  DailyJourneyRoutine getDailyJourneyRoutine({DateTime? date}) {
    final d = date ?? DateTime.now();
    final slots = [
      const DailyJourneySlot(
        slotId: 'slot_fajr',
        timeSlot: JourneyTimeSlot.fajrDawn,
        titleArabic: 'صلاة الفجر وقرآن الفجر',
        description: 'أداء صلاة الفجر في وقتها والاستماع أو تلاوة الورد.',
        primaryActionTitle: 'المواقيت',
        targetRoute: '/prayer',
      ),
      const DailyJourneySlot(
        slotId: 'slot_morning_adhkar',
        timeSlot: JourneyTimeSlot.morning,
        titleArabic: 'أذكار الصباح وسنة الضحى',
        description: 'التحصن بأذكار الصباح المأثورة وصلاة الضحى.',
        primaryActionTitle: 'فتح الأذكار',
        targetRoute: '/adhkar',
      ),
      const DailyJourneySlot(
        slotId: 'slot_dhuhr',
        timeSlot: JourneyTimeSlot.dhuhrNoon,
        titleArabic: 'صلاة الظهر ومراجعة الحفظ',
        description: 'أداء صلاة الظهر ومراجعة الأوجه المحفوظة.',
        primaryActionTitle: 'المراجعة',
        targetRoute: '/memorization',
      ),
      const DailyJourneySlot(
        slotId: 'slot_asr_evening',
        timeSlot: JourneyTimeSlot.asrAfternoon,
        titleArabic: 'صلاة العصر وأذكار المساء',
        description: 'أداء صلاة العصر وقراءة أذكار المساء المأثورة.',
        primaryActionTitle: 'أذكار المساء',
        targetRoute: '/adhkar',
      ),
      const DailyJourneySlot(
        slotId: 'slot_maghrib_learning',
        timeSlot: JourneyTimeSlot.maghribSunset,
        titleArabic: 'صلاة المغرب ودرس في السيرة والمناهج',
        description: 'أداء المغرب وتخصيص وقت يسير للتفقه في الدين.',
        primaryActionTitle: 'السيرة النبوية',
        targetRoute: '/seerah',
      ),
      const DailyJourneySlot(
        slotId: 'slot_isha_sleep',
        timeSlot: JourneyTimeSlot.sleepNight,
        titleArabic: 'صلاة العشاء والوتر وأذكار النوم',
        description: 'ختام اليوم بصلاة العشاء والوتر وأذكار النوم المأثورة.',
        primaryActionTitle: 'أذكار النوم',
        targetRoute: '/adhkar',
      ),
    ];

    return DailyJourneyRoutine(
      routineId: 'routine_daily_${d.year}_${d.month}_${d.day}',
      nameArabic: 'الروتين اليومي المتوازن',
      slots: slots,
      date: d,
    );
  }

  /// Evaluates and processes all daily reminders (§27, §28).
  Future<Result<List<CompanionReminder>, Failure>> getReminders({DateTime? currentTime}) async {
    final time = currentTime ?? DateTime.now();
    final prefsRes = await _userDataStore.getPreferences();
    final prefs = prefsRes.isSuccess ? prefsRes.valueOrNull! : const CompanionPreferences();

    final raw = <CompanionReminder>[
      CompanionReminder(
        reminderId: 'rem_fajr',
        sourceModule: 'prayer',
        titleArabic: 'صلاة الفجر',
        messageArabic: 'حان وقت أداء صلاة الفجر',
        scheduledTime: DateTime(time.year, time.month, time.day, 5, 0),
        priority: ReminderPriority.high,
        targetRoute: '/prayer',
      ),
      CompanionReminder(
        reminderId: 'rem_morning_adhkar',
        sourceModule: 'adhkar',
        titleArabic: 'أذكار الصباح',
        messageArabic: 'وقت مناسب لقراءة أذكار الصباح المأثورة',
        scheduledTime: DateTime(time.year, time.month, time.day, 6, 30),
        priority: ReminderPriority.medium,
        targetRoute: '/adhkar',
      ),
      CompanionReminder(
        reminderId: 'rem_quran_reading',
        sourceModule: 'quran',
        titleArabic: 'الورد القرآني اليومي',
        messageArabic: 'تلاوة وردك القرآني اليومي',
        scheduledTime: DateTime(time.year, time.month, time.day, 16, 0),
        priority: ReminderPriority.medium,
        targetRoute: '/quran',
      ),
    ];

    final processed = _reminderOrchestrator.processReminders(
      rawReminders: raw,
      preferences: prefs,
      currentTime: time,
    );

    return Result.ok(processed);
  }

  Future<Result<List<PersonalGoal>, Failure>> getGoals() => _goalEngine.getActiveGoals();
  Future<Result<PersonalGoal, Failure>> addGoal(PersonalGoal goal) => _goalEngine.addGoal(goal);
  Future<Result<PersonalGoal, Failure>> updateGoalProgress(String goalId, double increment) =>
      _goalEngine.updateProgress(goalId, increment);
  Future<Result<PersonalGoal, Failure>> setGoalStatus(String goalId, GoalStatus status) =>
      _goalEngine.setGoalStatus(goalId, status);
  Future<Result<void, Failure>> deleteGoal(String goalId) => _goalEngine.deleteGoal(goalId);

  Future<Result<List<PersonalHabit>, Failure>> getHabits() => _userDataStore.getHabits();
  Future<Result<void, Failure>> saveHabits(List<PersonalHabit> habits) =>
      _userDataStore.saveHabits(habits);

  Future<Result<CompanionPreferences, Failure>> getPreferences() =>
      _userDataStore.getPreferences();
  Future<Result<void, Failure>> savePreferences(CompanionPreferences prefs) =>
      _userDataStore.savePreferences(prefs);

  Future<Result<List<FederatedSearchResult>, Failure>> search(String query) =>
      _searchService.search(query);

  Future<Result<void, Failure>> resetAllUserData() => _userDataStore.resetAllUserData();
}
