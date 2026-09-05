import 'package:flutter/material.dart';
import '../core/i18n/app_strings.dart';
import '../core/storage/memory_storage.dart';
import 'seed/content_seed_engine.dart';
import '../core/storage/storage_contract.dart';
import '../modules/adhkar/adhkar_module.dart';
import '../modules/companion/companion_module.dart';
import '../modules/fasting/fasting_module.dart';
import '../modules/hajj/hajj_module.dart';
import '../modules/knowledge/knowledge_module.dart';
import '../modules/learning/learning_module.dart';
import '../modules/memorization/memorization_module.dart';
import '../modules/prayer/prayer_module.dart';
import '../modules/quran/quran_module.dart';
import '../modules/quran/services/cairo_radio_audio_service.dart';
import '../modules/quran/services/flutter_audio_player_adapter.dart';
import '../modules/quran/services/quran_audio_service.dart';
import '../modules/seerah/seerah_module.dart';
import '../modules/zakat/zakat_module.dart';
import '../core/location/location_engine.dart';
import '../core/location/sensor_compass_service.dart';
import 'adhkar/adhkar_home_screen.dart';
import 'companion/home_dashboard_view.dart';
import 'prayer/prayer_screen.dart';
import 'quran/surah_list_screen.dart';
import 'routing/app_router.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme_controller.dart';
import '../core/audio/siraj_feedback_audio_service.dart';
import '../core/notifications/siraj_notification_manager.dart';
import 'v1_more_screen.dart';
import 'widgets/state_views.dart';

/// Real Production-Quality V1 App Shell (§6, §13, §14, §20).
/// Hosts 5-Tab Navigation connecting Home, Prayer, Quran, Adhkar, and More.
class V1AppShell extends StatefulWidget {
  final int initialIndex;
  final StorageRegistry? storageRegistry;

  const V1AppShell({
    super.key,
    this.initialIndex = 0,
    this.storageRegistry,
  });

  @override
  State<V1AppShell> createState() => _V1AppShellState();
}

class _V1AppShellState extends State<V1AppShell> {
  late int _currentIndex;
  late final StorageRegistry _storage;

  late final PrayerModule _prayerModule;
  late final QuranModule _quranModule;
  late final MemorizationModule _memorizationModule;
  late final AdhkarModule _adhkarModule;
  late final ZakatModule _zakatModule;
  late final FastingModule _fastingModule;
  late final KnowledgeModule _knowledgeModule;
  late final LearningModule _learningModule;
  late final SeerahModule _seerahModule;
  late final HajjModule _hajjModule;
  late final CompanionModule _companionModule;
  late final LocationEngine _locationEngine;
  late final SensorCompassService _compassService;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _storage = widget.storageRegistry ?? MemoryStorageRegistry();
    AppThemeController(storageRegistry: _storage);
    SirajFeedbackAudioService(storageRegistry: _storage);

    // Initialize notification channels & permissions
    SirajNotificationManager.instance.init();
    SirajNotificationManager.instance.requestPermissions();

    // Initialize location & compass services
    _locationEngine = LocationEngine(storageRegistry: _storage);
    _compassService = DeviceSensorCompassService();

    // Trigger automatic background location acquisition & persistence
    _locationEngine.acquireLocation();

    // Initialize core modules
    _prayerModule = PrayerModule(storageRegistry: _storage);
    final baseQuranModule = QuranModule(storageRegistry: _storage);
    late final QuranAudioService realAudioService;
    final audioAdapter = FlutterAudioPlayerAdapter(
      onComplete: () {
        realAudioService.nextAyah();
      },
    );
    realAudioService = QuranAudioService(
      store: baseQuranModule.store,
      player: audioAdapter,
    );
    final realRadioService = CairoRadioAudioService(
      player: ProductionRadioPlayerAdapter(),
    );
    CairoRadioAudioService.setMockInstance(realRadioService);
    _quranModule = QuranModule(
      storageRegistry: _storage,
      storeInstance: baseQuranModule.store,
      audioServiceInstance: realAudioService,
      radioServiceInstance: realRadioService,
    );
    AppRouter.defaultQuranModule = _quranModule;
    _memorizationModule = MemorizationModule(
      storageRegistry: _storage,
      quranStore: _quranModule.store,
    );
    _adhkarModule = AdhkarModule(storageRegistry: _storage);
    _zakatModule = ZakatModule(storageRegistry: _storage);
    _fastingModule = FastingModule(
      storageRegistry: _storage,
      prayerModule: _prayerModule,
    );
    _knowledgeModule = KnowledgeModule(storageRegistry: _storage);
    _learningModule = LearningModule(storageRegistry: _storage);
    _seerahModule = SeerahModule(storageRegistry: _storage);
    _hajjModule = HajjModule(storageRegistry: _storage);

