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
    this.grandTracksCount = 0,
    this.coursesCount = 0,
    this.lessonsCount = 0,
    this.quizzesCount = 0,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          if (isCompact) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.military_tech_rounded, size: 16, color: Color(0xFF0F5132)),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'صرح الأكاديمية',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    _buildMasteryBadge(),
                  ],
                ),

                const SizedBox(height: 8),
                Divider(height: 1, color: Colors.grey.withAlpha(40)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildStatItem(context, '$grandTracksCount', 'كليات', Icons.account_balance)),
                    _buildDivider(),
                    Expanded(child: _buildStatItem(context, '$coursesCount', 'مقررات', Icons.menu_book)),
                    _buildDivider(),
                    Expanded(child: _buildStatItem(context, '$lessonsCount', 'دروساً', Icons.article_outlined)),
                    _buildDivider(),
                    Expanded(child: _buildStatItem(context, '$quizzesCount', 'اختباراً', Icons.quiz_outlined)),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: _buildStatItem(context, '$grandTracksCount', 'كليات كبرى', Icons.account_balance)),
                    _buildDivider(),
                    Expanded(child: _buildStatItem(context, '$coursesCount', 'مقرراً', Icons.menu_book)),
                    _buildDivider(),
                    Expanded(child: _buildStatItem(context, '$lessonsCount', 'درساً تأصيلياً', Icons.article_outlined)),
                    _buildDivider(),
                    Expanded(child: _buildStatItem(context, '$quizzesCount', 'اختباراً', Icons.quiz_outlined)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildMasteryBadge(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMasteryBadge() {
    final pct = overallMastery.clamp(0.0, 100.0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F5132).withAlpha(15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              value: (pct / 100.0).clamp(0.0, 1.0),
              strokeWidth: 3,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F5132)),
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${pct.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F5132),
                ),
              ),
              Text(
                'إتقانك',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF0F5132)),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 22,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: Colors.grey.withAlpha(60),
    );
  }
}

