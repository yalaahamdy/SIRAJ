import 'package:flutter/material.dart';
import '../../../core/audio/siraj_audio_boost_service.dart';
import '../../theme/app_colors.dart';
import 'siraj_audio_boost_sheet.dart';

/// Compact button/badge displaying current boost level and opening the boost controls (§14, §20, §32).
class SirajAudioBoostBadgeButton extends StatelessWidget {
  final bool compact;
  const SirajAudioBoostBadgeButton({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boostService = SirajAudioBoostService.instance;

    return AnimatedBuilder(
      animation: boostService,
      builder: (context, _) {
        final isBoosted = boostService.isBoosted;
        final levelText = '${(boostService.boostLevel * 100).round()}%';

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => SirajAudioBoostSheet.show(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 8 : 10,
                vertical: compact ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: isBoosted
                    ? AppColors.goldAccent.withValues(alpha: 0.22)
                    : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isBoosted
                      ? AppColors.goldAccent
                      : (isDark ? Colors.white24 : Colors.black12),
                  width: isBoosted ? 1.4 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isBoosted ? Icons.bolt_rounded : Icons.volume_up_rounded,
                    size: compact ? 15 : 17,
                    color: isBoosted ? AppColors.goldAccent : (isDark ? Colors.white70 : Colors.black54),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    compact ? levelText : 'تضخيم $levelText',
                    style: TextStyle(
                      fontSize: compact ? 11 : 12,
                      fontWeight: isBoosted ? FontWeight.bold : FontWeight.normal,
                      color: isBoosted
                          ? (isDark ? AppColors.goldAccentLight : AppColors.primary)
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
