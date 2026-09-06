import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/cairo_radio_station.dart';
import '../../../../modules/quran/services/cairo_radio_audio_service.dart';
import '../../../../modules/quran/store/tawasheeh_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import 'tawasheeh_player_view.dart';

/// Full-featured, spiritual live radio studio interface for Cairo Quran Radio & Historic Tawasheeh (§14, §20).
class CairoRadioLiveView extends StatefulWidget {
  final CairoRadioAudioService radioService;
  final TawasheehStore? tawasheehStore;

  const CairoRadioLiveView({
    super.key,
    required this.radioService,
    this.tawasheehStore,
  });

  @override
  State<CairoRadioLiveView> createState() => _CairoRadioLiveViewState();
}

class _CairoRadioLiveViewState extends State<CairoRadioLiveView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _waveAnimController;
  late final TawasheehStore _tawasheehStore;

  @override
  bool get wantKeepAlive => true;

  StreamSubscription<CairoRadioStatus>? _statusSub;
  StreamSubscription<Duration?>? _sleepSub;
  StreamSubscription<CairoRadioMode>? _modeSub;

  CairoRadioStatus _status = CairoRadioStatus.idle;
  CairoRadioMode _activeMode = CairoRadioMode.liveRadio;
  Duration? _sleepRemaining;
  double _volume = 0.85;
  bool _isMuted = false;
  bool _isLoadingStore = false;

  @override
  void initState() {
    super.initState();
    _tawasheehStore = widget.tawasheehStore ?? TawasheehStore();
    _status = widget.radioService.status;
    _activeMode = widget.radioService.mode;
    _sleepRemaining = widget.radioService.sleepTimerRemaining;
    _volume = widget.radioService.volume;
    _isMuted = widget.radioService.isMuted;

    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (_status == CairoRadioStatus.playing && !Platform.environment.containsKey('FLUTTER_TEST')) {
      _waveAnimController.repeat(reverse: true);
    }

    if (!_tawasheehStore.isLoaded) {
      _isLoadingStore = true;
      _tawasheehStore.load().then((_) {
        if (mounted) setState(() => _isLoadingStore = false);
      });
    }

    _statusSub = widget.radioService.statusStream.listen((newStatus) {
      if (mounted) {
        setState(() => _status = newStatus);
        if (newStatus == CairoRadioStatus.playing) {
          if (!_waveAnimController.isAnimating && !Platform.environment.containsKey('FLUTTER_TEST')) {
            _waveAnimController.repeat(reverse: true);
          }
        } else {
          _waveAnimController.stop();
        }
      }
    });

    _sleepSub = widget.radioService.sleepTimerStream.listen((rem) {
      if (mounted) setState(() => _sleepRemaining = rem);
    });

    _modeSub = widget.radioService.modeStream.listen((mode) {
      if (mounted && _activeMode != mode) {
        setState(() => _activeMode = mode);
      }
    });
  }

  @override
  void dispose() {
    _waveAnimController.dispose();
    _statusSub?.cancel();
    _sleepSub?.cancel();
    _modeSub?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPlaying = _status == CairoRadioStatus.playing;
    final isConnecting = _status == CairoRadioStatus.connecting;
    final isError = _status == CairoRadioStatus.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top Switcher: Live Radio vs Historic Tawasheeh
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          child: _buildModeSwitcher(isDark),
        ),

        Expanded(
          child: _activeMode == CairoRadioMode.tawasheeh
              ? (_isLoadingStore
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: AppColors.goldAccent),
                          SizedBox(height: 12),
                          Text(
                            'جارٍ تحميل أرشيف التواشيح والابتهالات النادرة...',
                            style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : TawasheehPlayerView(
                      radioService: widget.radioService,
                      tawasheehStore: _tawasheehStore,
                    ))
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Radio Station Hero Identity Card
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFFFFDF9), const Color(0xFFF4ECE1)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.goldAccent.withValues(alpha: isDark ? 0.45 : 0.6),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top frequency & transmission badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.goldAccent.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.radio_rounded, size: 14, color: isDark ? AppColors.goldAccentLight : AppColors.goldAccent),
                          const SizedBox(width: 5),
                          Text(
                            'FM 98.2 MHz',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Live Status Badge with pulse
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPlaying
                            ? Colors.green.withValues(alpha: 0.2)
                            : (isConnecting
                                ? Colors.amber.withValues(alpha: 0.2)
                                : Colors.grey.withValues(alpha: 0.15)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isPlaying
                              ? Colors.green
                              : (isConnecting ? Colors.amber : Colors.grey.shade400),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPlaying
                                  ? Colors.green
                                  : (isConnecting ? Colors.amber : Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isPlaying
                                ? 'مباشر • LIVE'
                                : (isConnecting ? 'جارٍ الاتصال...' : 'متوقف'),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isPlaying
                                  ? Colors.green
                                  : (isConnecting ? Colors.amber.shade800 : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Center Emblem & Audio Waves
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.goldAccent.withValues(alpha: isDark ? 0.12 : 0.2),
                    border: Border.all(
                      color: AppColors.goldAccent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.mosque_rounded,
                      size: 46,
                      color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  widget.radioService.station.nameArabic,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.radioService.station.subtitleArabic,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 16),

                // Animated Equalizer Audio Waves when Playing
                if (isPlaying)
                  AnimatedBuilder(
                    animation: _waveAnimController,
                    builder: (context, _) {
                      final val = _waveAnimController.value;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildWaveBar(14 + val * 16, AppColors.goldAccent),
                          _buildWaveBar(24 - val * 14, AppColors.goldAccent),
                          _buildWaveBar(10 + val * 22, AppColors.goldAccent),
                          _buildWaveBar(26 - val * 18, AppColors.goldAccent),
                          _buildWaveBar(16 + val * 12, AppColors.goldAccent),
                        ],
                      );
                    },
                  )
                else
                  const SizedBox(height: 26),

                const SizedBox(height: 14),

                // Primary Play / Pause / Retry Button
                if (isConnecting)
                  const SizedBox(
                    width: 64,
                    height: 64,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  )
                else if (isError)
                  ElevatedButton.icon(
                    onPressed: () => widget.radioService.retry(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('إعادة المحاولة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Stop button
                      IconButton(
                        onPressed: isPlaying || _status == CairoRadioStatus.paused
                            ? () => widget.radioService.stop()
                            : null,
                        icon: const Icon(Icons.stop_rounded),
                        iconSize: 32,
                        tooltip: 'إيقاف البث',
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                      const SizedBox(width: 16),

                      // Large Circular Hero Play/Pause
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFDAA520), Color(0xFFB8860B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDAA520).withValues(alpha: 0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (isPlaying) {
                              widget.radioService.pause();
                            } else {
                              widget.radioService.play();
                            }
                          },
                          icon: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 42,
                            color: Colors.white,
                          ),
                          iconSize: 50,
                          padding: const EdgeInsets.all(12),
                          tooltip: isPlaying ? 'إيقاف مؤقت' : 'تشغيل إذاعة القاهرة',
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Mute / Unmute Button
                      IconButton(
                        onPressed: () async {
                          await widget.radioService.toggleMute();
                          setState(() {
                            _isMuted = widget.radioService.isMuted;
                            _volume = widget.radioService.volume;
                          });
                        },
                        icon: Icon(_isMuted || _volume == 0
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded),
                        iconSize: 28,
                        tooltip: _isMuted ? 'إلغاء الكتم' : 'كتم الصوت',
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ],
                  ),

                const SizedBox(height: 16),

                // Volume Slider
                Row(
                  children: [
                    Icon(
                      _isMuted || _volume == 0 ? Icons.volume_mute_rounded : Icons.volume_down_rounded,
                      size: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.goldAccent,
                          thumbColor: AppColors.goldAccent,
                          inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _isMuted ? 0.0 : _volume,
                          min: 0.0,
                          max: 1.0,
                          onChanged: (val) {
                            setState(() {
                              _volume = val;
                              _isMuted = false;
                            });
                            widget.radioService.setVolume(val);
                          },
                        ),
                      ),
                    ),
                    Icon(
                      Icons.volume_up_rounded,
                      size: 20,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 2. Sleep Timer Card (مؤقت النوم)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B2129) : const Color(0xFFF9F7F4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bedtime_rounded, size: 18, color: AppColors.goldAccent),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'مؤقت النوم (إيقاف تلقائي للبث)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                    ),
                    if (_sleepRemaining != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'متبقٍ ${_formatDuration(_sleepRemaining!)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldAccent,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 16),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'إلغاء المؤقت',
                        onPressed: () => widget.radioService.cancelSleepTimer(),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: RadioSleepTimerDuration.values.map((duration) {
                      final isSelected = widget.radioService.activeSleepDuration == duration;
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ChoiceChip(
                          label: Text(duration.labelArabic),
                          selected: isSelected,
                          onSelected: (_) {
                            widget.radioService.setSleepTimer(duration);
                          },
                          selectedColor: AppColors.goldAccent.withValues(alpha: 0.25),
                          labelStyle: TextStyle(
                            fontSize: 11.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.goldAccent : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 3. Historical Provenance & Heritage Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF3F0EA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.goldAccent.withValues(alpha: isDark ? 0.3 : 0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.history_edu_rounded, size: 18, color: AppColors.goldAccent),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'أصالة إذاعة القرآن الكريم من القاهرة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.radioService.station.historicalNote,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.6,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  ),
],
);
}

  Widget _buildModeSwitcher(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1EBE0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldAccent.withValues(alpha: isDark ? 0.35 : 0.45),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildModeTab(
              title: 'إذاعة القرآن (القاهرة)',
              icon: Icons.radio_rounded,
              isSelected: _activeMode == CairoRadioMode.liveRadio,
              onTap: () {
                setState(() => _activeMode = CairoRadioMode.liveRadio);
                widget.radioService.setMode(CairoRadioMode.liveRadio);
              },
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildModeTab(
              title: 'التواشيح والابتهالات',
              icon: Icons.mic_external_on_rounded,
              isSelected: _activeMode == CairoRadioMode.tawasheeh,
              onTap: () {
                setState(() => _activeMode = CairoRadioMode.tawasheeh);
                widget.radioService.setMode(CairoRadioMode.tawasheeh);
              },
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF0F172A) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.65),
                  width: 1.2,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected
                  ? AppColors.goldAccent
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? (isDark ? AppColors.goldAccentLight : AppColors.primary)
                      : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveBar(double height, Color color) {
    return Container(
      width: 4,
      height: height.clamp(4.0, 32.0),
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
