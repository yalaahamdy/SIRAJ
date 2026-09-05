import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';

/// Premium interactive accessible counter widget for Adhkar repetition (§17..§25, §58..§72).
class InteractiveCounterView extends StatelessWidget {
  final int currentCount;
  final int targetCount;
  final bool isSourced;
  final VoidCallback onIncrement;
  final VoidCallback onReset;
  final VoidCallback? onUndo;

  const InteractiveCounterView({
    super.key,
    required this.currentCount,
    required this.targetCount,
    required this.isSourced,
    required this.onIncrement,
    required this.onReset,
    this.onUndo,
  });

  void _handleTap() {
    if (currentCount >= targetCount && targetCount > 0) return;
    HapticFeedback.lightImpact();
    if (currentCount + 1 >= targetCount && targetCount > 0) {
      HapticFeedback.mediumImpact();
    }
    onIncrement();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDone = currentCount >= targetCount && targetCount > 0;
    final progress = targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 0.0;

    return Semantics(
      label: isDone
          ? 'اكتمل الذكر: $currentCount من $targetCount'
          : 'العدد الحالي $currentCount من $targetCount. انقر للمتابعة والعد.',
      button: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Target Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isSourced
                  ? (isDark ? AppColors.primaryLight : AppColors.primary).withValues(alpha: 0.15)
                  : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSourced
                    ? AppColors.primary
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
            ),
            child: Text(
              isSourced ? 'العدد المأثور في السنة: $targetCount' : 'العدد المخصص: $targetCount',
              style: TextStyle(
                fontSize: 13,
                color: isSourced
                    ? (isDark ? AppColors.goldAccent : AppColors.primary)
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Primary Circular Tap Counter
          InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(80),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDone ? Colors.green : (isDark ? AppColors.goldAccent : AppColors.primary),
                    ),
                  ),
                ),
                Container(
                  width: 124,
                  height: 124,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? Colors.green.withValues(alpha: isDark ? 0.2 : 0.12)
                        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                    border: Border.all(
                      color: isDone ? Colors.green : AppColors.primary.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isDone) ...[
                          const Icon(Icons.check_circle, color: Colors.green, size: 42),
                          const SizedBox(height: 2),
                          const Text(
                            'اكتمل',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ] else ...[
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '$currentCount',
                              style: TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.goldAccent : AppColors.primary,
                              ),
                            ),
                          ),
                          Text(
                            'من $targetCount',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Control Actions (Undo & Reset)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              if (currentCount > 0 && onUndo != null)
                TextButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    onUndo!();
                  },
                  icon: const Icon(Icons.undo_rounded, size: 16),
                  label: const Text('تراجع عن آخر عدة'),
                  style: TextButton.styleFrom(
                    foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              TextButton.icon(
                onPressed: () {
                  HapticFeedback.selectionClick();
                  onReset();
                },
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('إعادة ضبط'),
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
