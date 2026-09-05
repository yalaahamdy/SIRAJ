import 'package:flutter/material.dart';
import '../../core/errors/app_failure.dart';
import '../../core/errors/result.dart';
import '../../core/i18n/app_strings.dart';
import '../../core/storage/memory_storage.dart';
import '../../modules/adhkar/adhkar_module.dart';
import '../../modules/adhkar/domain/dhikr_occasion.dart';
import '../../modules/ai/ai_module.dart';
import '../../modules/companion/companion_module.dart';
import '../../modules/fasting/fasting_module.dart';
import '../../modules/hajj/hajj_module.dart';
import '../../modules/knowledge/knowledge_module.dart';
import '../../modules/learning/learning_module.dart';
import '../../modules/memorization/memorization_module.dart';
import '../../modules/prayer/prayer_module.dart';
import '../../modules/quran/domain/ayah_key.dart';
import '../../modules/quran/quran_module.dart';
import '../../modules/seerah/seerah_module.dart';
import '../../modules/zakat/zakat_module.dart';
import '../adhkar/adhkar_home_screen.dart';
import '../adhkar/dhikr_detail_screen.dart';
import '../adhkar/occasion_adhkar_screen.dart';
import '../ai/ai_search_query_screen.dart';
import '../companion/home_dashboard_view.dart';
import '../fasting/fasting_calendar_screen.dart';
import '../fasting/fasting_dashboard_screen.dart';
import '../fasting/fasting_settings_screen.dart';
import '../fasting/qada_planner_screen.dart';
import '../../modules/knowledge/domain/fiqh_topic.dart';
import '../../modules/knowledge/domain/hadith_entity.dart';
import '../../modules/learning/domain/learning_path.dart' as lp;
import '../../modules/learning/domain/lesson.dart';
import '../../modules/learning/domain/quiz.dart';
import '../../modules/hajj/domain/journey_type.dart';
import '../../modules/hajj/domain/ritual_step.dart';
import '../hajj/hajj_home_screen.dart';
import '../hajj/journey_dashboard_screen.dart';
import '../hajj/miqat_guide_screen.dart';
import '../hajj/preparation_checklist_screen.dart';
import '../hajj/ritual_step_detail_screen.dart';
import '../hajj/sacred_locations_screen.dart';
import '../knowledge/fiqh_topic_screen.dart';
import '../knowledge/hadith_book_browser_screen.dart';
import '../knowledge/hadith_detail_screen.dart';
import '../knowledge/knowledge_favorites_screen.dart';
import '../knowledge/knowledge_home_screen.dart';
import '../knowledge/knowledge_search_screen.dart';
import '../seed/default_canonical_seed_provider.dart';
import '../learning/learning_goals_screen.dart';
import '../learning/learning_home_screen.dart';
import '../learning/learning_path_screen.dart';
import '../learning/lesson_screen.dart';
import '../learning/quiz_screen.dart';
import '../memorization/memorization_dashboard_screen.dart';
import '../memorization/plan_setup_screen.dart';
import '../memorization/study_session_screen.dart';
import '../prayer/prayer_screen.dart';
import '../quran/quran_reader_screen.dart';
import '../quran/surah_list_screen.dart';
import '../../modules/seerah/domain/historical_person.dart';
import '../../modules/seerah/domain/historical_place.dart';
import '../../modules/seerah/domain/seerah_event.dart';
import '../seerah/event_detail_screen.dart';
import '../seerah/person_detail_screen.dart';
import '../seerah/place_detail_screen.dart';
import '../seerah/seerah_home_screen.dart';
import '../seerah/timeline_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../v1_app_shell.dart';
import '../widgets/state_views.dart';
import '../../modules/zakat/domain/zakat_calculation_result.dart';
import '../zakat/asset_entry_screen.dart';
import '../zakat/zakat_breakdown_screen.dart';
import '../zakat/zakat_calculator_workflow_screen.dart';
import '../zakat/zakat_dashboard_screen.dart';
import '../zakat/zakat_history_screen.dart';
import '../zakat/zakat_policy_screen.dart';
import '../zakat/zakat_settings_screen.dart';

