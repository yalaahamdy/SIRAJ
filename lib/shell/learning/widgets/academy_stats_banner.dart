import 'package:flutter/material.dart';

/// Compact and prestigious milestone banner displaying Academy metrics and student mastery (§4, §26).
class AcademyStatsBanner extends StatelessWidget {
  final int grandTracksCount;
  final int coursesCount;
  final int lessonsCount;
  final int quizzesCount;
  final double overallMastery;

  const AcademyStatsBanner({
    super.key,
    this.grandTracksCount = 12,
    this.coursesCount = 49,
    this.lessonsCount = 302,
    this.quizzesCount = 118,
    required this.overallMastery,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Academy Stats Items
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(context, '$grandTracksCount', 'كليات كبرى', Icons.account_balance),
                _buildDivider(),
                _buildStatItem(context, '$coursesCount', 'مقرراً', Icons.menu_book),
                _buildDivider(),
                _buildStatItem(context, '$lessonsCount', 'درساً تأصيلياً', Icons.article_outlined),
                _buildDivider(),
                _buildStatItem(context, '$quizzesCount', 'اختباراً', Icons.quiz_outlined),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Mini Mastery Circular Progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0F5132).withAlpha(15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    value: overallMastery.clamp(0.0, 1.0),
                    strokeWidth: 3.5,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F5132)),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(overallMastery * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F5132),
                      ),
                    ),
                    Text(
                      'إتقانك',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0F5132)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 24,
      width: 1,
      color: Colors.grey.withAlpha(60),
    );
  }
}
