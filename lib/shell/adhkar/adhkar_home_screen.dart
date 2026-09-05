import 'package:flutter/material.dart';
import '../../modules/adhkar/adhkar_module.dart';
import '../../modules/adhkar/domain/dhikr_item.dart';
import '../../modules/adhkar/domain/dhikr_occasion.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'dhikr_detail_screen.dart';
import 'occasion_adhkar_screen.dart';
import 'widgets/dhikr_card.dart';

/// Main Hub for Adhkar & Remembrance (§3..§8, §29..§38, §51..§56).
class AdhkarHomeScreen extends StatefulWidget {
  final AdhkarModule module;

  const AdhkarHomeScreen({super.key, required this.module});

  @override
  State<AdhkarHomeScreen> createState() => _AdhkarHomeScreenState();
}

class _AdhkarHomeScreenState extends State<AdhkarHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<DhikrItem> _searchResults = [];
  List<DhikrItem> _favoriteItems = [];
  bool _isSearching = false;
  bool _isLoadingFavorites = false;
  DhikrOccasion? _selectedFilterOccasion;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadFavorites();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.index == 1) {
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoadingFavorites = true);
    final favRes = await widget.module.getFavoriteItems();
    if (mounted) {
      setState(() {
        _favoriteItems = favRes.valueOrNull ?? [];
        _isLoadingFavorites = false;
      });
    }
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty && _selectedFilterOccasion == null) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    var results = widget.module.search(query);
    if (_selectedFilterOccasion != null) {
      results = results.where((item) => item.occasion == _selectedFilterOccasion).toList();
    }

    setState(() {
      _isSearching = true;
      _searchResults = results;
    });
  }

  void _setFilterOccasion(DhikrOccasion? occasion) {
    setState(() {
      _selectedFilterOccasion = occasion;
    });
    _onSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentOccasion = widget.module.getCurrentOccasion();
    final occasionExplanation = widget.module.getOccasionExplanation(currentOccasion);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار والأدعية'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.25,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.goldAccent,
              tabs: const [
                Tab(text: 'الأبواب والمناسبات'),
                Tab(text: 'المفضلة'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'ابحث في الأذكار والأدعية والمصادر...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: (_searchController.text.isNotEmpty || _isSearching)
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _setFilterOccasion(null);
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ),

          // 2. Filter Chips (when searching)
          if (_isSearching || _searchController.text.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('الكل'),
                    selected: _selectedFilterOccasion == null,
                    onSelected: (selected) {
                      if (selected) _setFilterOccasion(null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...[
                    DhikrOccasion.morning,
                    DhikrOccasion.evening,
                    DhikrOccasion.afterPrayer,
                    DhikrOccasion.sleep,
                  ].map((occ) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(occ.labelArabic),
                        selected: _selectedFilterOccasion == occ,
                        onSelected: (selected) {
                          _setFilterOccasion(selected ? occ : null);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

          // 3. Body: Search Results or Tabs
          Expanded(
            child: _isSearching
                ? _buildSearchResults(isDark)
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCategoriesFeed(currentOccasion, occasionExplanation, isDark),
                      _buildFavoritesTab(isDark),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(bool isDark) {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
            const SizedBox(height: AppSpacing.s),
            Text(
              'لا توجد نتائج مطابقة للبحث',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return DhikrCard(
          item: item,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DhikrDetailScreen(
                  items: _searchResults,
                  initialIndex: index,
                  module: widget.module,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoriesFeed(DhikrOccasion currentOccasion, String explanation, bool isDark) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Hero Active Occasion Card
        InkWell(
          onTap: () => _openOccasion(currentOccasion),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'المناسبة الحالية',
                          style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time_filled_rounded, color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    currentOccasion.labelArabic,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  explanation,
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Section Title
        const Text(
          'أبواب الأذكار والمناسبات',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        // Occasions Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemCount: DhikrOccasion.values.length,
          itemBuilder: (context, index) {
            final occ = DhikrOccasion.values[index];
            return _buildOccasionTile(occ, isDark);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFavoritesTab(bool isDark) {
    if (_isLoadingFavorites) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_favoriteItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 64, color: Theme.of(context).disabledColor),
            const SizedBox(height: AppSpacing.m),
            Text(
              'لا توجد أذكار في المفضلة بعد',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'انقر على أيقونة القلب في تفاصيل أي ذكر لحفظه هنا للوصول السريع',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _favoriteItems.length,
        itemBuilder: (context, index) {
          final item = _favoriteItems[index];
          return DhikrCard(
            item: item,
            isFavorite: true,
            onToggleFavorite: () async {
              await widget.module.toggleFavorite(item.id);
              _loadFavorites();
            },
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DhikrDetailScreen(
                    items: _favoriteItems,
                    initialIndex: index,
                    module: widget.module,
                  ),
                ),
              );
              _loadFavorites();
            },
          );
        },
      ),
    );
  }

  Widget _buildOccasionTile(DhikrOccasion occasion, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: InkWell(
        onTap: () => _openOccasion(occasion),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getIconForOccasion(occasion), color: isDark ? AppColors.goldAccent : AppColors.primary, size: 24),
              const SizedBox(height: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    occasion.labelArabic,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForOccasion(DhikrOccasion occasion) {
    switch (occasion) {
      case DhikrOccasion.morning:
        return Icons.wb_sunny_outlined;
      case DhikrOccasion.evening:
        return Icons.nights_stay_outlined;
      case DhikrOccasion.afterPrayer:
        return Icons.check_circle_outline;
      case DhikrOccasion.sleep:
        return Icons.bedtime_outlined;
      case DhikrOccasion.waking:
        return Icons.alarm_outlined;
      case DhikrOccasion.leavingHome:
      case DhikrOccasion.enteringHome:
        return Icons.home_outlined;
      case DhikrOccasion.travel:
        return Icons.flight_takeoff_outlined;
      case DhikrOccasion.food:
        return Icons.restaurant_outlined;
      case DhikrOccasion.difficulty:
        return Icons.healing_outlined;
      case DhikrOccasion.taharah:
        return Icons.water_drop_outlined;
      case DhikrOccasion.mosque:
        return Icons.mosque_outlined;
      case DhikrOccasion.prayer:
        return Icons.accessibility_new_outlined;
      case DhikrOccasion.clothing:
        return Icons.checkroom_outlined;
      case DhikrOccasion.illness:
        return Icons.medical_services_outlined;
      case DhikrOccasion.weather:
        return Icons.cloud_outlined;
      case DhikrOccasion.funerals:
        return Icons.account_balance_outlined;
      case DhikrOccasion.fasting:
        return Icons.nightlight_round_outlined;
      case DhikrOccasion.gatherings:
        return Icons.groups_outlined;
      case DhikrOccasion.general:
        return Icons.format_quote_outlined;
    }
  }

  void _openOccasion(DhikrOccasion occasion) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OccasionAdhkarScreen(occasion: occasion, module: widget.module),
      ),
    );
  }
}
