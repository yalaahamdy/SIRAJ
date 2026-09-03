import 'package:flutter/material.dart';
import '../../../modules/fasting/domain/qada_plan.dart';

/// Card showing remaining Qada days, progress, and quick action to manage (§40).
class QadaBalanceCard extends StatelessWidget {
  final QadaPlan plan;
  final VoidCallback onManagePlan;

  const QadaBalanceCard({
    super.key,
    required this.plan,
    required this.onManagePlan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.assignment_turned_in, color: Color(0xFF0F5132)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'خطة ورصيد قضاء الصيام',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onManagePlan,
                  child: const Text('تعديل الخطة'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${plan.remainingDays} يوم متبقي',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'من إجمالي ${plan.totalDays} يوماً (أتممت ${plan.completedDays})',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    value: plan.progressRatio,
                    strokeWidth: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F5132)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
