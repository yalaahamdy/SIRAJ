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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final isFav = _favoriteIds.contains(item.id);
                    return DhikrCard(
                      item: item,
                      isFavorite: isFav,
                      onToggleFavorite: () => _toggleFavorite(item.id),
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DhikrDetailScreen(
                              item: item,
                              module: widget.module,
                            ),
                          ),
                        );
                        _loadItems();
                      },
                    );
                  },
                ),
    );
  }
}
