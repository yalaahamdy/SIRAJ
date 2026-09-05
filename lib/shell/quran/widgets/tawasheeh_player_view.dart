import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/cairo_radio_station.dart';
import '../../../../modules/quran/domain/tawasheeh_item.dart';
import '../../../../modules/quran/services/cairo_radio_audio_service.dart';
import '../../../../modules/quran/services/tawasheeh_offline_audio_service.dart';
import '../../../../modules/quran/store/tawasheeh_store.dart';
import '../../theme/app_colors.dart';
import 'tawasheeh_offline_action_bar.dart';

/// Interactive player and catalog interface for the 80 rare Tawasheeh recordings (§14, §20).
class TawasheehPlayerView extends StatefulWidget {
  final CairoRadioAudioService radioService;
  final TawasheehStore tawasheehStore;

  const TawasheehPlayerView({
    super.key,
    required this.radioService,
    required this.tawasheehStore,
  });

  @override
  State<TawasheehPlayerView> createState() => _TawasheehPlayerViewState();
}

class _TawasheehPlayerViewState extends State<TawasheehPlayerView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final AnimationController _waveAnimController;

  StreamSubscription<CairoRadioStatus>? _statusSub;
  StreamSubscription<TawasheehItem?>? _tawasheehSub;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;
  StreamSubscription<Duration?>? _sleepSub;

  CairoRadioStatus _status = CairoRadioStatus.idle;
  TawasheehItem? _currentTawasheeh;
  Duration _currentPos = Duration.zero;
  Duration _totalDur = Duration.zero;
  Duration? _sleepRemaining;

  String _selectedReciter = 'الكل';
  String _searchQuery = '';
  bool _isSeeking = false;
  double _dragSeekSec = 0.0;
  final Set<String> _downloadingIds = {};

  Future<void> _handleDownloadTrack(TawasheehItem item) async {
    if (_downloadingIds.contains(item.id)) return;
    setState(() => _downloadingIds.add(item.id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جارٍ تنزيل "${item.cleanTitle}" للاستماع بدون إنترنت...'),
        duration: const Duration(seconds: 2),
      ),
    );

    final success = await TawasheehOfflineAudioService.instance.downloadTawasheehItem(
      item,
      onError: (err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err), backgroundColor: AppColors.error),
          );
        }
      },
    );

    if (mounted) {
      setState(() => _downloadingIds.remove(item.id));
      if (success) {
        final path = await TawasheehOfflineAudioService.instance.getLocalFilePath(item);
        if (!mounted) return;
        if (path != null) {
          widget.tawasheehStore.updateLocalPath(item.id, path);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تنزيل "${item.cleanTitle}" بنجاح ومتاح الآن أوفلاين!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _status = widget.radioService.status;
    _currentTawasheeh = widget.radioService.currentTawasheeh;
    _currentPos = widget.radioService.currentPosition;
    _totalDur = widget.radioService.totalDuration;
    _sleepRemaining = widget.radioService.sleepTimerRemaining;

    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (_status == CairoRadioStatus.playing) {
      _waveAnimController.repeat(reverse: true);
    }

    _statusSub = widget.radioService.statusStream.listen((s) {
      if (mounted) {
        setState(() => _status = s);
        if (s == CairoRadioStatus.playing) {
          if (!_waveAnimController.isAnimating) _waveAnimController.repeat(reverse: true);
        } else {
          _waveAnimController.stop();
        }
      }
    });

    _tawasheehSub = widget.radioService.currentTawasheehStream.listen((it) {
      if (mounted) setState(() => _currentTawasheeh = it);
    });

    _posSub = widget.radioService.positionStream.listen((pos) {
      if (mounted && !_isSeeking) {
        setState(() => _currentPos = pos);
      }
    });

    _durSub = widget.radioService.durationStream.listen((dur) {
      if (mounted) setState(() => _totalDur = dur);
    });

    _sleepSub = widget.radioService.sleepTimerStream.listen((rem) {
      if (mounted) setState(() => _sleepRemaining = rem);
    });
  }

  @override
  void dispose() {
    _waveAnimController.dispose();
    _searchController.dispose();
    _statusSub?.cancel();
    _tawasheehSub?.cancel();
    _posSub?.cancel();
    _durSub?.cancel();
    _sleepSub?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredItems = widget.tawasheehStore.filter(
      query: _searchQuery,
      reciter: _selectedReciter,
    );
    final reciters = widget.tawasheehStore.getReciters();

    return Column(
      children: [
        // 1. Hero Player Card for Current Track
        _buildHeroPlayer(context, isDark, filteredItems),

        const SizedBox(height: 12),

        // 2. Sleep Timer Strip
        _buildSleepTimerStrip(context, isDark),

        const SizedBox(height: 10),

        // 3. Offline Storage & ZIP Import Action Bar
        TawasheehOfflineActionBar(
          tawasheehStore: widget.tawasheehStore,
          onDataChanged: () => setState(() {}),
        ),

        const SizedBox(height: 12),

        // 4. Search and Reciter Filter Chips
        _buildSearchAndFilters(context, isDark, reciters, filteredItems.length),

        const SizedBox(height: 10),

        // 5. Playlist of Recordings
        _buildRecordingsList(context, isDark, filteredItems),
      ],
    );
  }

  Widget _buildHeroPlayer(
    BuildContext context,
    bool isDark,
    List<TawasheehItem> currentFilteredList,
  ) {
    final isPlaying = _status == CairoRadioStatus.playing;
    final isConnecting = _status == CairoRadioStatus.connecting;
    final hasTrack = _currentTawasheeh != null;

    final effectivePosSec = _isSeeking
        ? _dragSeekSec
        : _currentPos.inSeconds.toDouble();
    final totalSec = _totalDur.inSeconds > 0
        ? _totalDur.inSeconds.toDouble()
        : (_currentTawasheeh?.durationSeconds ?? 1.0);
    final sliderVal = effectivePosSec.clamp(0.0, totalSec);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFFFFDF9), const Color(0xFFF5EFE6)],
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
          // Header Badge: Category & Track counter
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
                    Icon(
                      Icons.mic_external_on_rounded,
                      size: 14,
                      color: isDark ? AppColors.goldAccentLight : AppColors.goldAccent,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'ابتهالات وتواشيح نادرة',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasTrack)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isPlaying ? Colors.green : Colors.grey.shade400,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isPlaying ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isPlaying ? 'قيد الاستماع' : (isConnecting ? 'تحميل...' : 'متوقف'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isPlaying ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // Track Title and Reciter
          if (hasTrack) ...[
            Text(
              _currentTawasheeh!.cleanTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 19,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'الشيخ ${_currentTawasheeh!.reciter}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  icon: Icon(
                    widget.tawasheehStore.isFavorite(_currentTawasheeh!.id)
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: widget.tawasheehStore.isFavorite(_currentTawasheeh!.id)
                        ? Colors.redAccent
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                    size: 20,
                  ),
                  tooltip: widget.tawasheehStore.isFavorite(_currentTawasheeh!.id)
                      ? 'إزالة من المفضلة'
                      : 'إضافة إلى المفضلة',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () async {
                    await widget.tawasheehStore.toggleFavorite(_currentTawasheeh!.id);
                    setState(() {});
                  },
                ),
              ],
            ),
          ] else ...[
            const Icon(
              Icons.graphic_eq_rounded,
              size: 46,
              color: AppColors.goldAccent,
            ),
            const SizedBox(height: 8),
            const Text(
              'اختر ابتهالاً من القائمة للاستماع',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'تراث عريق يضم 80 تسجيلاً لكبار مبتهلي مصر والعالم الإسلامي',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Audio Waves Animation
          if (isPlaying)
            AnimatedBuilder(
              animation: _waveAnimController,
              builder: (context, _) {
                final val = _waveAnimController.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildWaveBar(12 + val * 14, AppColors.goldAccent),
                    _buildWaveBar(22 - val * 12, AppColors.goldAccent),
                    _buildWaveBar(10 + val * 18, AppColors.goldAccent),
                    _buildWaveBar(24 - val * 16, AppColors.goldAccent),
                    _buildWaveBar(14 + val * 10, AppColors.goldAccent),
                  ],
                );
              },
            )
          else
            const SizedBox(height: 24),

          // Interactive Progress Slider
          if (hasTrack) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppColors.goldAccent,
                  inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
                  thumbColor: AppColors.goldAccent,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  trackHeight: 4,
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                ),
                child: Slider(
                  value: sliderVal,
                  min: 0.0,
                  max: totalSec > 0 ? totalSec : 1.0,
                  onChangeStart: (val) {
                    setState(() {
                      _isSeeking = true;
                      _dragSeekSec = val;
                    });
                  },
                  onChanged: (val) {
                    setState(() => _dragSeekSec = val);
                  },
                  onChangeEnd: (val) async {
                    _isSeeking = false;
                    await widget.radioService.seek(Duration(seconds: val.toInt()));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(Duration(seconds: sliderVal.toInt())),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    _formatDuration(Duration(seconds: totalSec.toInt())),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Control Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Repeat Button
              IconButton(
                icon: Icon(
                  widget.radioService.isRepeat
                      ? Icons.repeat_one_rounded
                      : Icons.repeat_rounded,
                ),
                iconSize: 22,
                color: widget.radioService.isRepeat
                    ? AppColors.goldAccent
                    : (isDark ? Colors.grey[500] : Colors.grey[400]),
                tooltip: widget.radioService.isRepeat ? 'إلغاء التكرار' : 'تكرار الابتهال',
                onPressed: () {
                  setState(() => widget.radioService.toggleRepeat());
                },
              ),

              // Previous Track
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                iconSize: 28,
                tooltip: 'الابتهال السابق',
                onPressed: hasTrack ? () => widget.radioService.previousTawasheeh() : null,
              ),

              // Seek -10s
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                iconSize: 24,
                tooltip: 'ترجيع 10 ثوانٍ',
                onPressed: hasTrack
                    ? () {
                        final newPos = Duration(seconds: (_currentPos.inSeconds - 10).clamp(0, totalSec.toInt()));
                        widget.radioService.seek(newPos);
                      }
                    : null,
              ),

              const SizedBox(width: 6),

              // Main Hero Play/Pause
              if (isConnecting)
                const SizedBox(
                  width: 58,
                  height: 58,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.goldAccent,
                    ),
                  ),
                )
              else
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
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        widget.radioService.pause();
                      } else {
                        if (hasTrack) {
                          widget.radioService.play();
                        } else if (currentFilteredList.isNotEmpty) {
                          widget.radioService.playTawasheeh(
                            currentFilteredList.first,
                            playlist: currentFilteredList,
                          );
                        }
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
                    iconSize: 44,
                    padding: const EdgeInsets.all(10),
                    tooltip: isPlaying ? 'إيقاف مؤقت' : 'تشغيل',
                  ),
                ),

              const SizedBox(width: 6),

              // Seek +10s
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                iconSize: 24,
                tooltip: 'تقديم 10 ثوانٍ',
                onPressed: hasTrack
                    ? () {
                        final newPos = Duration(seconds: (_currentPos.inSeconds + 10).clamp(0, totalSec.toInt()));
                        widget.radioService.seek(newPos);
                      }
                    : null,
              ),

              // Next Track
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: 28,
                tooltip: 'الابتهال التالي',
                onPressed: hasTrack ? () => widget.radioService.nextTawasheeh() : null,
              ),

              // Shuffle Button
              IconButton(
                icon: const Icon(Icons.shuffle_rounded),
                iconSize: 22,
                color: widget.radioService.isShuffle
                    ? AppColors.goldAccent
                    : (isDark ? Colors.grey[500] : Colors.grey[400]),
                tooltip: widget.radioService.isShuffle ? 'إلغاء الخلط' : 'تشغيل عشوائي',
                onPressed: () {
                  setState(() => widget.radioService.toggleShuffle());
                },
              ),

              const SizedBox(width: 4),

              // Playback Speed Button
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  const speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
                  final curIndex = speeds.indexOf(widget.radioService.playbackSpeed);
                  final nextSpeed = speeds[(curIndex + 1) % speeds.length];
                  widget.radioService.setPlaybackSpeed(nextSpeed);
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: widget.radioService.playbackSpeed != 1.0
                        ? AppColors.goldAccent.withValues(alpha: 0.25)
                        : AppColors.goldAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: widget.radioService.playbackSpeed != 1.0
                          ? AppColors.goldAccent
                          : AppColors.goldAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${widget.radioService.playbackSpeed}x',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTimerStrip(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2129) : const Color(0xFFF9F7F4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.bedtime_rounded, size: 16, color: AppColors.goldAccent),
          const SizedBox(width: 8),
          const Text(
            'مؤقت النوم',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
          ),
          const Spacer(),
          if (_sleepRemaining != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.goldAccent.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
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
              icon: const Icon(Icons.close_rounded, size: 14),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'إلغاء المؤقت',
              onPressed: () => widget.radioService.cancelSleepTimer(),
            ),
          ] else ...[
            Wrap(
              spacing: 6,
              children: [
                _buildSleepChip(RadioSleepTimerDuration.fifteenMinutes),
                _buildSleepChip(RadioSleepTimerDuration.thirtyMinutes),
                _buildSleepChip(RadioSleepTimerDuration.fortyFiveMinutes),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSleepChip(RadioSleepTimerDuration duration) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => widget.radioService.setSleepTimer(duration),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.goldAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.goldAccent.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          duration.labelArabic,
          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    bool isDark,
    List<String> reciters,
    int count,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input Field
        TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() => _searchQuery = val);
          },
          decoration: InputDecoration(
            hintText: 'ابحث في الابتهالات أو اسم المبتهل...',
            hintStyle: TextStyle(
              fontSize: 12.5,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade500,
            ),
            prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.goldAccent),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F0EA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Reciters Horizontal Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: reciters.map((reciter) {
              final isSelected = _selectedReciter == reciter;
              final reciterCount = widget.tawasheehStore.filter(reciter: reciter).length;
              return Padding(
                padding: const EdgeInsets.only(left: 6),
                child: FilterChip(
                  label: Text('$reciter ($reciterCount)'),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedReciter = reciter);
                  },
                  selectedColor: AppColors.goldAccent.withValues(alpha: 0.25),
                  checkmarkColor: AppColors.goldAccent,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.goldAccent : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 6),

        // Results Count Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'عرض $count تسجيلاً نادراً',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingsList(
    BuildContext context,
    bool isDark,
    List<TawasheehItem> items,
  ) {
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 36),
        alignment: Alignment.center,
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'لا توجد ابتهالات تطابق بحثك',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 6),
      itemBuilder: (context, index) {
        final item = items[index];
        final isCurrentItem = _currentTawasheeh?.id == item.id;
        final isPlayingThis = isCurrentItem && _status == CairoRadioStatus.playing;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              if (isCurrentItem) {
                if (isPlayingThis) {
                  widget.radioService.pause();
                } else {
                  widget.radioService.play();
                }
              } else {
                widget.radioService.playTawasheeh(item, playlist: items);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isCurrentItem
                    ? AppColors.goldAccent.withValues(alpha: isDark ? 0.16 : 0.12)
                    : (isDark ? const Color(0xFF161E2E) : const Color(0xFFFAF8F5)),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCurrentItem
                      ? AppColors.goldAccent.withValues(alpha: 0.7)
                      : (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.5),
                  width: isCurrentItem ? 1.4 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Play Indicator / Number Circle
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrentItem
                          ? AppColors.goldAccent
                          : AppColors.goldAccent.withValues(alpha: 0.12),
                    ),
                    child: Center(
                      child: isPlayingThis
                          ? const Icon(Icons.pause_rounded, size: 20, color: Colors.white)
                          : (isCurrentItem
                              ? const Icon(Icons.play_arrow_rounded, size: 20, color: Colors.white)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                                  ),
                                )),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Title and Reciter
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.cleanTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 15,
                            fontWeight: isCurrentItem ? FontWeight.bold : FontWeight.w600,
                            color: isCurrentItem
                                ? (isDark ? AppColors.goldAccentLight : AppColors.primary)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 13,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.reciter,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 6),

                  // Offline Status or Download Action
                  if (item.isOfflineAvailable)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Tooltip(
                        message: 'متاح بدون إنترنت',
                        child: Icon(
                          Icons.offline_pin_rounded,
                          size: 18,
                          color: Colors.green,
                        ),
                      ),
                    )
                  else if (_downloadingIds.contains(item.id))
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.goldAccent,
                        ),
                      ),
                    )
                  else if (item.url.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.download_for_offline_outlined, size: 19),
                      tooltip: 'تنزيل للاستماع بدون إنترنت',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      onPressed: () => _handleDownloadTrack(item),
                    ),
                  const SizedBox(width: 4),

                  // Favorite Action
                  IconButton(
                    icon: Icon(
                      widget.tawasheehStore.isFavorite(item.id)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 18,
                      color: widget.tawasheehStore.isFavorite(item.id)
                          ? Colors.redAccent
                          : (isDark ? Colors.grey[500] : Colors.grey[400]),
                    ),
                    tooltip: widget.tawasheehStore.isFavorite(item.id)
                        ? 'في المفضلة'
                        : 'إضافة للمفضلة',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                    onPressed: () async {
                      await widget.tawasheehStore.toggleFavorite(item.id);
                      setState(() {});
                    },
                  ),

                  const SizedBox(width: 4),

                  // Duration Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : AppColors.goldAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 11,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          item.duration,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                          ),
                        ),
                      ],
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

  Widget _buildWaveBar(double height, Color color) {
    return Container(
      width: 3.5,
      height: height.clamp(4.0, 26.0),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
