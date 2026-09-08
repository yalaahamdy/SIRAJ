import 'package:flutter/material.dart';
import '../../../modules/prayer/domain/prayer_type.dart';
import '../../../modules/prayer/services/athan_audio_service.dart';
import '../../theme/app_colors.dart';
import '../screens/siraj_athan_full_screen_view.dart';

/// نافذة منبثقة عائمة أنيقة (Heads-Up Overlay Banner) تظهر بأعلى الشاشة عند حلول وقت الصلاة (§17, §32)
class SirajAthanOverlayBanner extends StatelessWidget {
  final PrayerType prayerType;
  final DateTime prayerTime;
  final String locationName;
  final AthanAudioService audioService;
  final VoidCallback onDismiss;
  final VoidCallback? onSnooze;
  final VoidCallback? onMarkPrayed;

  const SirajAthanOverlayBanner({
    super.key,
    required this.prayerType,
    required this.prayerTime,
    required this.locationName,
    required this.audioService,
    required this.onDismiss,
    this.onSnooze,
    this.onMarkPrayed,
  });

  static OverlayEntry show(
    BuildContext context, {
    required PrayerType prayerType,
    required DateTime prayerTime,
    required String locationName,
    required AthanAudioService audioService,
    VoidCallback? onSnooze,
    VoidCallback? onMarkPrayed,
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 10,
        left: 14,
        right: 14,
        child: Material(
          color: Colors.transparent,
          child: SirajAthanOverlayBanner(
            prayerType: prayerType,
            prayerTime: prayerTime,
            locationName: locationName,
            audioService: audioService,
            onDismiss: () => entry.remove(),
            onSnooze: () {
              entry.remove();
              onSnooze?.call();
            },
            onMarkPrayed: () {
              entry.remove();
              onMarkPrayed?.call();
            },
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);
    return entry;
  }

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${prayerTime.hour > 12 ? prayerTime.hour - 12 : (prayerTime.hour == 0 ? 12 : prayerTime.hour)}:${prayerTime.minute.toString().padLeft(2, '0')} ${prayerTime.hour >= 12 ? "م" : "ص"}';

    return Dismissible(
      key: const Key('siraj_athan_overlay_banner'),
      direction: DismissDirection.up,
      onDismissed: (_) => onDismiss(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0C1D2E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFDAA520).withValues(alpha: 0.65),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFFDAA520).withValues(alpha: 0.18),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Glowing Mosque/Azan Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAA520).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDAA520).withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Color(0xFFE5C07B),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                // Title and Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'الله أكبر — صلاة ${prayerType.nameArabic}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: 'Amiri',
                            ),
                          ),
                          const Spacer(),
                          Text(
                            timeStr,
                            style: const TextStyle(
                              color: Color(0xFFE5C07B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'حان موعد الصلاة الآن في $locationName',
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, size: 18, color: Colors.white60),
                  tooltip: 'إغلاق',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Action Buttons Bar
            Row(
              children: [
                // Stop Athan Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      audioService.stopAthan();
                      onDismiss();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade300,
                      side: BorderSide(color: Colors.red.shade400.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('إيقاف', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
                const SizedBox(width: 8),
                // Snooze Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      audioService.stopAthan();
                      onSnooze?.call();
                      onDismiss();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFE5C07B),
                      side: BorderSide(color: const Color(0xFFDAA520).withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('تأجيل 5د', style: TextStyle(fontSize: 12.5)),
                  ),
                ),
                const SizedBox(width: 8),
                // Expand to Full Screen
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () {
                      onDismiss();
                      SirajAthanFullScreenView.show(
                        context,
                        prayerType: prayerType,
                        prayerTime: prayerTime,
                        locationName: locationName,
                        audioService: audioService,
                        onSnooze: onSnooze,
                        onMarkPrayed: onMarkPrayed,
                      );
                    },
                    icon: const Icon(Icons.fullscreen_rounded, size: 16),
                    label: const Text('الشاشة كاملة', style: TextStyle(fontSize: 12.5)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.goldAccent,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
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
