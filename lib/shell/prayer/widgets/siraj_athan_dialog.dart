import 'package:flutter/material.dart';
import '../../../modules/prayer/domain/prayer_type.dart';
import '../../../modules/prayer/services/athan_audio_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/siraj_app_logo.dart';

/// نافذة الأذان التفاعلية عند دخول وقت الصلاة
void showSirajAthanDialog({
  required BuildContext context,
  required PrayerType prayerType,
  required DateTime prayerTime,
  required String locationName,
  required AthanAudioService audioService,
  VoidCallback? onMarkPrayed,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => SirajAthanDialog(
      prayerType: prayerType,
      prayerTime: prayerTime,
      locationName: locationName,
      audioService: audioService,
      onMarkPrayed: onMarkPrayed,
    ),
  );
}

class SirajAthanDialog extends StatelessWidget {
  final PrayerType prayerType;
  final DateTime prayerTime;
  final String locationName;
  final AthanAudioService audioService;
  final VoidCallback? onMarkPrayed;

  const SirajAthanDialog({
    super.key,
    required this.prayerType,
    required this.prayerTime,
    required this.locationName,
    required this.audioService,
    this.onMarkPrayed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = '${prayerTime.hour > 12 ? prayerTime.hour - 12 : (prayerTime.hour == 0 ? 12 : prayerTime.hour)}:${prayerTime.minute.toString().padLeft(2, '0')} ${prayerTime.hour >= 12 ? "م" : "ص"}';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Logo and pulsing glow
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDAA520).withValues(alpha: 0.35),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const SirajAppLogo(size: 68, showShadow: false),
              ),
              const SizedBox(height: 14),

              // 2. Title
              Text(
                'حان الآن موعد أذان ${prayerType.nameArabic}',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // 3. Time & Location
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time_rounded, size: 15, color: Color(0xFFDAA520)),
                    const SizedBox(width: 6),
                    Text(
                      timeStr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        locationName,
                        style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. Spiritual Hadith Quote
              Text(
                '«إِذَا حَضَرَتِ الصَّلاَةُ فَلْيُؤَذِّنْ لَكُمْ أَحَدُكُمْ، وَلْيَؤُمَّكُمْ أَكْبَرُكُمْ»',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 14,
                  height: 1.6,
                  color: isDark ? const Color(0xFFCBD5E1) : Colors.grey.shade800,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),

              // 5. Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.volume_off_rounded, size: 18),
                      label: const Text('إيقاف الأذان'),
                      onPressed: () {
                        audioService.stopAthan();
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade400,
                        side: BorderSide(color: Colors.red.shade400.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                      label: const Text('أديت الصلاة'),
                      onPressed: () {
                        audioService.stopAthan();
                        onMarkPrayed?.call();
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  audioService.stopAthan();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'إغلاق',
                  style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