    // Initialize unified life companion with real module wiring
    _companionModule = CompanionModule(
      storageRegistry: _storage,
      prayerModule: _prayerModule,
      quranModule: _quranModule,
      memorizationModule: _memorizationModule,
      adhkarModule: _adhkarModule,
      zakatModule: _zakatModule,
      fastingModule: _fastingModule,
      knowledgeModule: _knowledgeModule,
      learningModule: _learningModule,
      seerahModule: _seerahModule,
      hajjModule: _hajjModule,
    );

    // Deterministic Canonical Content Seeding (§20 Real Content Recovery)
    ContentSeedEngine.seedAllModules(
      quranModule: _quranModule,
      adhkarModule: _adhkarModule,
      knowledgeModule: _knowledgeModule,
      learningModule: _learningModule,
      seerahModule: _seerahModule,
      hajjModule: _hajjModule,
    );

    // Register active modules globally for router deep linking and seamless navigation
    AppRouter.defaultQuranModule = _quranModule;
    AppRouter.defaultKnowledgeModule = _knowledgeModule;
    AppRouter.defaultAdhkarModule = _adhkarModule;
    AppRouter.defaultZakatModule = _zakatModule;
    AppRouter.defaultFastingModule = _fastingModule;
    AppRouter.defaultLearningModule = _learningModule;
    AppRouter.defaultSeerahModule = _seerahModule;
    AppRouter.defaultHajjModule = _hajjModule;
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      // 0. Home Command Center
      HomeDashboardView(module: _companionModule),

      // 1. Prayer & Qibla
      PrayerScreen(
        prayerModule: _prayerModule,
        locationEngine: _locationEngine,
        compassService: _compassService,
      ),

      // 2. Quran Core Reader
      SurahListScreen(
        quranModule: _quranModule,
        onOpenSurah: (surahNum, {targetPage, targetAyah}) {
          Navigator.pushNamed(
            context,
            AppRouter.quranReader,
            arguments: {
              'surah_number': surahNum,
              'page_number': targetPage,
              'ayah_number': targetAyah,
              'module': _quranModule,
            },
          );
        },
      ),

      // 3. Adhkar & Counter
      AdhkarHomeScreen(module: _adhkarModule),

      // 4. Knowledge & More
      V1MoreHomeScreen(companionModule: _companionModule),
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Accessible root app identifier
          const SizedBox(
            height: 0,
            width: 0,
            child: OverflowBox(
              minWidth: 0,
              maxWidth: double.infinity,
              minHeight: 0,
              maxHeight: 1,
              child: Text(
                AppStrings.appName,
                style: TextStyle(fontSize: 1, color: Colors.transparent),
              ),
            ),
          ),
          const OfflineStateBanner(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),
        ],
      ),
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1.2,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (_currentIndex != index) {
              SirajFeedbackAudioService.instance.playTap();
              setState(() => _currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.surface(context),
          selectedItemColor: isDark ? AppColors.goldAccentLight : AppColors.primary,
          unselectedItemColor: isDark ? AppColors.textSecondaryDark : const Color(0xFF6C757D),
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_time_filled_rounded),
              label: 'الصلاة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'المصحف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_rounded),
              label: 'الأذكار',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'المزيد',
            ),
          ],
        ),
      ),
    );
  }
}
