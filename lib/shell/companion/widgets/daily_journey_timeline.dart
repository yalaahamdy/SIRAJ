import 'package:flutter/material.dart';
import '../../../modules/companion/domain/daily_journey.dart';
import '../../theme/app_colors.dart';

class DailyJourneyTimeline extends StatelessWidget {
  final DailyJourneyRoutine routine;
  final ValueChanged<DailyJourneySlot>? onSlotTap;

  const DailyJourneyTimeline({
    super.key,
    required this.routine,
    this.onSlotTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  routine.nameArabic,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.primaryText(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${routine.completedCount} من ${routine.slots.length}',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText(context)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...routine.slots.map((slot) {
            final slotBg = slot.isCompleted
                ? (isDark ? const Color(0xFF143323) : Colors.green.shade50)
                : (isDark ? const Color(0xFF23282E) : Colors.grey.shade50);
            final slotBorder = slot.isCompleted
                ? (isDark ? const Color(0xFF1D5A3A) : Colors.green.shade200)
                : AppColors.border(context);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () => onSlotTap?.call(slot),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: slotBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: slotBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        slot.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                        color: slot.isCompleted
                            ? (isDark ? AppColors.goldAccentLight : Colors.green.shade700)
                            : AppColors.secondaryText(context),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              slot.titleArabic,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.primaryText(context),
                                decoration: slot.isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            Text(
                              slot.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, color: AppColors.secondaryText(context)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
