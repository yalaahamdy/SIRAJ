import 'package:flutter/material.dart';
import '../../../modules/knowledge/domain/fiqh_topic.dart';
import '../../../modules/knowledge/domain/hadith_entity.dart';
import '../../../modules/knowledge/domain/source_record.dart';
import '../../../modules/knowledge/domain/source_type.dart';
import '../../../modules/knowledge/knowledge_module.dart';
import 'fiqh_topic_screen.dart';
import 'hadith_book_browser_screen.dart';
import 'hadith_detail_screen.dart';
import 'knowledge_favorites_screen.dart';
import 'knowledge_search_screen.dart';
import 'widgets/fiqh_topic_tile.dart';
import 'widgets/hadith_card.dart';

/// Main Portal Screen for Islamic Knowledge, Hadith & Comparative Fiqh (§3, §45).
class KnowledgeHomeScreen extends StatefulWidget {
  final KnowledgeModule module;

  const KnowledgeHomeScreen({
    super.key,
    required this.module,
  });

  @override
  State<KnowledgeHomeScreen> createState() => _KnowledgeHomeScreenState();
}

class _KnowledgeHomeScreenState extends State<KnowledgeHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HadithEntity> _hadiths = [];
  List<FiqhTopic> _fiqhTopics = [];
  List<SourceRecord> _sources = [];
  List<SourceRecord> _hadithCollections = [];
  HadithEntity? _dailyHadith;
  String? _selectedCategory;
  String? _selectedHadithTheme;
  bool _isLoading = true;

  static const _hadithThemes = [
    'الأربعين النووية (أصول الدين)',
    'العقيدة والإيمان',
    'الطهارة والعبادات',
    'الزكاة والصيام والحج',
    'المعاملات والحقوق',
    'الأخلاق والآداب',
    'الرقائق والذكر',
    'العلم والسنة',
  ];

  bool _matchesHadithTheme(HadithEntity h, String theme) {
    if (theme.contains('الأربعين')) {
      return h.bookName.contains('الأربعين');
    }
    if (theme.contains('العقيدة')) {
      return h.bookName.contains('الإيمان') ||
          h.bookName.contains('الوحي') ||
          h.bookName.contains('التوحيد') ||
          h.chapterName?.contains('الإيمان') == true ||
          h.chapterName?.contains('القدر') == true;
    }
    if (theme.contains('الطهارة')) {
      return h.bookName.contains('الوضوء') ||
          h.bookName.contains('الغسل') ||
          h.bookName.contains('الصلاة') ||
          h.bookName.contains('الأذان') ||
          h.bookName.contains('المساجد') ||
          h.bookName.contains('الجمعة') ||
          h.chapterName?.contains('الطهور') == true ||
          h.chapterName?.contains('الصلاة') == true;
    }
    if (theme.contains('الزكاة') || theme.contains('الصيام')) {
      return h.bookName.contains('الزكاة') ||
          h.bookName.contains('الصوم') ||
          h.bookName.contains('الصيام') ||
          h.bookName.contains('الحج') ||
          h.chapterName?.contains('الزكاة') == true ||
          h.chapterName?.contains('الصيام') == true ||
          h.chapterName?.contains('الحج') == true;
    }
    if (theme.contains('المعاملات')) {
      return h.bookName.contains('البيوع') ||
          h.bookName.contains('المساقاة') ||
          h.bookName.contains('المظالم') ||
          h.bookName.contains('الشفعة') ||
          h.bookName.contains('القضاء') ||
          h.chapterName?.contains('المعاملات') == true ||
          h.chapterName?.contains('البيع') == true ||
          h.chapterName?.contains('الضرر') == true ||
          h.chapterName?.contains('البينة') == true;
    }
    if (theme.contains('الأخلاق')) {
      return h.bookName.contains('الأدب') ||
          h.bookName.contains('البر') ||
          h.chapterName?.contains('الأخلاق') == true ||
          h.chapterName?.contains('الحياء') == true ||
          h.chapterName?.contains('الغضب') == true ||
          h.chapterName?.contains('اللسان') == true ||
          h.chapterName?.contains('الجار') == true ||
          h.chapterName?.contains('الإحسان') == true;
    }
    if (theme.contains('الرقائق')) {
      return h.bookName.contains('الرقاق') ||
          h.bookName.contains('الذكر') ||
          h.bookName.contains('الدعاء') ||
          h.bookName.contains('التوبة') ||
          h.chapterName?.contains('الزهد') == true ||
          h.chapterName?.contains('الاستغفار') == true ||
          h.chapterName?.contains('الجنة') == true;
    }
    if (theme.contains('العلم')) {
      return h.bookName.contains('العلم') ||
          h.bookName.contains('الاعتصام') ||
          h.chapterName?.contains('العلم') == true ||
          h.chapterName?.contains('السنة') == true;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadKnowledgeData();
  }

  void _loadKnowledgeData() {
    setState(() => _isLoading = true);

    final allHadithsRes = widget.module.store.getAllHadiths();
    final fiqhRes = widget.module.fiqhService.getAllTopics();
    final sourcesRes = widget.module.sourceRegistryService.getAllSources();
    final collectionsRes = widget.module.hadithService.getHadithCollections();
    final dailyRes = widget.module.hadithService.getDailyHadith(DateTime.now());

    setState(() {
      _hadiths = allHadithsRes.valueOrNull ?? [];
      _fiqhTopics = fiqhRes.valueOrNull ?? [];
      _sources = sourcesRes.valueOrNull ?? [];
      _hadithCollections = collectionsRes.valueOrNull ?? [];
      _dailyHadith = dailyRes.valueOrNull;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSearch([String? query]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KnowledgeSearchScreen(module: widget.module, initialQuery: query),
      ),
    );
  }

  void _openBookBrowser([String? collectionId]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => HadithBookBrowserScreen(
          module: widget.module,
          initialCollectionId: collectionId,
        ),
      ),
    );
  }

  void _openFavorites() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KnowledgeFavoritesScreen(module: widget.module),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المعرفة والحديث الشريف'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            tooltip: 'المفضلة والملاحظات',
            onPressed: _openFavorites,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'البحث المعرفي',
            onPressed: () => _openSearch(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الحديث النبوي'),
            Tab(text: 'الفقه المقارن'),
            Tab(text: 'المصادر المعتمدة'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildHadithTab(),
                _buildFiqhTab(),
                _buildSourcesTab(),
              ],
            ),
    );
  }

  // ===========================================================================
  // Tab 1: الحديث النبوي وكتب السنة
  // ===========================================================================
  Widget _buildHadithTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
    final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. High-Contrast Search Prompt
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openSearch(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF152019) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? const Color(0xFF26382D) : const Color(0xFF94A3B8), width: 1.1),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: primaryAccent, size: 22),
                const SizedBox(width: 10),
                Text(
                  'ابحث في متون الأحاديث، الأسانيد، والرواة...',
                  style: TextStyle(color: textSecondary, fontSize: 13.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Daily Hadith Feature Card
        if (_dailyHadith != null && _hadiths.length > 1) ...[
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0A331E), const Color(0xFF134E2C)]
                    : [const Color(0xFF0F5132), const Color(0xFF1B6B45)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F5132).withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.star, color: Color(0xFFD4AF37), size: 18),
                        SizedBox(width: 6),
                        Text(
                          'حديث اليوم المختار',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (_dailyHadith!.gradings.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          _dailyHadith!.gradings.first.grade.labelArabic,
                          style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '«${_dailyHadith!.arabicMatn}»',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17.5,
                    height: 1.95,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Amiri',
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '${_dailyHadith!.bookName} · رقم ${_dailyHadith!.primaryNumber}',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12.5, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HadithDetailScreen(hadith: _dailyHadith!, module: widget.module),
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Text('عرض الشرح والتخريج', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
        ],

        // 3. Sunnah Collections Browser Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.collections_bookmark_outlined, size: 20, color: primaryAccent),
                const SizedBox(width: 8),
                Text(
                  'كتب السنة المشرفة',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5, color: textPrimary),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _openBookBrowser(),
              child: Text('تصفح الكل', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryAccent)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _hadithCollections.length,
            itemBuilder: (ctx, idx) {
              final col = _hadithCollections[idx];
              final count = _hadiths.where((h) => h.collectionId == col.sourceId).length;

              return Container(
                width: 155,
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder, width: 1.1),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openBookBrowser(col.sourceId),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            col.title.split('(').first.trim(),
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textPrimary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            '$count أحاديث محققة',
                            style: TextStyle(fontSize: 12, color: primaryAccent, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),

        // 4. Thematic Topics Filter Section (§3)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.category_outlined, size: 20, color: primaryAccent),
                const SizedBox(width: 8),
                Text(
                  'التصنيف الموضوعي للأحاديث',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5, color: textPrimary),
                ),
              ],
            ),
            if (_selectedHadithTheme != null)
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: primaryAccent,
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () => setState(() => _selectedHadithTheme = null),
                child: const Text('عرض الكل', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: ChoiceChip(
                  label: Text('كافة الأحاديث (${_hadiths.length})'),
                  selected: _selectedHadithTheme == null,
                  selectedColor: isDark ? const Color(0xFF142E1F) : const Color(0xFF0F5132),
                  labelStyle: TextStyle(
                    color: _selectedHadithTheme == null ? Colors.white : (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _selectedHadithTheme = null);
                  },
                ),
              ),
              ..._hadithThemes.map((themeName) {
                final count = _hadiths.where((h) => _matchesHadithTheme(h, themeName)).length;
                final isSelected = _selectedHadithTheme == themeName;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: ChoiceChip(
                    label: Text('$themeName ($count)'),
                    selected: isSelected,
                    selectedColor: isDark ? const Color(0xFF142E1F) : const Color(0xFF0F5132),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    onSelected: (val) {
                      setState(() => _selectedHadithTheme = val ? themeName : null);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 5. Canonical Hadiths List
        Builder(
          builder: (context) {
            final displayedHadiths = _selectedHadithTheme == null
                ? _hadiths
                : _hadiths.where((h) => _matchesHadithTheme(h, _selectedHadithTheme!)).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_stories, size: 20, color: primaryAccent),
                        const SizedBox(width: 8),
                        Text(
                          _selectedHadithTheme == null
                              ? 'أحاديث مختارة ومحققة (${_hadiths.length})'
                              : 'أحاديث $_selectedHadithTheme (${displayedHadiths.length})',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5, color: textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (displayedHadiths.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(Icons.filter_list_off, size: 40, color: textSecondary),
                          const SizedBox(height: 8),
                          Text(
                            'لا توجد أحاديث مسجلة في هذا التصنيف',
                            style: TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => setState(() => _selectedHadithTheme = null),
                            child: const Text('العودة لكافة الأحاديث'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...displayedHadiths.map(
                    (h) => HadithCard(
                      hadith: h,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => HadithDetailScreen(hadith: h, module: widget.module),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // Tab 2: الفقه المقارن
  // ===========================================================================
  Widget _buildFiqhTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final categoriesRes = widget.module.fiqhService.getCategories();
    final categories = categoriesRes.valueOrNull ?? [];

    final filteredTopics = _selectedCategory == null
        ? _fiqhTopics
        : _fiqhTopics.where((t) => t.category == _selectedCategory).toList();

    return Column(
      children: [
        // Category Filter Chips
        if (categories.isNotEmpty)
          Container(
            height: 52,
            color: isDark ? const Color(0xFF141F18) : const Color(0xFFF1F5F9),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: const Text('كافة الأبواب'),
                    selected: _selectedCategory == null,
                    selectedColor: isDark ? const Color(0xFF142E1F) : const Color(0xFF0F5132),
                    labelStyle: TextStyle(
                      color: _selectedCategory == null ? Colors.white : (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = null);
                    },
                  ),
                ),
                ...categories.map(
                  (cat) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: _selectedCategory == cat,
                      selectedColor: isDark ? const Color(0xFF142E1F) : const Color(0xFF0F5132),
                      labelStyle: TextStyle(
                        color: _selectedCategory == cat ? Colors.white : (isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A)),
                        fontWeight: FontWeight.bold,
                        fontSize: 12.5,
                      ),
                      onSelected: (val) {
                        setState(() => _selectedCategory = val ? cat : null);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Fiqh Topics List
        Expanded(
          child: filteredTopics.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد مسائل فقهية مسجلة',
                    style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTopics.length,
                  itemBuilder: (context, index) {
                    final t = filteredTopics[index];
                    return FiqhTopicTile(
                      topic: t,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FiqhTopicScreen(topic: t, module: widget.module),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Tab 3: المصادر المعتمدة
  // ===========================================================================
  Widget _buildSourcesTab() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E2620) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF2E3D32) : const Color(0xFFCBD5E1);
    final textPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155);
    final primaryAccent = isDark ? const Color(0xFF4ADE80) : const Color(0xFF0F5132);

    if (_sources.isEmpty) {
      return Center(
        child: Text(
          'لا توجد مصادر موثقة في الحزمة',
          style: TextStyle(color: textSecondary, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sources.length,
      itemBuilder: (context, index) {
        final s = _sources[index];
        final isHadith = s.sourceType == SourceType.hadithCollection;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cardBorder, width: 1.1),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      s.title,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isHadith
                          ? (isDark ? const Color(0xFF142E1F) : const Color(0xFFE8F5E9))
                          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF)),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isHadith
                            ? (isDark ? const Color(0xFF22543D) : const Color(0xFFA5D6A7))
                            : (isDark ? const Color(0xFF3B82F6) : const Color(0xFF93C5FD)),
                      ),
                    ),
                    child: Text(
                      isHadith ? 'كتب السنة' : 'فقه وأصول',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isHadith ? primaryAccent : const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'المؤلف: ${s.author}',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: textSecondary),
              ),
              if (s.editor != null) ...[
                const SizedBox(height: 3),
                Text('التحقيق: ${s.editor}', style: TextStyle(fontSize: 12.5, color: textSecondary)),
              ],
              if (s.publisher != null) ...[
                const SizedBox(height: 3),
                Text('الناشر: ${s.publisher} (${s.edition ?? ''})', style: TextStyle(fontSize: 12.5, color: textSecondary)),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('نظام الإحالة: ${s.referenceScheme}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondary)),
                  Text('سنة الطبع: ${s.year} هـ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondary)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
