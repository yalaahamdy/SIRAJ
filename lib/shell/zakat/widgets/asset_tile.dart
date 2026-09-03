import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/asset_category.dart';
import '../../../modules/zakat/domain/zakat_asset.dart';
import '../../theme/app_colors.dart';

/// Tile displaying an individual user asset with category icon and value (§16, §37).
class AssetTile extends StatelessWidget {
  final ZakatAsset asset;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssetTile({
    super.key,
    required this.asset,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLiability = asset.category.isLiability || asset.isDeductibleDebt;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: isLiability
              ? Colors.red.withValues(alpha: 0.15)
              : AppColors.primary.withValues(alpha: 0.15),
          child: Icon(
            _getCategoryIcon(asset.category),
            color: isLiability ? Colors.red : (isDark ? AppColors.goldAccent : AppColors.primary),
            size: 20,
          ),
        ),
        title: Text(
          asset.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          _getSubtitle(),
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                '${isLiability ? '-' : ''}${asset.amount.format()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isLiability ? Colors.red : (isDark ? AppColors.goldAccent : AppColors.primary),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.withValues(alpha: 0.7)),
              onPressed: onDelete,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }

  String _getSubtitle() {
    if (asset.category == AssetCategory.gold && asset.weightGrams != null) {
      return '${asset.category.labelArabic} • ${asset.weightGrams} جم (عيار ${asset.purityKarat ?? 24})';
    }
    if (asset.category == AssetCategory.silver && asset.weightGrams != null) {
      return '${asset.category.labelArabic} • ${asset.weightGrams} جم';
    }
    return asset.category.labelArabic;
  }

  IconData _getCategoryIcon(AssetCategory category) {
    switch (category) {
      case AssetCategory.cash:
        return Icons.account_balance_wallet_outlined;
      case AssetCategory.gold:
        return Icons.monetization_on_outlined;
      case AssetCategory.silver:
        return Icons.circle_outlined;
      case AssetCategory.tradeGoods:
        return Icons.storefront_outlined;
      case AssetCategory.investments:
        return Icons.trending_up_outlined;
      case AssetCategory.receivables:
        return Icons.request_quote_outlined;
      case AssetCategory.debts:
        return Icons.money_off_outlined;
      case AssetCategory.other:
        return Icons.account_balance_outlined;
    }
  }
}
