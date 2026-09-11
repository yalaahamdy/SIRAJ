import 'package:flutter/material.dart';
import '../../modules/quran/domain/surah.dart';
import '../../modules/quran/quran_module.dart';
import '../../modules/quran/services/cairo_radio_audio_service.dart';
import '../../modules/quran/store/tawasheeh_store.dart';
import '../quran/widgets/cairo_radio_live_view.dart';
import '../quran/widgets/quran_audio_radio_tab.dart';
import '../quran/widgets/sharawy_player_view.dart';
import '../quran/widgets/tawasheeh_player_view.dart';
import '../theme/app_colors.dart';

/// Premier Audio Studio Screen consolidating the 4 spiritual audio experiences:
/// 1. Cairo Quran Radio Live Stream
/// 2. Rare Historic Tawasheeh & Ibtihalat
/// 3. Sheikh Mohamed Metwally El-Sharawy's Tafsir Khawatir (1,117 audio lessons)
/// 4. Quran Recitation Studio with offline downloads & reciter management
class SirajAudioHubScreen extends StatefulWidget {
  final QuranModule quranModule;
  final TawasheehStore? tawasheehStore;
  final int initialTab;
  final Function(int surahNumber, {int? targetPage, int? targetAyah}) onOpenSurah;

  const SirajAudioHubScreen({
    super.key,
    required this.quranModule,
    this.tawasheehStore,
    int initialTab = 0,
    int? initialTabIndex,
    required this.onOpenSurah,
  }) : initialTab = initialTabIndex ?? initialTab;

  @override
  State<SirajAudioHubScreen> createState() => SirajAudioHubScreenState();
}

class SirajAudioHubScreenState extends State<SirajAudioHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final TawasheehStore _tawasheehStore;
  List<Surah> _surahs = [];

  @override
  void initState() {
    super.initState();
    _tawasheehStore = widget.tawasheehStore ?? widget.quranModule.tawasheehStore;
    if (!_tawasheehStore.isLoaded) {
      _tawasheehStore.load().then((_) {
        if (mounted) setState(() {});
      });
    }
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 3),
    );
    _tabController.addListener(_handleTabChange);
    _loadSurahs();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == 0) {
      if (widget.quranModule.radioService.mode != CairoRadioMode.liveRadio &&
          !widget.quranModule.radioService.isPlaying) {
        widget.quranModule.radioService.setMode(CairoRadioMode.liveRadio);
      }
    } else if (_tabController.index == 1) {
      if (widget.quranModule.radioService.mode != CairoRadioMode.tawasheeh &&
          !widget.quranModule.radioService.isPlaying) {
        widget.quranModule.radioService.setMode(CairoRadioMode.tawasheeh);
      }
    }
  }

  void _loadSurahs() {
    final res = widget.quranModule.getAllSurahs();
    if (res.isSuccess && res.valueOrNull != null) {
      setState(() {
        _surahs = res.valueOrNull!;
      });
    }
  }

  /// Switches the active sub-tab programmatically from anywhere in the app.
  void switchToTab(int tabIndex) {
    if (tabIndex >= 0 && tabIndex < 4) {
      _tabController.animateTo(tabIndex);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.headphones_rounded, color: AppColors.goldAccent, size: 22),
            SizedBox(width: 8),
            Text(
              'الصوتيات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                fontFamily: 'Amiri',
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface(context),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.goldAccent.withValues(alpha: isDark ? 0.2 : 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.goldAccent,
                indicatorWeight: 3,
                labelColor: isDark ? AppColors.goldAccentLight : AppColors.primary,
                unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.radio_rounded, size: 20),
                    text: 'إذاعة القاهرة',
                  ),
                  Tab(
                    icon: Icon(Icons.mosque_rounded, size: 20),
                    text: 'التواشيح',
                  ),
                  Tab(
                    icon: Icon(Icons.record_voice_over_rounded, size: 20),
                    text: 'خواطر الشعراوي',
                  ),
                  Tab(
                    icon: Icon(Icons.menu_book_rounded, size: 20),
                    text: 'التلاوة',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 1. إذاعة القرآن الكريم من القاهرة (البث المباشر)
          _KeepAliveWrapper(
            child: CairoRadioLiveView(
              radioService: widget.quranModule.radioService,
              tawasheehStore: _tawasheehStore,
            ),
          ),

          // 2. موسوعة التواشيح والابتهالات النادرة
          _KeepAliveWrapper(
            child: TawasheehPlayerView(
              radioService: widget.quranModule.radioService,
              tawasheehStore: _tawasheehStore,
            ),
          ),

          // 3. خواطر الشيخ محمد متولي الشعراوي في تفسير القرآن الكريم
          _KeepAliveWrapper(
            child: SharawyPlayerView(
              audioService: widget.quranModule.sharawyAudioService,
              sharawyStore: widget.quranModule.sharawyStore,
            ),
          ),

          // 4. استوديو تلاوات القرآن الكريم وتحميل السور للقراء
          _KeepAliveWrapper(
            child: QuranAudioRadioTab(
              quranModule: widget.quranModule,
              surahs: _surahs,
              onOpenSurah: widget.onOpenSurah,
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper wrapper preserving state and scroll offset across TabBar switching.
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
