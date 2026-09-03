import 'package:flutter/material.dart';
import '../../../../modules/quran/services/quran_audio_service.dart';
import '../../theme/app_colors.dart';

/// Sleek, compact floating mini-player for Quran recitation (§17, §18).
/// Appears only when audio is active (playing/paused) and hides when stopped.
class QuranMiniPlayer extends StatelessWidget {
  final AudioPlaybackReport report;
  final String surahNameArabic;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onStop;
  final VoidCallback? onRepeatToggle;

  const QuranMiniPlayer({
    super.key,
    required this.report,
    required this.surahNameArabic,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onStop,
    this.onRepeatToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = report.status == AudioPlaybackStatus.playing;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1B2028).withValues(alpha: 0.96)
              : Colors.white.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.goldAccent.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Close / Stop button
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              tooltip: 'إغلاق المشغل',
              visualDensity: VisualDensity.compact,
              onPressed: onStop,
            ),

            // Ayah context info
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سورة $surahNameArabic • الآية ${report.ayahNumber ?? 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldAccent : AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    report.reciterName,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Previous Ayah
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded, size: 20),
              tooltip: 'الآية السابقة',
              visualDensity: VisualDensity.compact,
              onPressed: onPrevious,
            ),

            // Play / Pause main action
            Material(
              color: AppColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onPlayPause,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),

            // Next Ayah
            IconButton(
              icon: const Icon(Icons.skip_next_rounded, size: 20),
              tooltip: 'الآية التالية',
              visualDensity: VisualDensity.compact,
              onPressed: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
