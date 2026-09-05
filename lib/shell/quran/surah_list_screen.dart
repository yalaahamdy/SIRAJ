import 'package:flutter/material.dart';
import '../../../modules/quran/domain/juz_info.dart';
import '../../../modules/quran/domain/quran_reading_progress.dart';
import '../../../modules/quran/domain/surah.dart';
import '../../../modules/quran/quran_module.dart';
import '../../../modules/quran/search/quran_search_engine.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../widgets/state_views.dart';
import 'widgets/cairo_radio_live_view.dart';
import 'widgets/quran_audio_radio_tab.dart';
import 'widgets/quran_settings_tab.dart';

/// Screen displaying the 114 Surahs, 30 Juzs, Quran settings & audio studio, and search (§3..§10, §20..§35, §50..§55).
class SurahListScreen extends StatefulWidget {
  final QuranModule quranModule;
  final Function(int surahNumber, {int? targetPage, int? targetAyah}) onOpenSurah;

  const SurahListScreen({
    super.key,
    required this.quranModule,
    required this.onOpenSurah,
  });

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<Surah> _surahs = [];
  List<JuzInfo> _juzs = [];
  QuranReadingProgress? _readingProgress;
  List<QuranSearchResult> _searchResults = [];

  bool _isLoading = true;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    final surahsRes = widget.quranModule.getAllSurahs();
    final juzsRes = widget.quranModule.readerService.getAllJuzs();
    final progressRes = await widget.quranModule.getReadingProgress();

    if (mounted) {
      setState(() {
        _surahs = surahsRes.valueOrNull ?? [];
        _juzs = juzsRes.valueOrNull ?? [];
        _readingProgress = progressRes.valueOrNull;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    final res = widget.quranModule.search(query);
    setState(() {
      _isSearching = true;
      _searchResults = res.valueOrNull ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.25,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.goldAccent,
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              tabs: const [
                Tab(text: 'السور'),
                Tab(text: 'إذاعة القاهرة'),
                Tab(text: 'التلاوة'),
                Tab(text: 'الأجزاء'),
                Tab(text: 'الإعدادات'),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const LoadingStateView()
          : Column(
              children: [
                // Search Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.25,
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'ابحث في آيات وسور القرآن الكريم...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                    ),
                  ),
                ),

                // If active search query, show Search Results view
                if (_isSearching)
                  Expanded(child: _buildSearchResultsView(context, isDark))
                else
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildSurahsTab(context, isDark),
                        CairoRadioLiveView(
                          radioService: widget.quranModule.radioService,
                        ),
                        QuranAudioRadioTab(
                          quranModule: widget.quranModule,
                          surahs: _surahs,
                          onOpenSurah: widget.onOpenSurah,
                        ),
                        _buildJuzsTab(context, isDark),
                        QuranSettingsTab(
                          quranModule: widget.quranModule,
                          onOpenSurah: widget.onOpenSurah,
                          onSettingsChanged: _loadAllData,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildSurahsTab(BuildContext context, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadAllData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        itemCount: _surahs.length + (_readingProgress != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (_readingProgress != null && index == 0) {
            return _buildLastReadBanner(context, isDark);
          }

          final surahIndex = _readingProgress != null ? index - 1 : index;
          final surah = _surahs[surahIndex];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: (isDark ? AppColors.surfaceDark : AppColors.primaryLight).withValues(alpha: 0.2),
              child: Text(
                '${surah.number}',
                style: TextStyle(
                  color: isDark ? AppColors.goldAccent : AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              'سورة ${surah.nameArabic}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '${surah.nameEnglish} • ${surah.revelationType.nameArabic} • ${surah.ayahCount} آيات',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              'ص ${surah.startPage}',
              style: TextStyle(fontSize: 12, color: isDark ? AppColors.goldAccent : AppColors.primaryLight),
            ),
            onTap: () => widget.onOpenSurah(surah.number, targetPage: surah.startPage),
          );
        },
      ),
    );
  }

  Widget _buildJuzsTab(BuildContext context, bool isDark) {
    return ListView.separated(
      itemCount: _juzs.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final juz = _juzs[index];
        return ListTile(
          leading: const Icon(Icons.menu_book_rounded, color: AppColors.primaryLight),
          title: Text(
            'الجزء ${juz.number}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text('يبدأ من سورة رقم ${juz.startSurahNumber} • صفحة ${juz.startPage}'),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () => widget.onOpenSurah(juz.startSurahNumber, targetPage: juz.startPage),
        );
      },
    );
  }

  Widget _buildLastReadBanner(BuildContext context, bool isDark) {
    final p = _readingProgress!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
      color: isDark ? AppColors.surfaceDark : AppColors.primary,
      child: ListTile(
        leading: const Icon(Icons.auto_stories_rounded, color: AppColors.goldAccentLight, size: 32),
        title: Text(
          'متابعة القراءة: سورة ${p.surahNameArabic}',
          style: TextStyle(
            color: isDark ? AppColors.textPrimaryDark : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'الآية ${p.lastReadAyah} • صفحة ${p.lastReadPage}',
          style: TextStyle(color: isDark ? AppColors.textSecondaryDark : Colors.white70),
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.goldAccent,
            foregroundColor: Colors.black87,
          ),
          onPressed: () => widget.onOpenSurah(
            p.lastReadSurah,
            targetPage: p.lastReadPage,
            targetAyah: p.lastReadAyah,
          ),
          child: const Text('متابعة'),
        ),
      ),
    );
  }

  Widget _buildSearchResultsView(BuildContext context, bool isDark) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: AppSpacing.s),
            Text(
              'لم يتم العثور على نتائج مطابقة',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        final ayah = result.ayah;

        return ListTile(
          title: Text(
            ayah.textUthmani,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Amiri', fontSize: 16),
          ),
          subtitle: Text('سورة رقم ${ayah.surahNumber} • الآية ${ayah.ayahNumber} • ص ${ayah.pageNumber}'),
          onTap: () => widget.onOpenSurah(
            ayah.surahNumber,
            targetPage: ayah.pageNumber,
            targetAyah: ayah.ayahNumber,
          ),
        );
      },
    );
  }
}
