import 'package:flutter/material.dart';
import '../../modules/adhkar/adhkar_module.dart';
import '../../modules/adhkar/domain/dhikr_item.dart';
import '../../modules/adhkar/domain/dhikr_occasion.dart';
import '../theme/app_colors.dart';
import 'dhikr_detail_screen.dart';
import 'widgets/dhikr_card.dart';

/// Screen listing all Dhikr items for a specific Occasion (§34).
class OccasionAdhkarScreen extends StatefulWidget {
  final DhikrOccasion occasion;
  final AdhkarModule module;

  const OccasionAdhkarScreen({
    super.key,
    required this.occasion,
    required this.module,
  });

  @override
  State<OccasionAdhkarScreen> createState() => _OccasionAdhkarScreenState();
}

class _OccasionAdhkarScreenState extends State<OccasionAdhkarScreen> {
  List<DhikrItem> _items = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final itemsRes = widget.module.getItemsByOccasion(widget.occasion);
    final favsRes = await widget.module.getFavorites();

    if (mounted) {
      setState(() {
        _items = itemsRes.valueOrNull ?? [];
        _favoriteIds = (favsRes.valueOrNull ?? []).map((f) => f.contentId).toSet();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleFavorite(String contentId) async {
    await widget.module.toggleFavorite(contentId);
    final favsRes = await widget.module.getFavorites();
    if (mounted && favsRes.isSuccess) {
      setState(() {
        _favoriteIds = favsRes.valueOrNull!.map((f) => f.contentId).toSet();
      });
    }
  }

  Future<void> _startRoutine([int initialIndex = 0]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DhikrDetailScreen(
          items: _items,
          initialIndex: initialIndex,
          module: widget.module,
        ),
      ),
    );
    _loadItems();
  }

  Widget _buildStartRoutineCard(bool isDark) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: (isDark ? AppColors.goldAccent : AppColors.primary).withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                size: 26,
                color: isDark ? AppColors.goldAccent : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بدء قراءة الورد كاملاً',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_items.length} ذكراً متتابعاً مع عداد ذكي وانتقال تلقائي',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () => _startRoutine(0),
              style: FilledButton.styleFrom(
                backgroundColor: isDark ? AppColors.goldAccent : AppColors.primary,
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('ابدأ الورد', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.occasion.labelArabic),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: Text(
                    'لا توجد أذكار مسجلة لهذه المناسبة حالياً',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildStartRoutineCard(isDark);
                    }
                    final itemIndex = index - 1;
                    final item = _items[itemIndex];
                    final isFav = _favoriteIds.contains(item.id);
                    return DhikrCard(
                      item: item,
                      isFavorite: isFav,
                      onToggleFavorite: () => _toggleFavorite(item.id),
                      onTap: () => _startRoutine(itemIndex),
                    );
                  },
                ),
    );
  }
}
