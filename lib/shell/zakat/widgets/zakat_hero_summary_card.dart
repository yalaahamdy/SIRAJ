import 'package:flutter/material.dart';
import '../../../modules/zakat/domain/zakat_calculation_result.dart';
import '../../theme/app_colors.dart';

/// Summary card displaying Zakatable Base, Nisab threshold, Hawl, and calculated Zakat (§4..§6, §37).
class ZakatHeroSummaryCard extends StatelessWidget {
  final ZakatCalculationResult result;
  final VoidCallback onExplain;

  const ZakatHeroSummaryCard({
    super.key,
    required this.result,
    required this.onExplain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                  child: Text(
                    result.status.labelArabic,
                    style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
                onPressed: onExplain,
                tooltip: 'تفكيك وشرح الحساب',
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(4),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'مبلغ الزكاة المحسوبة تقديرياً',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            result.zakatDue.format(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildMetricColumn('الوعاء الصافي', result.netZakatableBase.format())),
              const SizedBox(width: 6),
              Expanded(child: _buildMetricColumn('حد النصاب', result.nisabThreshold.format())),
              const SizedBox(width: 6),
              Expanded(
                child: _buildMetricColumn(
                  'الحول',
                  result.isHawlComplete ? 'مكتمل' : 'متبقي ${result.daysRemainingInHawl} يوم',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
