import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/cairo_radio_station.dart';
import '../../../../modules/quran/domain/tawasheeh_item.dart';
import '../../../../modules/quran/services/cairo_radio_audio_service.dart';
import '../../../../modules/quran/services/tawasheeh_offline_audio_service.dart';
import '../../../../modules/quran/store/tawasheeh_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
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
  StreamSubscription<Duration?>? _sleepSub;

  CairoRadioStatus _status = CairoRadioStatus.idle;
  TawasheehItem? _currentTawasheeh;
  Duration? _sleepRemaining;

  String _selectedReciter = 'الكل';
  String _searchQuery = '';
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

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
          sliver: SliverToBoxAdapter(
            child: Column(
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
              ],
            ),
          ),
        ),

        if (filteredItems.isEmpty)
          SliverToBoxAdapter(
            child: _buildEmptyState(isDark),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            sliver: SliverList.separated(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildRecordingCard(context, isDark, item, index, filteredItems);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 6),
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 24),
        ),
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
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
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'ابتهالات وتواشيح نادرة',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (hasTrack) ...[
                const SizedBox(width: 6),
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
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isPlaying ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'الشيخ ${_currentTawasheeh!.reciter}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.goldAccent,
                      ),
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
              'تراث عريق يضم ${widget.tawasheehStore.allItems.isNotEmpty ? widget.tawasheehStore.allItems.length : 317} تسجيلاً نادراً لكبار مبتهلي مصر والعالم الإسلامي',
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
          if (hasTrack)
            _TawasheehProgressSlider(
              radioService: widget.radioService,
              isDark: isDark,
              currentTrack: _currentTawasheeh,
            ),

          const SizedBox(height: 10),

          // Level 1: Main Playback Transport Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Previous Track
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                iconSize: 28,
                tooltip: 'الابتهال السابق',
                onPressed: hasTrack ? () => widget.radioService.previousTawasheeh() : null,
              ),
              const SizedBox(width: 4),

              // Seek -10s
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                iconSize: 24,
                tooltip: 'ترجيع 10 ثوانٍ',
                onPressed: hasTrack
                    ? () {
                        final cur = widget.radioService.currentPosition;
                        final total = widget.radioService.totalDuration;
                        final maxSec = total.inSeconds > 0 ? total.inSeconds : 3600;
                        final newPos = Duration(seconds: (cur.inSeconds - 10).clamp(0, maxSec));
                        widget.radioService.seek(newPos);
                      }
                    : null,
              ),
              const SizedBox(width: 8),

              // Main Hero Play/Pause
              if (isConnecting)
                const SizedBox(
                  width: 54,
                  height: 54,
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
                        blurRadius: 12,
                        spreadRadius: 1,
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
                      size: 32,
                      color: Colors.white,
                    ),
                    iconSize: 42,
                    padding: const EdgeInsets.all(8),
                    tooltip: isPlaying ? 'إيقاف مؤقت' : 'تشغيل',
                  ),
                ),
              const SizedBox(width: 8),

              // Seek +10s
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                iconSize: 24,
                tooltip: 'تقديم 10 ثوانٍ',
                onPressed: hasTrack
                    ? () {
                        final cur = widget.radioService.currentPosition;
                        final total = widget.radioService.totalDuration;
                        final maxSec = total.inSeconds > 0 ? total.inSeconds : 3600;
                        final newPos = Duration(seconds: (cur.inSeconds + 10).clamp(0, maxSec));
                        widget.radioService.seek(newPos);
                      }
                    : null,
              ),
              const SizedBox(width: 4),

              // Next Track
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: 28,
                tooltip: 'الابتهال التالي',
                onPressed: hasTrack ? () => widget.radioService.nextTawasheeh() : null,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Level 2: Secondary Controls (Repeat, Shuffle, Playback Speed)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Repeat Button
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() => widget.radioService.toggleRepeat());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.radioService.isRepeat
                                ? Icons.repeat_one_rounded
                                : Icons.repeat_rounded,
                            size: 16,
                            color: widget.radioService.isRepeat
                                ? AppColors.goldAccent
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'تكرار',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: widget.radioService.isRepeat ? FontWeight.bold : FontWeight.normal,
                              color: widget.radioService.isRepeat
                                  ? AppColors.goldAccent
                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(width: 1, height: 16, color: isDark ? Colors.white12 : Colors.black12),

                // Shuffle Button
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() => widget.radioService.toggleShuffle());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shuffle_rounded,
                            size: 16,
                            color: widget.radioService.isShuffle
                                ? AppColors.goldAccent
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'عشوائي',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: widget.radioService.isShuffle ? FontWeight.bold : FontWeight.normal,
                              color: widget.radioService.isShuffle
                                  ? AppColors.goldAccent
                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(width: 1, height: 16, color: isDark ? Colors.white12 : Colors.black12),

                // Playback Speed Button
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      const speeds = [0.75, 1.0, 1.25, 1.5, 2.0];
                      final curIndex = speeds.indexOf(widget.radioService.playbackSpeed);
                      final nextSpeed = speeds[(curIndex + 1) % speeds.length];
                      widget.radioService.setPlaybackSpeed(nextSpeed);
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.speed_rounded,
                            size: 16,
                            color: widget.radioService.playbackSpeed != 1.0
                                ? AppColors.goldAccent
                                : (isDark ? Colors.grey[400] : Colors.grey[600]),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.radioService.playbackSpeed}x',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: widget.radioService.playbackSpeed != 1.0
                                  ? AppColors.goldAccent
                                  : (isDark ? Colors.grey[400] : Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepTimerStrip(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2129) : const Color(0xFFF9F7F4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (isDark ? AppColors.borderDark : AppColors.borderLight).withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bedtime_rounded, size: 16, color: AppColors.goldAccent),
              const SizedBox(width: 6),
              const Text(
                'مؤقت النوم',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _sleepRemaining != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSleepChip(RadioSleepTimerDuration.fifteenMinutes),
                        const SizedBox(width: 4),
                        _buildSleepChip(RadioSleepTimerDuration.thirtyMinutes),
                        const SizedBox(width: 4),
                        _buildSleepChip(RadioSleepTimerDuration.fortyFiveMinutes),
                      ],
                    ),
                  ),
          ),
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

  Widget _buildEmptyState(bool isDark) {
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

  Widget _buildRecordingCard(
    BuildContext context,
    bool isDark,
    TawasheehItem item,
    int index,
    List<TawasheehItem> items,
  ) {
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

              // Title and Reciter + Duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.cleanTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 15,
                        height: 1.3,
                        fontWeight: isCurrentItem ? FontWeight.bold : FontWeight.w600,
                        color: isCurrentItem
                            ? (isDark ? AppColors.goldAccentLight : AppColors.primary)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline_rounded,
                          size: 13,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            item.reciter,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        if (item.duration.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              '•',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            item.duration,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              // Actions Group: Offline Status, Download, and Favorite
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Offline Status or Download Action
                  if (item.isOfflineAvailable)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Tooltip(
                        message: 'متاح بدون إنترنت',
                        child: Icon(
                          Icons.offline_pin_rounded,
                          size: 19,
                          color: Colors.green,
                        ),
                      ),
                    )
                  else if (_downloadingIds.contains(item.id))
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.goldAccent,
                        ),
                      ),
                    )
                  else if (item.url.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.download_for_offline_outlined, size: 20),
                      tooltip: 'تنزيل للاستماع بدون إنترنت',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      onPressed: () => _handleDownloadTrack(item),
                    ),

                  const SizedBox(width: 2),

                  // Favorite Action
                  IconButton(
                    icon: Icon(
                      widget.tawasheehStore.isFavorite(item.id)
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 19,
                      color: widget.tawasheehStore.isFavorite(item.id)
                          ? Colors.redAccent
                          : (isDark ? Colors.grey[500] : Colors.grey[400]),
                    ),
                    tooltip: widget.tawasheehStore.isFavorite(item.id)
                        ? 'في المفضلة'
                        : 'إضافة للمفضلة',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                    onPressed: () async {
                      await widget.tawasheehStore.toggleFavorite(item.id);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

/// Localized progress slider widget that listens to audio player position ticks,
/// isolating high-frequency UI updates from the parent Tawasheeh playlist.
class _TawasheehProgressSlider extends StatefulWidget {
  final CairoRadioAudioService radioService;
  final bool isDark;
  final TawasheehItem? currentTrack;

  const _TawasheehProgressSlider({
    required this.radioService,
    required this.isDark,
    required this.currentTrack,
  });

  @override
  State<_TawasheehProgressSlider> createState() => _TawasheehProgressSliderState();
}

class _TawasheehProgressSliderState extends State<_TawasheehProgressSlider> {
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;

  Duration _currentPos = Duration.zero;
  Duration _totalDur = Duration.zero;
  bool _isSeeking = false;
  double _dragSeekSec = 0.0;

  @override
  void initState() {
    super.initState();
    _currentPos = widget.radioService.currentPosition;
    _totalDur = widget.radioService.totalDuration;

    _posSub = widget.radioService.positionStream.listen((pos) {
      if (mounted && !_isSeeking) {
        setState(() => _currentPos = pos);
      }
    });

    _durSub = widget.radioService.durationStream.listen((dur) {
      if (mounted) {
        setState(() => _totalDur = dur);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _TawasheehProgressSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentTrack?.id != widget.currentTrack?.id) {
      _currentPos = widget.radioService.currentPosition;
      _totalDur = widget.radioService.totalDuration;
    }
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final effectivePosSec = _isSeeking
        ? _dragSeekSec
        : _currentPos.inSeconds.toDouble();
    final totalSec = _totalDur.inSeconds > 0
        ? _totalDur.inSeconds.toDouble()
        : (widget.currentTrack?.durationSeconds ?? 1.0);
    final sliderVal = effectivePosSec.clamp(0.0, totalSec);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.goldAccent,
              inactiveTrackColor: widget.isDark ? Colors.grey[800] : Colors.grey[300],
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
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                _formatDuration(Duration(seconds: totalSec.toInt())),
                style: TextStyle(
                  fontSize: 11,
                  color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
