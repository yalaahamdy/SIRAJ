import 'package:flutter/material.dart';
import '../../../modules/prayer/domain/prayer_type.dart';
import '../../../modules/prayer/services/athan_audio_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/siraj_app_logo.dart';

/// شاشة الأذان الشريف الكاملة والتفاعلية (§17, §32)
/// تفتح عند حلول وقت الصلاة أو النقر على إشعار الأذان بتصميم روحاني فاخر.
class SirajAthanFullScreenView extends StatefulWidget {
  final PrayerType prayerType;
  final DateTime prayerTime;
  final String locationName;
  final AthanAudioService audioService;
  final VoidCallback? onMarkPrayed;
  final VoidCallback? onOpenQiblah;
  final VoidCallback? onOpenAdhkar;

  const SirajAthanFullScreenView({
    super.key,
    required this.prayerType,
    required this.prayerTime,
    required this.locationName,
    required this.audioService,
    this.onMarkPrayed,
    this.onOpenQiblah,
    this.onOpenAdhkar,
  });

  static Future<void> show(
    BuildContext context, {
    required PrayerType prayerType,
    required DateTime prayerTime,
    required String locationName,
    required AthanAudioService audioService,
    VoidCallback? onMarkPrayed,
    VoidCallback? onOpenQiblah,
    VoidCallback? onOpenAdhkar,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => SirajAthanFullScreenView(
          prayerType: prayerType,
          prayerTime: prayerTime,
          locationName: locationName,
          audioService: audioService,
          onMarkPrayed: onMarkPrayed,
          onOpenQiblah: onOpenQiblah,
          onOpenAdhkar: onOpenAdhkar,
        ),
      ),
    );
  }

  @override
  State<SirajAthanFullScreenView> createState() => _SirajAthanFullScreenViewState();
}

class _SirajAthanFullScreenViewState extends State<SirajAthanFullScreenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${widget.prayerTime.hour > 12 ? widget.prayerTime.hour - 12 : (widget.prayerTime.hour == 0 ? 12 : widget.prayerTime.hour)}:${widget.prayerTime.minute.toString().padLeft(2, '0')} ${widget.prayerTime.hour >= 12 ? "م" : "ص"}';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF071B2F),
              Color(0xFF0F2B48),
              Color(0xFF091421),
            ],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<bool>(
            stream: widget.audioService.isPlayingStream,
            initialData: widget.audioService.isPlaying,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 1. Top Bar: Close / Dismiss
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.close_rounded, color: Colors.white70, size: 26),
                                  tooltip: 'إغلاق',
                                ),
                              ),

                              const Spacer(flex: 1),

                              // 2. Central Glowing Pulse with Siraj Emblem
                              ScaleTransition(
                                scale: isPlaying ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFDAA520).withValues(alpha: isPlaying ? 0.45 : 0.2),
                                        blurRadius: 36,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: const SirajAppLogo(size: 96, showShadow: false),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // 3. Status Badge & Prayer Title
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDAA520).withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFDAA520).withValues(alpha: 0.45),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isPlaying ? Icons.graphic_eq_rounded : Icons.notifications_active_rounded,
                                      size: 16,
                                      color: const Color(0xFFE5C07B),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isPlaying ? 'الأذان يرتفع الآن' : 'دخل وقت الصلاة',
                                      style: const TextStyle(
                                        color: Color(0xFFE5C07B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              Text(
                                'صلاة ${widget.prayerType.nameArabic}',
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Time and Location
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFFDAA520)),
                                  const SizedBox(width: 6),
                                  Text(
                                    timeStr,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text('•', style: TextStyle(color: Colors.white38)),
                                  const SizedBox(width: 10),
                                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      widget.locationName,
                                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Sheikh Abdulbasit Tribute Card
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.record_voice_over_rounded, size: 16, color: Color(0xFFE5C07B)),
                                    SizedBox(width: 8),
                                    Text(
                                      'أذان القاهرة — بصوت فضيلة الشيخ عبد الباسط عبد الصمد',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(flex: 1),

                              // 4. Post-Athan Sacred Du'aa Card
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'دعاء ما بعد الأذان',
                                      style: TextStyle(
                                        color: Color(0xFFDAA520),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '«اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ، وَالصَّلَاةِ القَائِمَةِ، آتِ مُحَمَّدًا الوَسِيلَةَ وَالفَضِيلَةَ، وَابْعَثْهُ مَقَامًا مَحْمُودًا الَّذِي وَعَدْتَهُ»',
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 15.5,
                                        height: 1.8,
                                        color: Colors.grey.shade200,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // 5. Action Buttons
                              Row(
                                children: [
                                  // Stop Athan Button
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        widget.audioService.stopAthan();
                                      },
                                      icon: const Icon(Icons.volume_off_rounded, size: 18),
                                      label: const Text('إيقاف الأذان'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red.shade300,
                                        side: BorderSide(color: Colors.red.shade400.withValues(alpha: 0.6)),
                                        padding: const EdgeInsets.symmetric(vertical: 13),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Prayed Confirmation Button
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed: () {
                                        widget.audioService.stopAthan();
                                        widget.onMarkPrayed?.call();
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(Icons.check_circle_rounded, size: 18),
                                      label: const Text('أديت الصلاة'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: AppColors.goldAccent,
                                        foregroundColor: Colors.black87,
                                        padding: const EdgeInsets.symmetric(vertical: 13),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // 6. Quick Nav: Qiblah & Adhkar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.onOpenQiblah != null) ...[
                                    TextButton.icon(
                                      onPressed: () {
                                        widget.audioService.stopAthan();
                                        Navigator.of(context).pop();
                                        widget.onOpenQiblah?.call();
                                      },
                                      icon: const Icon(Icons.explore_outlined, size: 16, color: Colors.white70),
                                      label: const Text(
                                        'اتجاه القبلة',
                                        style: TextStyle(color: Colors.white70, fontSize: 13),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  if (widget.onOpenAdhkar != null)
                                    TextButton.icon(
                                      onPressed: () {
                                        widget.audioService.stopAthan();
                                        Navigator.of(context).pop();
                                        widget.onOpenAdhkar?.call();
                                      },
                                      icon: const Icon(Icons.auto_stories_outlined, size: 16, color: Colors.white70),
                                      label: const Text(
                                        'أذكار الصلاة',
                                        style: TextStyle(color: Colors.white70, fontSize: 13),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
