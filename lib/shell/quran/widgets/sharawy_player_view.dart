import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/cairo_radio_station.dart';
import '../../../../modules/quran/domain/sharawy_item.dart';
import '../../../../modules/quran/services/sharawy_audio_service.dart';
import '../../../../modules/quran/services/sharawy_offline_audio_service.dart';
import '../../../../modules/quran/store/sharawy_store.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Full-featured, responsive, and spiritual interface for Sheikh Mohamed Metwally El-Sharawy's
/// Quran Tafsir Khawatir archive (1,117 historic lessons) (§14, §20, §32).
class SharawyPlayerView extends StatefulWidget {
  final SharawyAudioService audioService;
  final SharawyStore sharawyStore;

  const SharawyPlayerView({
    super.key,
    required this.audioService,
    required this.sharawyStore,
  });

  @override
  State<SharawyPlayerView> createState() => _SharawyPlayerViewState();
}

class _SharawyPlayerViewState extends State<SharawyPlayerView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TextEditingController _searchController;
  late final AnimationController _waveAnimController;

  StreamSubscription<SharawyAudioStatus>? _statusSub;
  StreamSubscription<SharawyItem?>? _itemSub;
  StreamSubscription<Duration?>? _sleepSub;

  SharawyAudioStatus _status = SharawyAudioStatus.idle;
  SharawyItem? _currentItem;
  Duration? _sleepRemaining;

  String _selectedCategory = 'الكل';
  String _searchQuery = '';
  final Set<String> _downloadingIds = {};
  bool _isStorageExpanded = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    _status = widget.audioService.status;
    _currentItem = widget.audioService.currentItem;
    _sleepRemaining = widget.audioService.sleepTimerRemaining;

    _waveAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    if (!widget.sharawyStore.isLoaded) {
      widget.sharawyStore.load().then((_) {
        if (mounted) setState(() {});
      });
    }

    if (_status == SharawyAudioStatus.playing && !Platform.environment.containsKey('FLUTTER_TEST')) {
      _waveAnimController.repeat(reverse: true);
    }

    _statusSub = widget.audioService.statusStream.listen((s) {
      if (mounted) {
        setState(() => _status = s);
        if (s == SharawyAudioStatus.playing) {
          if (!_waveAnimController.isAnimating && !Platform.environment.containsKey('FLUTTER_TEST')) {
            _waveAnimController.repeat(reverse: true);
          }
        } else {
          _waveAnimController.stop();
        }
      }
    });

    _itemSub = widget.audioService.currentItemStream.listen((it) {
      if (mounted) setState(() => _currentItem = it);
    });

    _sleepSub = widget.audioService.sleepTimerStream.listen((rem) {
      if (mounted) setState(() => _sleepRemaining = rem);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _waveAnimController.dispose();
    _statusSub?.cancel();
    _itemSub?.cancel();
    _sleepSub?.cancel();
    super.dispose();
  }

  Future<void> _handleDownload(SharawyItem item) async {
    if (_downloadingIds.contains(item.id)) return;
    setState(() => _downloadingIds.add(item.id));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('جارٍ تنزيل درس "${item.cleanTitle}" للاستماع بدون إنترنت...'),
        duration: const Duration(seconds: 2),
      ),
    );

    final success = await SharawyOfflineAudioService.instance.downloadSharawyItem(
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
        final path = await SharawyOfflineAudioService.instance.getLocalFilePath(item);
        if (!mounted) return;
        if (path != null) {
          widget.sharawyStore.updateLocalPath(item.id, path);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تنزيل "${item.cleanTitle}" بنجاح وهو متاح الآن بدون إنترنت!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = widget.sharawyStore.filter(
      surah: _selectedCategory,
      query: _searchQuery,
    );
    final surahs = widget.sharawyStore.getSurahs();

    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.25,
      child: CustomScrollView(
        slivers: [
          // 1. Hero Identity & Tribute Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
              child: _buildHeroCard(isDark),
            ),
          ),

          // 2. Active Player Card (when an episode is selected or playing)
          if (_currentItem != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 4),
                child: _buildActivePlayerCard(isDark, items),
              ),
            ),

          // 3. Collapsible Storage & Offline Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 4),
              child: _buildCollapsibleStorageBar(isDark),
            ),
          ),

          // 4. Search and Category Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 6),
              child: Column(
                children: [
                  _buildSearchField(isDark),
                  const SizedBox(height: 8),
                  _buildCategoryChips(surahs, isDark),
                ],
              ),
            ),
          ),

          // 5. Virtualized Episodes List (60/120 FPS Lazy Virtualization)
          if (items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 54, color: isDark ? Colors.white38 : Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'لم يتم العثور على دروس مطابقة للبحث',
                      style: TextStyle(fontSize: 15, color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 6),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isCurrent = _currentItem?.id == item.id;
                  final isPlaying = isCurrent && _status == SharawyAudioStatus.playing;
                  final isFav = widget.sharawyStore.isFavorite(item.id);
                  final isDownloading = _downloadingIds.contains(item.id);

                  return _buildEpisodeCard(
                    item: item,
                    isCurrent: isCurrent,
                    isPlaying: isPlaying,
                    isFav: isFav,
                    isDownloading: isDownloading,
                    isDark: isDark,
                    allFilteredItems: items,
                  );
                },
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
              : [const Color(0xFFFFFDF9), const Color(0xFFF4ECE1)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.goldAccent.withValues(alpha: isDark ? 0.4 : 0.6),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldAccent.withValues(alpha: 0.18),
                  border: Border.all(color: AppColors.goldAccent, width: 1.5),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.goldAccent,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.goldAccent.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.goldAccent.withValues(alpha: 0.4)),
                          ),
                          child: Text(
                            'إمام الدعاة • خواطر التفسير',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.goldAccentLight : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'فضيلة الشيخ محمد متولي الشعراوي',
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'الموسوعة الصوتية الكاملة لخواطر وتفسير القرآن الكريم (1117 تسجيلاً أصلياً) من أرشيف Internet Archive، متاحة للاستماع المباشر والتحميل أوفلاين.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePlayerCard(bool isDark, List<SharawyItem> currentList) {
    final isPlaying = _status == SharawyAudioStatus.playing;
    final isConnecting = _status == SharawyAudioStatus.connecting;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2433) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPlaying ? AppColors.goldAccent : Colors.grey.withValues(alpha: 0.3),
          width: isPlaying ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isPlaying
                ? AppColors.goldAccent.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Episode Title and Badges
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldAccent.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: AnimatedBuilder(
                    animation: _waveAnimController,
                    builder: (context, child) {
                      return Icon(
                        isPlaying ? Icons.graphic_eq_rounded : Icons.audiotrack_rounded,
                        color: AppColors.goldAccent,
                        size: 20,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentItem!.cleanTitle,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'الشيخ الشعراوي • ${_currentItem!.surahName}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (_sleepRemaining != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bedtime_rounded, size: 12, color: Colors.purple),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(_sleepRemaining!),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purple),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 10),

          // Progress Slider
          _SharawyProgressSlider(
            audioService: widget.audioService,
            isDark: isDark,
          ),

          // Player Transport Controls (Skip -10s, Prev, Play/Pause, Next, Skip +10s)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Skip -10s
              IconButton(
                icon: const Icon(Icons.replay_10_rounded),
                iconSize: 28,
                tooltip: 'تأخير 10 ثوانٍ',
                onPressed: () => widget.audioService.skipBackward(),
              ),

              // Previous
              IconButton(
                icon: const Icon(Icons.skip_previous_rounded),
                iconSize: 32,
                tooltip: 'الدرس السابق',
                onPressed: () => widget.audioService.playPrevious(),
              ),

              // Main Play / Pause
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFAA8010)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: isConnecting
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            widget.audioService.pause();
                          } else {
                            widget.audioService.resume();
                          }
                        },
                      ),
              ),

              // Next
              IconButton(
                icon: const Icon(Icons.skip_next_rounded),
                iconSize: 32,
                tooltip: 'الدرس التالي',
                onPressed: () => widget.audioService.playNext(),
              ),

              // Skip +10s
              IconButton(
                icon: const Icon(Icons.forward_10_rounded),
                iconSize: 28,
                tooltip: 'تقديم 10 ثوانٍ',
                onPressed: () => widget.audioService.skipForward(),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Secondary Controls Row: Speed, Sleep Timer, AutoNext, Favorite, Download
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Speed control
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(Icons.speed_rounded, size: 16),
                label: Text('${widget.audioService.playbackRate}x'),
                onPressed: () => _showSpeedDialog(),
              ),

              // Sleep Timer button
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  _sleepRemaining != null ? Icons.bedtime_rounded : Icons.bedtime_outlined,
                  size: 16,
                  color: _sleepRemaining != null ? Colors.purple : null,
                ),
                label: Text(
                  _sleepRemaining != null ? 'المؤقت مفعّل' : 'مؤقت النوم',
                  style: TextStyle(
                    color: _sleepRemaining != null ? Colors.purple : null,
                  ),
                ),
                onPressed: () => _showSleepTimerDialog(),
              ),

              // Favorite toggle for current item
              IconButton(
                icon: Icon(
                  widget.sharawyStore.isFavorite(_currentItem!.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: widget.sharawyStore.isFavorite(_currentItem!.id) ? Colors.red : null,
                  size: 20,
                ),
                tooltip: 'المفضلة',
                onPressed: () async {
                  await widget.sharawyStore.toggleFavorite(_currentItem!.id);
                  setState(() {});
                },
              ),

              // Download button for current item
              if (!_currentItem!.isOfflineAvailable && !_currentItem!.isCustomLocal)
                IconButton(
                  icon: const Icon(Icons.download_rounded, size: 20),
                  tooltip: 'تنزيل أوفلاين',
                  onPressed: () => _handleDownload(_currentItem!),
                )
              else
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.offline_pin_rounded, color: Colors.green, size: 20),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleStorageBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.goldAccent.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isStorageExpanded = !_isStorageExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.folder_special_rounded, size: 18, color: AppColors.goldAccent),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'التخزين المحلي للخواطر واستيراد ZIP',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    _isStorageExpanded ? 'إخفاء ▴' : 'إدارة ▾',
                    style: const TextStyle(fontSize: 11.5, color: AppColors.goldAccent),
                  ),
                ],
              ),
            ),
          ),
          if (_isStorageExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Column(
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.archive_rounded, size: 16),
                          label: const Text('استيراد ملف ZIP للخواطر', style: TextStyle(fontSize: 11.5)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () async {
                            final result = await SharawyOfflineAudioService.instance.importFromZip(
                              store: widget.sharawyStore,
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result.isSuccess
                                      ? 'تم استيراد ${result.importedTracksCount} تسجيلاً جديداً بنجاح!'
                                      : (result.errorMessage ?? 'فشل الاستيراد')),
                                  backgroundColor: result.isSuccess ? Colors.green : AppColors.error,
                                ),
                              );
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.delete_sweep_rounded, size: 16, color: Colors.red),
                        label: const Text('حذف المحمل', style: TextStyle(fontSize: 11.5, color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        ),
                        onPressed: () => _confirmClearOffline(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() => _searchQuery = val),
      decoration: InputDecoration(
        hintText: 'ابحث في خواطر وتفسير الشيخ الشعراوي...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
              )
            : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }

  Widget _buildCategoryChips(List<String> surahs, bool isDark) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: surahs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final s = surahs[index];
          final isSelected = _selectedCategory == s;

          return ChoiceChip(
            label: Text(s),
            selected: isSelected,
            selectedColor: AppColors.goldAccent,
            backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            labelStyle: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : (isDark ? Colors.white : Colors.black87),
            ),
            onSelected: (selected) {
              if (selected) setState(() => _selectedCategory = s);
            },
          );
        },
      ),
    );
  }

  Widget _buildEpisodeCard({
    required SharawyItem item,
    required bool isCurrent,
    required bool isPlaying,
    required bool isFav,
    required bool isDownloading,
    required bool isDark,
    required List<SharawyItem> allFilteredItems,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrent
            ? (isDark ? const Color(0xFF243044) : const Color(0xFFFBF6ED))
            : (isDark ? const Color(0xFF1E293B) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrent ? AppColors.goldAccent : Colors.grey.withValues(alpha: isDark ? 0.2 : 0.15),
          width: isCurrent ? 1.4 : 1.0,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onTap: () {
          if (isCurrent) {
            if (isPlaying) {
              widget.audioService.pause();
            } else {
              widget.audioService.resume();
            }
          } else {
            widget.audioService.playItem(item, playlist: allFilteredItems);
          }
        },
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrent
                ? AppColors.goldAccent.withValues(alpha: 0.25)
                : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
          ),
          child: Center(
            child: Icon(
              isPlaying
                  ? Icons.pause_rounded
                  : (isCurrent ? Icons.play_arrow_rounded : Icons.play_circle_outline_rounded),
              color: isCurrent ? AppColors.goldAccent : (isDark ? Colors.white70 : Colors.black54),
              size: 24,
            ),
          ),
        ),
        title: Text(
          item.cleanTitle,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 15,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
            color: isCurrent ? AppColors.goldAccent : null,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              item.duration,
              style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white54 : Colors.black45),
            ),
            const SizedBox(width: 8),
            if (item.isOfflineAvailable || item.isCustomLocal)
              const Icon(Icons.check_circle_rounded, size: 14, color: Colors.green)
            else
              Text(
                'أونلاين',
                style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white38 : Colors.grey),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Download or status button
            if (isDownloading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.goldAccent),
              )
            else if (!item.isOfflineAvailable && !item.isCustomLocal)
              IconButton(
                icon: const Icon(Icons.download_rounded, size: 20),
                tooltip: 'تنزيل المقطع',
                onPressed: () => _handleDownload(item),
              )
            else
              const Icon(Icons.offline_pin_rounded, color: Colors.green, size: 20),

            // Favorite Button
            IconButton(
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.red : null,
                size: 20,
              ),
              onPressed: () async {
                await widget.sharawyStore.toggleFavorite(item.id);
                setState(() {});
              },
            ),

            // Custom Item Delete Button
            if (item.isCustomLocal)
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                tooltip: 'حذف التسجيل المستورد',
                onPressed: () async {
                  await widget.sharawyStore.removeCustomItem(item.id);
                  setState(() {});
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showSpeedDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final rates = [0.75, 1.0, 1.25, 1.5, 2.0];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'سرعة تشغيل خواطر التفسير',
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: rates.map((r) {
                    final isSel = (widget.audioService.playbackRate - r).abs() < 0.05;
                    return ChoiceChip(
                      label: Text('${r}x'),
                      selected: isSel,
                      selectedColor: AppColors.goldAccent,
                      onSelected: (_) {
                        widget.audioService.setPlaybackRate(r);
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSleepTimerDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final options = <RadioSleepTimerDuration>[
          RadioSleepTimerDuration.fifteenMinutes,
          RadioSleepTimerDuration.thirtyMinutes,
          RadioSleepTimerDuration.fortyFiveMinutes,
          RadioSleepTimerDuration.sixtyMinutes,
          RadioSleepTimerDuration.none,
        ];
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'مؤقت نوم خواطر الشيخ الشعراوي',
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'إيقاف الصوت والتطبيق تلقائياً بعد انقضاء الوقت المحدد',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSel = widget.audioService.activeSleepDuration == opt;
                    return ChoiceChip(
                      label: Text(opt.labelArabic),
                      selected: isSel,
                      selectedColor: AppColors.goldAccent,
                      onSelected: (_) {
                        widget.audioService.setSleepTimer(opt);
                        Navigator.pop(ctx);
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmClearOffline() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المقاطع المحملة'),
        content: const Text('هل أنت متأكد من رغبتك في حذف جميع دروس خواطر الشيخ الشعراوي المحملة على الهاتف لتوفير المساحة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await SharawyOfflineAudioService.instance.clearAllOfflineAudio(
                store: widget.sharawyStore,
              );
              setState(() {});
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف جميع المقاطع المحملة بنجاح')),
                );
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Local isolated progress slider widget avoiding parent re-builds.
class _SharawyProgressSlider extends StatefulWidget {
  final SharawyAudioService audioService;
  final bool isDark;

  const _SharawyProgressSlider({
    required this.audioService,
    required this.isDark,
  });

  @override
  State<_SharawyProgressSlider> createState() => _SharawyProgressSliderState();
}

class _SharawyProgressSliderState extends State<_SharawyProgressSlider> {
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isDragging = false;
  double _dragValue = 0.0;

  @override
  void initState() {
    super.initState();
    _position = widget.audioService.currentPosition;
    _duration = widget.audioService.totalDuration;

    _posSub = widget.audioService.positionStream.listen((p) {
      if (mounted && !_isDragging) {
        setState(() => _position = p);
      }
    });

    _durSub = widget.audioService.durationStream.listen((d) {
      if (mounted) {
        setState(() => _duration = d);
      }
    });
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _durSub?.cancel();
    super.dispose();
  }

  String _formatTime(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '$h:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final maxSecs = _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0;
    final currentSecs = _isDragging ? _dragValue : _position.inSeconds.toDouble().clamp(0.0, maxSecs);

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.5,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: AppColors.goldAccent,
            inactiveTrackColor: widget.isDark ? Colors.white12 : Colors.black12,
            thumbColor: AppColors.goldAccent,
          ),
          child: Slider(
            value: currentSecs.clamp(0.0, maxSecs),
            min: 0.0,
            max: maxSecs,
            onChanged: (val) {
              setState(() {
                _isDragging = true;
                _dragValue = val;
              });
            },
            onChangeEnd: (val) {
              _isDragging = false;
              widget.audioService.seek(Duration(seconds: val.toInt()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatTime(_position),
                style: TextStyle(fontSize: 11, color: widget.isDark ? Colors.white54 : Colors.black45),
              ),
              Text(
                _formatTime(_duration),
                style: TextStyle(fontSize: 11, color: widget.isDark ? Colors.white54 : Colors.black45),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
