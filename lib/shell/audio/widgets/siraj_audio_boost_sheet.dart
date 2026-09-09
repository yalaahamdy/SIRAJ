import 'package:flutter/material.dart';
import '../../../core/audio/siraj_audio_boost_service.dart';
import '../../theme/app_colors.dart';

/// Interactive modal sheet providing intuitive volume amplification controls (§14, §20, §32).
class SirajAudioBoostSheet extends StatelessWidget {
  const SirajAudioBoostSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const SirajAudioBoostSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boostService = SirajAudioBoostService.instance;

    return AnimatedBuilder(
      animation: boostService,
      builder: (context, _) {
        final currentBoost = boostService.boostLevel;
        final percentText = '${(currentBoost * 100).round()}%';
        final isBoosted = boostService.isBoosted;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),

              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.volume_up_rounded,
                          color: AppColors.goldAccent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'ميزة تضخيم الصوت',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ],
                  ),
                  // Percentage Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isBoosted
                          ? AppColors.goldAccent
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      percentText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isBoosted
                            ? Colors.black87
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Text(
                'تتيح لك هذه الميزة مضاعفة مستوى الصوت حتى 200% لتوضيح التسجيلات النادرة والقديمة منخفضة الصوت بنقاء واحترافية.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? Colors.white70 : Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.goldAccent,
                  inactiveTrackColor: AppColors.goldAccent.withValues(alpha: 0.2),
                  thumbColor: AppColors.goldAccent,
                  overlayColor: AppColors.goldAccent.withValues(alpha: 0.15),
                  valueIndicatorColor: AppColors.goldAccent,
                  valueIndicatorTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Slider(
                  value: currentBoost,
                  min: 1.0,
                  max: 2.0,
                  divisions: 10,
                  label: percentText,
                  onChanged: (val) {
                    boostService.setBoostLevel(val);
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Preset Quick Buttons
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: AudioBoostPreset.values.map((preset) {
                  final isSelected = (currentBoost - preset.multiplier).abs() < 0.05;
                  return ChoiceChip(
                    label: Text(preset.label),
                    selected: isSelected,
                    selectedColor: AppColors.goldAccent,
                    labelStyle: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.black87 : (isDark ? Colors.white : Colors.black87),
                    ),
                    onSelected: (_) {
                      boostService.setPreset(preset);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Reset / Close
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isBoosted ? () => boostService.reset() : null,
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('إعادة للوضع الطبيعي (100%)'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white70 : Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('تم', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
