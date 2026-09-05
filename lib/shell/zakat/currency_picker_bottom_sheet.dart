import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/zakat_currency.dart';
import '../theme/app_colors.dart';

/// Professional currency picker bottom sheet with search and offline-safe disclosure (§7, §134).
class CurrencyPickerBottomSheet extends StatefulWidget {
  final String selectedCurrencyCode;
  final ValueChanged<ZakatCurrency> onCurrencySelected;

  const CurrencyPickerBottomSheet({
    super.key,
    required this.selectedCurrencyCode,
    required this.onCurrencySelected,
  });

  static Future<ZakatCurrency?> show(
    BuildContext context, {
    required String selectedCurrencyCode,
  }) {
    return showModalBottomSheet<ZakatCurrency>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CurrencyPickerBottomSheet(
        selectedCurrencyCode: selectedCurrencyCode,
        onCurrencySelected: (currency) => Navigator.of(ctx).pop(currency),
      ),
    );
  }

  @override
  State<CurrencyPickerBottomSheet> createState() => _CurrencyPickerBottomSheetState();
}

class _CurrencyPickerBottomSheetState extends State<CurrencyPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<ZakatCurrency> _filteredCurrencies = ZakatCurrency.supportedCurrencies;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCurrencies = ZakatCurrency.supportedCurrencies;
      } else {
        _filteredCurrencies = ZakatCurrency.supportedCurrencies.where((c) {
          return c.nameArabic.toLowerCase().contains(query) ||
              c.nameEnglish.toLowerCase().contains(query) ||
              c.code.toLowerCase().contains(query) ||
              c.symbolArabic.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _handleSelect(ZakatCurrency currency) async {
    if (currency.code == widget.selectedCurrencyCode) {
      widget.onCurrencySelected(currency);
      return;
    }

    // Confirmation disclosure: currency is an accounting unit and does not auto-convert numeric amounts
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تغيير عملة الحساب والعرض'),
        content: Text(
          'سيتم تغيير عملة الحساب إلى ${currency.nameArabic} (${currency.symbolArabic}).\n\n'
          'تنبيه: التغيير يغير وحدة الحساب والعرض للأصول والأسعار، ولا يقوم بتحويل القيم الرقمية تلقائياً بأسعار صرف غير موثوقة دون اتصال.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('تأكيد التغيير'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      widget.onCurrencySelected(currency);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.currency_exchange_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text(
                    'اختر عملة الحساب والعرض',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),

            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'ابحث باسم العملة أو الرمز (مثال: EGP، جنيه، ريال)...',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
              ),
            ),

            // Currencies List
            Expanded(
              child: _filteredCurrencies.isEmpty
                  ? Center(
                      child: Text(
                        'لا توجد عملة مطابقة للبحث',
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _filteredCurrencies.length,
                      separatorBuilder: (ctx, i) => Divider(
                        height: 1,
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                      itemBuilder: (context, index) {
                        final currency = _filteredCurrencies[index];
                        final isSelected = currency.code == widget.selectedCurrencyCode;

                        return ListTile(
                          onTap: () => _handleSelect(currency),
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
                            foregroundColor: isSelected
                                ? Colors.white
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            radius: 20,
                            child: Text(
                              currency.code.substring(0, 2),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                currency.nameArabic,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.primary : null,
                                ),
                              ),
                              if (currency.code == 'EGP') ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'الافتراضية',
                                    style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            '${currency.code} · ${currency.symbolArabic} · ${currency.nameEnglish}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