/// Minimal, modular routing foundation for App Shell.
class AppRouter {
  static const String home = '/';
  static const String companion = '/companion';
  static const String aiRetrieval = '/ai-retrieval';
  static const String prayer = '/prayer';
  static const String quran = '/quran';
  static const String quranReader = '/quran/reader';
  static const String memorization = '/memorization';
  static const String memorizationSession = '/memorization/session';
  static const String memorizationPlan = '/memorization/plan';
  static const String adhkar = '/adhkar';
  static const String zakat = '/zakat';
  static const String zakatAssets = '/zakat/assets';
  static const String zakatBreakdown = '/zakat/breakdown';
  static const String zakatPolicy = '/zakat/policy';
  static const String zakatSettings = '/zakat/settings';
  static const String zakatCalculator = '/zakat/calculator';
  static const String zakatHistory = '/zakat/history';
  static const String fasting = '/fasting';
  static const String fastingCalendar = '/fasting/calendar';
  static const String fastingQada = '/fasting/qada';
  static const String fastingSettings = '/fasting/settings';
  static const String knowledge = '/knowledge';
  static const String knowledgeHadith = '/knowledge/hadith';
  static const String knowledgeFiqh = '/knowledge/fiqh';
  static const String knowledgeSearch = '/knowledge/search';
  static const String knowledgeBooks = '/knowledge/books';
  static const String knowledgeFavorites = '/knowledge/favorites';
  static const String learning = '/learning';
  static const String learningPath = '/learning/path';
  static const String learningLesson = '/learning/lesson';
  static const String learningQuiz = '/learning/quiz';
  static const String learningGoals = '/learning/goals';
  static const String seerah = '/seerah';
  static const String seerahTimeline = '/seerah/timeline';
  static const String seerahEvent = '/seerah/event';
  static const String seerahPerson = '/seerah/person';
  static const String seerahPlace = '/seerah/place';
  static const String hajj = '/hajj';
  static const String hajjJourney = '/hajj/journey';
  static const String hajjUmrah = '/hajj/umrah';
  static const String hajjStep = '/hajj/step';
  static const String hajjMiqat = '/hajj/miqat';
  static const String hajjLocations = '/hajj/locations';
  static const String hajjPreparation = '/hajj/preparation';
  static const String settings = '/settings';
  static QuranModule? defaultQuranModule;
  static AdhkarModule? defaultAdhkarModule;
  static MemorizationModule? defaultMemorizationModule;
  static FastingModule? defaultFastingModule;
  static KnowledgeModule? defaultKnowledgeModule;
  static LearningModule? defaultLearningModule;
  static SeerahModule? defaultSeerahModule;
  static HajjModule? defaultHajjModule;
  static ZakatModule? defaultZakatModule;

  /// Ensures a seeded, non-empty KnowledgeModule is always returned (§20, M05.1).
  static KnowledgeModule getOrSeedKnowledgeModule([KnowledgeModule? explicitModule]) {
    if (explicitModule != null) return explicitModule;
    if (defaultKnowledgeModule != null) return defaultKnowledgeModule!;
    final registry = MemoryStorageRegistry();
    final mod = KnowledgeModule(storageRegistry: registry);
    final pkg = DefaultCanonicalSeedProvider.getKnowledgeSeedPackage();
    mod.mountPackage(pkg);
    defaultKnowledgeModule = mod;
    return mod;
  }

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final name = routeSettings.name ?? '';

