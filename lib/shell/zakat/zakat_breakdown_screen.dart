import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/zakat_calculation_result.dart';
import '../../../modules/zakat/zakat_module.dart';
import '../theme/app_colors.dart';

/// Screen displaying the explainable breakdown of the Zakat calculation (§47, §48).
class ZakatBreakdownScreen extends StatelessWidget {
  final ZakatCalculationResult result;
  final ZakatModule module;

  const ZakatBreakdownScreen({
    super.key,
    required this.result,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تفكيك وشرح حساب الزكاة',
          style: TextStyle(fontSize: 16),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Explanation Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Text(
              result.explanation,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Financial Breakdown Table (§48)
          const Text(
            'جدول الحساب المالي المفصل (§48):',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Column(
              children: [
                _buildTableRow('إجمالي الأصول المقومة', result.grossAssets.format(), false),
                const Divider(height: 1),
                _buildTableRow('الديون والالتزامات المخصومة', '- ${result.deductibleLiabilities.format()}', false),
                const Divider(height: 1),
                _buildTableRow('الوعاء الزكوي الصافي', result.netZakatableBase.format(), true),
                const Divider(height: 1),
                _buildTableRow('حد النصاب الشرعي المقوم', result.nisabThreshold.format(), false),
                const Divider(height: 1),
                _buildTableRow(
                  'حالة الحول الزمني',
                  result.isHawlComplete ? 'مكتمل' : 'متبقي ${result.daysRemainingInHawl} يوم',
                  false,
                ),
                const Divider(height: 1),
                _buildTableRow(
                  'نسبة الزكاة المطبقة',
                  '${(result.appliedRate * 100).toStringAsFixed(3).replaceAll(RegExp(r'\.?0+$'), '')}%',
                  false,
                ),
                const Divider(height: 1),
                _buildTableRow('مبلغ الزكاة المحسوبة', result.zakatDue.format(), true, isHighlighted: true),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Policy & Provenance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.menu_book_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result.policyUsed.nameArabic,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'المرجع الفقهي: ${result.policyUsed.reference}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'بيانات السوق: ${result.marketSnapshotUsed.sourceName}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Save Snapshot Button (§54, §55)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final saveRes = await module.saveSnapshot(result);
              if (context.mounted) {
                if (saveRes.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حفظ لقطة الحساب في السجل التاريخي بنجاح')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تعذر حفظ لقطة الحساب')),
                  );
                }
              }
            },
            icon: const Icon(Icons.bookmark_added_outlined),
            label: const Text('حفظ لقطة الحساب في السجل التاريخي'),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String label, String value, bool isBold, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isHighlighted ? 14 : 12,
                color: isHighlighted ? AppColors.primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
