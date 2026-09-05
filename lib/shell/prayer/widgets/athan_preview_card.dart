import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../../modules/prayer/domain/athan_sound_option.dart';
import '../../../modules/prayer/services/athan_audio_service.dart';

/// Interactive audio preview card for Sheikh Abdulbasit's Athan (§32).
class AthanPreviewCard extends StatefulWidget {
  final AthanAudioService audioService;
  final AthanSoundOption soundOption;
  final double volume;

  const AthanPreviewCard({
    super.key,
    required this.audioService,
    this.soundOption = AthanSoundOption.abdulbasit,
    this.volume = 0.85,
  });

  @override
  State<AthanPreviewCard> createState() => _AthanPreviewCardState();
}

class _AthanPreviewCardState extends State<AthanPreviewCard> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.audioService.isPlaying;
  }

  Future<void> _togglePlay() async {
    if (_isPlaying) {
      await widget.audioService.stopAthan();
      if (mounted) setState(() => _isPlaying = false);
    } else {
      if (mounted) setState(() => _isPlaying = true);
      final res = await widget.audioService.playAthan(
        soundOption: widget.soundOption,
        volume: widget.volume,
      );
      if (res.isFailure && mounted) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.failureOrNull?.message ?? 'تعذر تشغيل ملف الأذان'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isPlaying
              ? AppColors.goldAccent
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: _isPlaying ? 1.5 : 1.0,
        ),
        boxShadow: _isPlaying
            ? [
                BoxShadow(
                  color: AppColors.goldAccent.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          // Play / Stop Action Button
          InkWell(
            onTap: _togglePlay,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _isPlaying ? AppColors.goldAccent : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title and Reciter Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.soundOption.displayNameArabic,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isPlaying
                      ? 'جاري الاستماع الآن (أذان نقي بجودة عالية)...'
                      : 'اضغط للاستماع لمعاينة صوت الأذان',
                  style: TextStyle(
                    fontSize: 12,
                    color: _isPlaying ? AppColors.goldAccent : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Audio Wave Indicator
          if (_isPlaying)
            const Icon(
              Icons.graphic_eq_rounded,
              color: AppColors.goldAccent,
              size: 24,
            ),
        ],
      ),
    );
  }
}