    // Handle Quran deep links like /quran/2:255 or /quran/18 (§63, §64)
    if (name.startsWith('/quran/') && name != quranReader) {
      final sub = name.substring('/quran/'.length);
      final quranMod = defaultQuranModule ?? QuranModule(storageRegistry: MemoryStorageRegistry());

      if (sub.contains(':')) {
        final parts = sub.split(':');
        final surah = int.tryParse(parts[0]);
        final ayah = int.tryParse(parts[1]);

        if (surah != null && surah >= 1 && surah <= 114 && ayah != null && ayah >= 1) {
          final surahRes = quranMod.getSurah(surah);
          if (surahRes.isSuccess && ayah <= surahRes.valueOrNull!.ayahCount) {
            return MaterialPageRoute(
              builder: (_) => QuranReaderScreen(
                quranModule: quranMod,
                initialSurahNumber: surah,
                initialAyahNumber: ayah,
              ),
              settings: routeSettings,
            );
          }
        }
      } else {
        final surah = int.tryParse(sub);
        if (surah != null && surah >= 1 && surah <= 114) {
          return MaterialPageRoute(
            builder: (_) => QuranReaderScreen(
              quranModule: quranMod,
              initialSurahNumber: surah,
            ),
            settings: routeSettings,
          );
        }
      }

      // Safe error fallback for invalid deep link (§64)
      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط القرآني المطلوب غير صالح أو يتجاوز عدد آيات السورة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Adhkar deep links like /adhkar/occasion/morning or /adhkar/{id} (§39, §40)
    if (name.startsWith('/adhkar/') && name != adhkar) {
      final sub = name.substring('/adhkar/'.length);
      final adhkarMod = defaultAdhkarModule ?? AdhkarModule(storageRegistry: MemoryStorageRegistry());

      if (sub == 'search' || sub == 'favorites') {
        return MaterialPageRoute(
          builder: (_) => AdhkarHomeScreen(module: adhkarMod),
          settings: routeSettings,
        );
      }

      if (sub.startsWith('occasion/')) {
        final occName = sub.substring('occasion/'.length).toLowerCase();
        final matchedOccasion = DhikrOccasion.values.cast<DhikrOccasion?>().firstWhere(
              (o) => o?.name.toLowerCase() == occName || o?.labelArabic == occName,
              orElse: () => null,
            );
        if (matchedOccasion != null) {
          return MaterialPageRoute(
            builder: (_) => OccasionAdhkarScreen(occasion: matchedOccasion, module: adhkarMod),
            settings: routeSettings,
          );
        }
      } else {
        final itemRes = adhkarMod.getItemById(sub);
        if (itemRes.isSuccess && itemRes.valueOrNull != null) {
          return MaterialPageRoute(
            builder: (_) => DhikrDetailScreen(item: itemRes.valueOrNull!, module: adhkarMod),
            settings: routeSettings,
          );
        }
      }

      // Safe error fallback for invalid Adhkar deep link (§40)
      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب للأذكار غير صالح أو لا يتطابق مع أي باب مأثور.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للأذكار'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Memorization deep links like /memorization/session, /memorization/plan, /memorization/progress, /memorization/item/{surah}:{ayah} (§18, §19)
    if (name.startsWith('/memorization/')) {
      final registry = MemoryStorageRegistry();
      final quranMod = defaultQuranModule ?? QuranModule(storageRegistry: registry);
      final memMod = defaultMemorizationModule ??
          MemorizationModule(
            storageRegistry: registry,
            quranStore: quranMod.store,
          );

      if (name == memorizationSession) {
        return MaterialPageRoute(
          builder: (ctx) => StudySessionScreen(
            memorizationModule: memMod,
            onFinish: () => Navigator.pop(ctx),
          ),
          settings: routeSettings,
        );
      }

      if (name == memorizationPlan) {
        return MaterialPageRoute(
          builder: (ctx) => PlanSetupScreen(
            memorizationModule: memMod,
            onSaved: () => Navigator.pop(ctx),
          ),
          settings: routeSettings,
        );
      }

      if (name == '/memorization/progress') {
        return MaterialPageRoute(
          builder: (ctx) => MemorizationDashboardScreen(
            memorizationModule: memMod,
            onStartSession: () => Navigator.pushNamed(ctx, memorizationSession),
            onOpenPlanSetup: () => Navigator.pushNamed(ctx, memorizationPlan),
          ),
          settings: routeSettings,
        );
      }

      if (name.startsWith('/memorization/item/')) {
        final sub = name.substring('/memorization/item/'.length).trim();
        if (sub.contains(':')) {
          final parts = sub.split(':');
          final surah = int.tryParse(parts[0]);
          final ayah = int.tryParse(parts[1]);
          if (surah != null && surah >= 1 && surah <= 114 && ayah != null && ayah >= 1) {
            final ayahKey = AyahKey(surahNumber: surah, ayahNumber: ayah);
            return MaterialPageRoute(
              builder: (ctx) => PlanSetupScreen(
                memorizationModule: memMod,
                onSaved: () => Navigator.pop(ctx),
                initialTargetAyahKey: ayahKey,
              ),
              settings: routeSettings,
            );
          }
        }
      }

      // Safe error fallback for invalid Memorization deep link (§19)
      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب لبرنامج الحفظ والمراجعة غير صالح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للحفظ والمراجعة'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Fasting deep links (§40, §41)
    if (name.startsWith('/fasting/') && name != fastingCalendar && name != fastingQada && name != fastingSettings) {
      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب لبرنامج الصيام ورمضان غير صالح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للصيام ورمضان'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Knowledge deep links (§89, §90)
    if (name.startsWith('/knowledge/') &&
        name != knowledgeHadith &&
        name != knowledgeFiqh &&
        name != knowledgeSearch &&
        name != knowledgeBooks &&
        name != knowledgeFavorites) {
      final knowMod = getOrSeedKnowledgeModule();
      final sub = name.substring('/knowledge/'.length);

      if (sub.startsWith('hadith/')) {
        final hadithId = sub.substring('hadith/'.length);
        final hadithRes = knowMod.getHadith(hadithId);
        if (hadithRes.isSuccess) {
          return MaterialPageRoute(
            builder: (_) => HadithDetailScreen(
              hadith: hadithRes.valueOrNull!,
              module: knowMod,
            ),
            settings: routeSettings,
          );
        }
      } else if (sub.startsWith('fiqh/')) {
        final topicId = sub.substring('fiqh/'.length);
        final topicRes = knowMod.getFiqhTopic(topicId);
        if (topicRes.isSuccess) {
          return MaterialPageRoute(
            builder: (_) => FiqhTopicScreen(
              topic: topicRes.valueOrNull!,
              module: knowMod,
            ),
            settings: routeSettings,
          );
        }
      } else if (sub.startsWith('books/')) {
        final colId = sub.substring('books/'.length).trim();
        return MaterialPageRoute(
          builder: (_) => HadithBookBrowserScreen(
            module: knowMod,
            initialCollectionId: colId.isEmpty ? null : colId,
          ),
          settings: routeSettings,
        );
      }

      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب لمنصة المعرفة والحديث غير صالح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للمعارف'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Learning deep links (§89, §90)
    if (name.startsWith('/learning/') &&
        name != learningPath &&
        name != learningLesson &&
        name != learningQuiz &&
        name != learningGoals) {
      final learnMod = defaultLearningModule ?? LearningModule(storageRegistry: MemoryStorageRegistry());
      final sub = name.substring('/learning/'.length);

      if (sub.startsWith('path/')) {
        final pathId = sub.substring('path/'.length);
        final pathRes = learnMod.getPath(pathId);
        if (pathRes.isSuccess) {
          return MaterialPageRoute(
            builder: (_) => LearningPathScreen(
              path: pathRes.valueOrNull!,
              module: learnMod,
            ),
            settings: routeSettings,
          );
        }
      } else if (sub.startsWith('lesson/')) {
        final lessonId = sub.substring('lesson/'.length);
        final lessonRes = learnMod.getLesson(lessonId);
        if (lessonRes.isSuccess) {
          return MaterialPageRoute(
            builder: (_) => LessonScreen(
              lesson: lessonRes.valueOrNull!,
              module: learnMod,
            ),
            settings: routeSettings,
          );
        }
      } else if (sub.startsWith('quiz/')) {
        final quizId = sub.substring('quiz/'.length);
        final quizRes = learnMod.store.getQuiz(quizId);
        if (quizRes.isSuccess) {
          return MaterialPageRoute(
            builder: (_) => QuizScreen(
              quiz: quizRes.valueOrNull!,
              module: learnMod,
            ),
            settings: routeSettings,
          );
        }
      }

      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب للمنصة والمناهج التعليمية غير صالح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للمناهج'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Seerah deep links like /seerah/timeline, /seerah/event/{id}, /seerah/person/{id}, /seerah/place/{id} (§57, §58)
    if (name.startsWith('/seerah/')) {
      final registry = MemoryStorageRegistry();
      final seerahMod = defaultSeerahModule ?? SeerahModule(storageRegistry: registry);

      if (name == seerahTimeline) {
        return MaterialPageRoute(
          builder: (_) => TimelineScreen(module: seerahMod),
          settings: routeSettings,
        );
      }

      if (name.startsWith('/seerah/event/')) {
        final evId = name.substring('/seerah/event/'.length).trim();
        if (evId.isNotEmpty) {
          final evRes = seerahMod.getEvent(evId);
          if (evRes.isSuccess) {
            return MaterialPageRoute(
              builder: (_) => EventDetailScreen(event: evRes.valueOrNull!, module: seerahMod),
              settings: routeSettings,
            );
          }
        }
      } else if (name.startsWith('/seerah/person/')) {
        final pId = name.substring('/seerah/person/'.length).trim();
        if (pId.isNotEmpty) {
          final pRes = seerahMod.getPerson(pId);
          if (pRes.isSuccess) {
            return MaterialPageRoute(
              builder: (_) => PersonDetailScreen(person: pRes.valueOrNull!, module: seerahMod),
              settings: routeSettings,
            );
          }
        }
      } else if (name.startsWith('/seerah/place/')) {
        final plId = name.substring('/seerah/place/'.length).trim();
        if (plId.isNotEmpty) {
          final plRes = seerahMod.getPlace(plId);
          if (plRes.isSuccess) {
            return MaterialPageRoute(
              builder: (_) => PlaceDetailScreen(place: plRes.valueOrNull!),
              settings: routeSettings,
            );
          }
        }
      }

      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب للسيرة والتاريخ الإسلامي غير صالح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للسيرة'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Hajj & Umrah deep links like /hajj/journey, /hajj/umrah, /hajj/step/{id}, /hajj/miqat, /hajj/locations, /hajj/preparation (§53, §54)
    if (name.startsWith('/hajj/')) {
      final registry = MemoryStorageRegistry();
      final hajjMod = defaultHajjModule ?? HajjModule(storageRegistry: registry);

      if (name == hajjJourney) {
        return MaterialPageRoute(
          builder: (_) => JourneyDashboardScreen(module: hajjMod, journeyType: JourneyType.hajjTamattu),
          settings: routeSettings,
        );
      }

      if (name == hajjUmrah) {
        return MaterialPageRoute(
          builder: (_) => JourneyDashboardScreen(module: hajjMod, journeyType: JourneyType.umrah),
          settings: routeSettings,
        );
      }

      if (name == hajjMiqat) {
        return MaterialPageRoute(
          builder: (_) => MiqatGuideScreen(module: hajjMod),
          settings: routeSettings,
        );
      }

      if (name == hajjLocations) {
        return MaterialPageRoute(
          builder: (_) => SacredLocationsScreen(module: hajjMod),
          settings: routeSettings,
        );
      }

      if (name == hajjPreparation) {
        return MaterialPageRoute(
          builder: (_) => PreparationChecklistScreen(module: hajjMod),
          settings: routeSettings,
        );
      }

      if (name.startsWith('/hajj/step/')) {
        final stepId = name.substring('/hajj/step/'.length).trim();
        if (stepId.isNotEmpty) {
          final stepRes = hajjMod.getStep(stepId);
          if (stepRes.isSuccess) {
            return MaterialPageRoute(
              builder: (_) => RitualStepDetailScreen(step: stepRes.valueOrNull!, module: hajjMod),
              settings: routeSettings,
            );
          }
        }
      }

      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب للحج والعمرة غير صالح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للحج والعمرة'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    // Handle Zakat deep links like /zakat/assets, /zakat/breakdown, /zakat/policy (§70, §71)
    if (name.startsWith('/zakat/')) {
      final registry = MemoryStorageRegistry();
      final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);

      if (name == zakatAssets) {
        return MaterialPageRoute(
          builder: (_) => AssetEntryScreen(module: zakatMod),
          settings: routeSettings,
        );
      }

      if (name == zakatPolicy) {
        return MaterialPageRoute(
          builder: (_) => ZakatPolicyScreen(module: zakatMod),
          settings: routeSettings,
        );
      }

      if (name == zakatBreakdown) {
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<Result<ZakatCalculationResult, Failure>>(
            future: zakatMod.calculateZakat(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isFailure) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              return ZakatBreakdownScreen(
                result: snapshot.data!.valueOrNull!,
                module: zakatMod,
              );
            },
          ),
          settings: routeSettings,
        );
      }

      if (name == zakatSettings) {
        return MaterialPageRoute(
          builder: (_) => ZakatSettingsScreen(module: zakatMod),
          settings: routeSettings,
        );
      }

      if (name == zakatCalculator) {
        return MaterialPageRoute(
          builder: (_) => ZakatCalculatorWorkflowScreen(module: zakatMod),
          settings: routeSettings,
        );
      }

      if (name == zakatHistory) {
        return MaterialPageRoute(
          builder: (_) => ZakatHistoryScreen(module: zakatMod),
          settings: routeSettings,
        );
      }

      // Safe error fallback for invalid Zakat deep link (§71)
      return MaterialPageRoute(
        builder: (ctx) => Scaffold(
          appBar: AppBar(title: const Text('رابط غير صالح')),
          body: Center(
            child: Padding(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 56, color: AppColors.error),
                  const SizedBox(height: AppSpacing.m),
                  const Text(
                    'الرابط المطلوب لحساب الزكاة غير صالح.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('العودة للزكاة'),
                  ),
                ],
              ),
            ),
          ),
        ),
        settings: routeSettings,
      );
    }

    switch (routeSettings.name) {
      case home:
        final args = routeSettings.arguments;
        final initialIndex = (args is Map && args['tab'] is int) ? args['tab'] as int : 0;
        return MaterialPageRoute(
          builder: (_) => V1AppShell(initialIndex: initialIndex),
          settings: routeSettings,
        );
      case companion:
        final registry = MemoryStorageRegistry();
        final companionMod = CompanionModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => HomeDashboardView(module: companionMod),
          settings: routeSettings,
        );
      case prayer:
        final registry = MemoryStorageRegistry();
        final prayerMod = PrayerModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => PrayerScreen(prayerModule: prayerMod),
          settings: routeSettings,
        );
      case quran:
        final quranMod = defaultQuranModule ?? QuranModule(storageRegistry: MemoryStorageRegistry());
        return MaterialPageRoute(
          builder: (ctx) => SurahListScreen(
            quranModule: quranMod,
            onOpenSurah: (surahNum, {targetPage, targetAyah}) {
              Navigator.pushNamed(
                ctx,
                quranReader,
                arguments: {
                  'surah_number': surahNum,
                  'page_number': targetPage,
                  'ayah_number': targetAyah,
                  'module': quranMod,
                },
              );
            },
          ),
          settings: routeSettings,
        );
      case quranReader:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final quranMod = args['module'] as QuranModule? ?? defaultQuranModule ?? QuranModule(storageRegistry: MemoryStorageRegistry());
        final surahNum = args['surah_number'] as int? ?? 1;
        final pageNum = args['page_number'] as int?;
        final ayahNum = args['ayah_number'] as int?;

        return MaterialPageRoute(
          builder: (_) => QuranReaderScreen(
            quranModule: quranMod,
            initialSurahNumber: surahNum,
            initialPageNumber: pageNum,
            initialAyahNumber: ayahNum,
          ),
          settings: routeSettings,
        );
      case memorization:
        final registry = MemoryStorageRegistry();
        final quranMod = defaultQuranModule ?? QuranModule(storageRegistry: registry);
        final memMod = defaultMemorizationModule ??
            MemorizationModule(
              storageRegistry: registry,
              quranStore: quranMod.store,
            );
        return MaterialPageRoute(
          builder: (ctx) => MemorizationDashboardScreen(
            memorizationModule: memMod,
            onStartSession: () => Navigator.pushNamed(
              ctx,
              memorizationSession,
              arguments: {'module': memMod},
            ),
            onOpenPlanSetup: () => Navigator.pushNamed(
              ctx,
              memorizationPlan,
              arguments: {'module': memMod},
            ),
          ),
          settings: routeSettings,
        );
      case memorizationSession:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final quranMod = defaultQuranModule ?? QuranModule(storageRegistry: registry);
        final memMod = args['module'] as MemorizationModule? ??
            defaultMemorizationModule ??
            MemorizationModule(storageRegistry: registry, quranStore: quranMod.store);
        return MaterialPageRoute(
          builder: (ctx) => StudySessionScreen(
            memorizationModule: memMod,
            onFinish: () => Navigator.pop(ctx),
          ),
          settings: routeSettings,
        );
      case memorizationPlan:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final quranMod = defaultQuranModule ?? QuranModule(storageRegistry: registry);
        final memMod = args['module'] as MemorizationModule? ??
            defaultMemorizationModule ??
            MemorizationModule(storageRegistry: registry, quranStore: quranMod.store);
        final targetKey = args['target_ayah_key'] as AyahKey?;
        return MaterialPageRoute(
          builder: (ctx) => PlanSetupScreen(
            memorizationModule: memMod,
            initialTargetAyahKey: targetKey,
            onSaved: () => Navigator.pop(ctx),
          ),
          settings: routeSettings,
        );
      case adhkar:
        final adhkarMod = defaultAdhkarModule ?? AdhkarModule(storageRegistry: MemoryStorageRegistry());
        return MaterialPageRoute(
          builder: (_) => AdhkarHomeScreen(module: adhkarMod),
          settings: routeSettings,
        );
      case zakat:
        final registry = MemoryStorageRegistry();
        final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => ZakatDashboardScreen(module: zakatMod),
          settings: routeSettings,
        );
      case zakatAssets:
        final registry = MemoryStorageRegistry();
        final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => AssetEntryScreen(module: zakatMod),
          settings: routeSettings,
        );
      case zakatPolicy:
        final registry = MemoryStorageRegistry();
        final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => ZakatPolicyScreen(module: zakatMod),
          settings: routeSettings,
        );
      case zakatBreakdown:
        final registry = MemoryStorageRegistry();
        final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<Result<ZakatCalculationResult, Failure>>(
            future: zakatMod.calculateZakat(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isFailure) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              return ZakatBreakdownScreen(
                result: snapshot.data!.valueOrNull!,
                module: zakatMod,
              );
            },
          ),
          settings: routeSettings,
        );
      case zakatSettings:
        final registry = MemoryStorageRegistry();
        final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => ZakatSettingsScreen(module: zakatMod),
          settings: routeSettings,
        );
      case zakatCalculator:
        final registry = MemoryStorageRegistry();
        final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => ZakatCalculatorWorkflowScreen(module: zakatMod),
          settings: routeSettings,
        );
      case zakatHistory:
        final registry = MemoryStorageRegistry();
        final zakatMod = defaultZakatModule ?? ZakatModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => ZakatHistoryScreen(module: zakatMod),
          settings: routeSettings,
        );
      case fasting:
        final registry = MemoryStorageRegistry();
        final prayerMod = PrayerModule(storageRegistry: registry);
        final fastingMod = defaultFastingModule ??
            FastingModule(
              storageRegistry: registry,
              prayerModule: prayerMod,
            );
        return MaterialPageRoute(
          builder: (_) => FastingDashboardScreen(module: fastingMod),
          settings: routeSettings,
        );
      case fastingCalendar:
        final registry = MemoryStorageRegistry();
        final prayerMod = PrayerModule(storageRegistry: registry);
        final fastingMod = defaultFastingModule ??
            FastingModule(
              storageRegistry: registry,
              prayerModule: prayerMod,
            );
        return MaterialPageRoute(
          builder: (_) => FastingCalendarScreen(module: fastingMod),
          settings: routeSettings,
        );
      case fastingQada:
        final registry = MemoryStorageRegistry();
        final prayerMod = PrayerModule(storageRegistry: registry);
        final fastingMod = defaultFastingModule ??
            FastingModule(
              storageRegistry: registry,
              prayerModule: prayerMod,
            );
        return MaterialPageRoute(
          builder: (_) => QadaPlannerScreen(module: fastingMod),
          settings: routeSettings,
        );
      case fastingSettings:
        final registry = MemoryStorageRegistry();
        final prayerMod = PrayerModule(storageRegistry: registry);
        final fastingMod = defaultFastingModule ??
            FastingModule(
              storageRegistry: registry,
              prayerModule: prayerMod,
            );
        return MaterialPageRoute(
          builder: (_) => FastingSettingsScreen(module: fastingMod),
          settings: routeSettings,
        );
      case knowledge:
        final knowledgeMod = getOrSeedKnowledgeModule();
        return MaterialPageRoute(
          builder: (_) => KnowledgeHomeScreen(module: knowledgeMod),
          settings: routeSettings,
        );
      case knowledgeHadith:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final knowledgeMod = getOrSeedKnowledgeModule(args['module'] as KnowledgeModule?);
        final hadith = args['hadith'] as HadithEntity?;
        if (hadith == null) {
          return MaterialPageRoute(
            builder: (_) => KnowledgeHomeScreen(module: knowledgeMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => HadithDetailScreen(hadith: hadith, module: knowledgeMod),
          settings: routeSettings,
        );
      case knowledgeFiqh:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final knowledgeMod = getOrSeedKnowledgeModule(args['module'] as KnowledgeModule?);
        final topic = args['topic'] as FiqhTopic?;
        if (topic == null) {
          return MaterialPageRoute(
            builder: (_) => KnowledgeHomeScreen(module: knowledgeMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => FiqhTopicScreen(topic: topic, module: knowledgeMod),
          settings: routeSettings,
        );
      case knowledgeSearch:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final knowledgeMod = getOrSeedKnowledgeModule(args['module'] as KnowledgeModule?);
        final initialQuery = args['query'] as String?;
        return MaterialPageRoute(
          builder: (_) => KnowledgeSearchScreen(module: knowledgeMod, initialQuery: initialQuery),
          settings: routeSettings,
        );
      case knowledgeBooks:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final knowledgeMod = getOrSeedKnowledgeModule(args['module'] as KnowledgeModule?);
        final colId = args['collectionId'] as String?;
        return MaterialPageRoute(
          builder: (_) => HadithBookBrowserScreen(module: knowledgeMod, initialCollectionId: colId),
          settings: routeSettings,
        );
      case knowledgeFavorites:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final knowledgeMod = getOrSeedKnowledgeModule(args['module'] as KnowledgeModule?);
        return MaterialPageRoute(
          builder: (_) => KnowledgeFavoritesScreen(module: knowledgeMod),
          settings: routeSettings,
        );
      case learning:
        final registry = MemoryStorageRegistry();
        final learningMod = defaultLearningModule ?? LearningModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => LearningHomeScreen(module: learningMod),
          settings: routeSettings,
        );
      case learningPath:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final learningMod = args['module'] as LearningModule? ?? defaultLearningModule ?? LearningModule(storageRegistry: registry);
        final path = args['path'] as lp.LearningPath?;
        if (path == null) {
          return MaterialPageRoute(
            builder: (_) => LearningHomeScreen(module: learningMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => LearningPathScreen(path: path, module: learningMod),
          settings: routeSettings,
        );
      case learningLesson:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final learningMod = args['module'] as LearningModule? ?? defaultLearningModule ?? LearningModule(storageRegistry: registry);
        final lesson = args['lesson'] as Lesson?;
        if (lesson == null) {
          return MaterialPageRoute(
            builder: (_) => LearningHomeScreen(module: learningMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => LessonScreen(lesson: lesson, module: learningMod),
          settings: routeSettings,
        );
      case learningQuiz:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final learningMod = args['module'] as LearningModule? ?? defaultLearningModule ?? LearningModule(storageRegistry: registry);
        final quiz = args['quiz'] as Quiz?;
        if (quiz == null) {
          return MaterialPageRoute(
            builder: (_) => LearningHomeScreen(module: learningMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => QuizScreen(quiz: quiz, module: learningMod),
          settings: routeSettings,
        );
      case learningGoals:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final learningMod = args['module'] as LearningModule? ?? defaultLearningModule ?? LearningModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => LearningGoalsScreen(module: learningMod),
          settings: routeSettings,
        );
      case seerah:
        final registry = MemoryStorageRegistry();
        final seerahMod = defaultSeerahModule ?? SeerahModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => SeerahHomeScreen(module: seerahMod),
          settings: routeSettings,
        );
      case seerahTimeline:
        final registry = MemoryStorageRegistry();
        final seerahMod = defaultSeerahModule ?? SeerahModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => TimelineScreen(module: seerahMod),
          settings: routeSettings,
        );
      case seerahEvent:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final seerahMod = args['module'] as SeerahModule? ?? defaultSeerahModule ?? SeerahModule(storageRegistry: registry);
        final event = args['event'] as SeerahEvent?;
        if (event == null) {
          return MaterialPageRoute(
            builder: (_) => SeerahHomeScreen(module: seerahMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => EventDetailScreen(event: event, module: seerahMod),
          settings: routeSettings,
        );
      case seerahPerson:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final seerahMod = args['module'] as SeerahModule? ?? defaultSeerahModule ?? SeerahModule(storageRegistry: registry);
        final person = args['person'] as HistoricalPerson?;
        if (person == null) {
          return MaterialPageRoute(
            builder: (_) => SeerahHomeScreen(module: seerahMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => PersonDetailScreen(person: person, module: seerahMod),
          settings: routeSettings,
        );
      case seerahPlace:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final place = args['place'] as HistoricalPlace?;
        if (place == null) {
          final registry = MemoryStorageRegistry();
          final seerahMod = defaultSeerahModule ?? SeerahModule(storageRegistry: registry);
          return MaterialPageRoute(
            builder: (_) => SeerahHomeScreen(module: seerahMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => PlaceDetailScreen(place: place),
          settings: routeSettings,
        );
      case hajj:
        final registry = MemoryStorageRegistry();
        final hajjMod = defaultHajjModule ?? HajjModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => HajjHomeScreen(module: hajjMod),
          settings: routeSettings,
        );
      case hajjJourney:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final hajjMod = args['module'] as HajjModule? ?? defaultHajjModule ?? HajjModule(storageRegistry: registry);
        final type = args['type'] as JourneyType? ?? JourneyType.hajjTamattu;
        return MaterialPageRoute(
          builder: (_) => JourneyDashboardScreen(module: hajjMod, journeyType: type),
          settings: routeSettings,
        );
      case hajjUmrah:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final hajjMod = args['module'] as HajjModule? ?? defaultHajjModule ?? HajjModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => JourneyDashboardScreen(module: hajjMod, journeyType: JourneyType.umrah),
          settings: routeSettings,
        );
      case hajjStep:
        final args = routeSettings.arguments as Map<String, dynamic>? ?? {};
        final registry = MemoryStorageRegistry();
        final hajjMod = args['module'] as HajjModule? ?? defaultHajjModule ?? HajjModule(storageRegistry: registry);
        final step = args['step'] as RitualStep?;
        if (step == null) {
          return MaterialPageRoute(
            builder: (_) => HajjHomeScreen(module: hajjMod),
            settings: routeSettings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => RitualStepDetailScreen(step: step, module: hajjMod),
          settings: routeSettings,
        );
      case hajjMiqat:
        final registry = MemoryStorageRegistry();
        final hajjMod = defaultHajjModule ?? HajjModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => MiqatGuideScreen(module: hajjMod),
          settings: routeSettings,
        );
      case hajjLocations:
        final registry = MemoryStorageRegistry();
        final hajjMod = defaultHajjModule ?? HajjModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => SacredLocationsScreen(module: hajjMod),
          settings: routeSettings,
        );
      case hajjPreparation:
        final registry = MemoryStorageRegistry();
        final hajjMod = defaultHajjModule ?? HajjModule(storageRegistry: registry);
        return MaterialPageRoute(
          builder: (_) => PreparationChecklistScreen(module: hajjMod),
          settings: routeSettings,
        );
      case aiRetrieval:
        final registry = MemoryStorageRegistry();
        final knowMod = KnowledgeModule(storageRegistry: registry);
        final aiMod = AIModule(knowledgeModule: knowMod);
        return MaterialPageRoute(
          builder: (_) => AISearchQueryScreen(module: aiMod),
          settings: routeSettings,
        );
      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: routeSettings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text(AppStrings.appName)),
            body: const EmptyStateView(message: 'الصفحة المطلوبة غير موجودة'),
          ),
          settings: routeSettings,
        );
    }
  }
}

/// Baseline Home Screen for App Shell with quick access to modules.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.paddingScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mosque_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'مرحباً بك في سِراج',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'الرفيق الرقمي الموثق — المحور الحياتي الموحد (M11)',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.l),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.companion);
                    },
                    icon: const Icon(Icons.dashboard_customize_rounded),
                    label: const Text('الرفيق الحياتي الموحد (Home Dashboard)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F3D2E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.prayer);
                    },
                    icon: const Icon(Icons.access_time_filled_rounded),
                    label: const Text('مواقيت الصلاة والقبلة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.quran);
                    },
                    icon: const Icon(Icons.menu_book_rounded),
                    label: const Text('المصحف الشريف والقراءة'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.memorization);
                    },
                    icon: const Icon(Icons.psychology_rounded),
                    label: const Text('حفظ ومراجعة القرآن الكريم'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.adhkar);
                    },
                    icon: const Icon(Icons.auto_stories_rounded),
                    label: const Text('الأذكار والأدعية الموثقة'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.zakat);
                    },
                    icon: const Icon(Icons.calculate_rounded),
                    label: const Text('حساب الزكاة والحوكمة الفقهية'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.fasting);
                    },
                    icon: const Icon(Icons.nightlight_round),
                    label: const Text('الصيام ورمضان المبارك'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.knowledge);
                    },
                    icon: const Icon(Icons.menu_book_sharp),
                    label: const Text('المعرفة والحديث الشريف والفقه'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5132),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.learning);
                    },
                    icon: const Icon(Icons.school_rounded),
                    label: const Text('المناهج والمسارات التعليمية'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.seerah);
                    },
                    icon: const Icon(Icons.history_edu),
                    label: const Text('السيرة النبوية والتاريخ الإسلامي'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF856404), // Ochre Bronze
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.hajj);
                    },
                    icon: const Icon(Icons.mosque),
                    label: const Text('الحج والعمرة ومناسك النسك'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B4D3E), // Emerald Green
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Baseline Settings Screen placeholder.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: const EmptyStateView(
        icon: Icons.settings_outlined,
        message: AppStrings.settings,
      ),
    );
  }
}
