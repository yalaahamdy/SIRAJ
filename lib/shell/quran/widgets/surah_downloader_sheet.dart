import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/quran_reciter.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../../../modules/quran/quran_module.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Standalone, reusable modal bottom sheet allowing the user to download individual
/// Surahs or view offline status for any selected reciter (§16, §20).
class SurahDownloaderSheet extends StatefulWidget {
  final QuranModule quranModule;
  final QuranReciter? reciter;
  final int? initialSurahNumber;
  final VoidCallback? onDownloadCompleted;

  const SurahDownloaderSheet({
    super.key,
    required this.quranModule,
    this.reciter,
    this.initialSurahNumber,
    this.onDownloadCompleted,
  });

  /// Static helper to display the sheet from anywhere in the app.
  static Future<void> show(
    BuildContext context, {
    required QuranModule quranModule,
    QuranReciter? reciter,
    int? initialSurahNumber,
    VoidCallback? onDownloadCompleted,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SurahDownloaderSheet(
        quranModule: quranModule,
        reciter: reciter,
        initialSurahNumber: initialSurahNumber,
        onDownloadCompleted: onDownloadCompleted,
      ),
    );
  }

  @override
  State<SurahDownloaderSheet> createState() => _SurahDownloaderSheetState();
}

class _SurahDownloaderSheetState extends State<SurahDownloaderSheet> {
  late QuranReciter _activeReciter;
  List<Surah> _allSurahs = [];
  final Map<int, bool> _downloadedMap = {};
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  int? _activeDownloadingSurah;
  int _downloadedAyahsInCurrentSurah = 0;
  int _totalAyahsInCurrentSurah = 0;
  bool _isCancelled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _activeReciter = widget.reciter ?? widget.quranModule.audioService.activeReciter;
    _loadSurahsAndStatus();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSurahsAndStatus() async {
    final surahsRes = widget.quranModule.getAllSurahs();
    _allSurahs = surahsRes.valueOrNull ?? [];

    for (final surah in _allSurahs) {
      final isDone = await widget.quranModule.offlineAudioService.isSurahDownloaded(
        _activeReciter.id,
        surah.number,
        surah.ayahCount,
      );
      if (mounted) {
        _downloadedMap[surah.number] = isDone;
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);

      // If an initial surah was requested, scroll to it smoothly
      if (widget.initialSurahNumber != null) {
        final index = _allSurahs.indexWhere((s) => s.number == widget.initialSurahNumber);
        if (index > 0 && _scrollController.hasClients) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                index * 68.0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    }
  }

  Future<void> _startDownload(Surah surah) async {
    setState(() {
      _activeDownloadingSurah = surah.number;
      _downloadedAyahsInCurrentSurah = 0;
      _totalAyahsInCurrentSurah = surah.ayahCount;
      _isCancelled = false;
    });

    await widget.quranModule.offlineAudioService.downloadSurahAudio(
      reciter: _activeReciter,
      surahNumber: surah.number,
      ayahCount: surah.ayahCount,
      onProgress: (current, total) {
        if (mounted) {
          setState(() {
            _downloadedAyahsInCurrentSurah = current;
            _totalAyahsInCurrentSurah = total;
          });
        }
      },
      onError: (err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err), backgroundColor: AppColors.error),
          );
        }
      },
      isCancelled: () => _isCancelled,
    );

    if (mounted) {
      final isDone = await widget.quranModule.offlineAudioService.isSurahDownloaded(
        _activeReciter.id,
        surah.number,
        surah.ayahCount,
      );

      setState(() {
        _downloadedMap[surah.number] = isDone;
        _activeDownloadingSurah = null;
      });

      widget.onDownloadCompleted?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final availableReciters = kAvailableReciters;

    final filteredSurahs = _searchQuery.trim().isEmpty
        ? _allSurahs
        : _allSurahs.where((s) {
            return s.nameArabic.contains(_searchQuery.trim()) ||
                s.number.toString().contains(_searchQuery.trim());
          }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2129) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.goldAccent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.download_for_offline_rounded, color: AppColors.goldAccent, size: 20),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تحميل تلاوات السور بدون إنترنت',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'احفظ السور بصوت قارئك المفضل للاستماع أثناء عدم الاتصال',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'إغلاق',
                  onPressed: () {
                    _isCancelled = true;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Reciter Selector & Search Bar Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<QuranReciter>(
                    initialValue: _activeReciter,
                    isDense: true,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      labelText: 'القارئ',
                      labelStyle: const TextStyle(fontSize: 11),
                    ),
                    items: availableReciters.map((r) {
                      return DropdownMenuItem<QuranReciter>(
                        value: r,
                        child: Text(
                          r.nameArabic,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newReciter) {
                      if (newReciter != null && newReciter.id != _activeReciter.id) {
                        setState(() {
                          _activeReciter = newReciter;
                          _isLoading = true;
                        });
                        _loadSurahsAndStatus();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'ابحث عن سورة...',
                      hintStyle: const TextStyle(fontSize: 11),
                      prefixIcon: const Icon(Icons.search_rounded, size: 16),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (val) {
                      setState(() => _searchQuery = val);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Surahs List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: filteredSurahs.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final surah = filteredSurahs[index];
                      final isDownloaded = _downloadedMap[surah.number] == true;
                      final isCurrentDownloading = _activeDownloadingSurah == surah.number;
                      final isHighlighted = widget.initialSurahNumber == surah.number;

                      return Container(
                        color: isHighlighted
                            ? AppColors.goldAccent.withValues(alpha: 0.08)
                            : Colors.transparent,
                        child: ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 15,
                            backgroundColor: isDownloaded
                                ? Colors.green.withValues(alpha: 0.15)
                                : (isDark ? Colors.white10 : Colors.grey.shade200),
                            child: Text(
                              '${surah.number}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isDownloaded ? Colors.green : (isDark ? Colors.white70 : Colors.black87),
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                'سورة ${surah.nameArabic}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '(${surah.ayahCount} آية)',
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          subtitle: isCurrentDownloading
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'جارٍ التحميل: آية $_downloadedAyahsInCurrentSurah من $_totalAyahsInCurrentSurah',
                                      style: const TextStyle(fontSize: 10, color: AppColors.goldAccent, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(
                                      value: _totalAyahsInCurrentSurah > 0
                                          ? _downloadedAyahsInCurrentSurah / _totalAyahsInCurrentSurah
                                          : 0,
                                      color: AppColors.goldAccent,
                                      minHeight: 4,
                                    ),
                                  ],
                                )
                              : Text(
                                  isDownloaded ? 'متوفرة بدون إنترنت' : 'تحتاج تنزيل للاستماع أوفلاين',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDownloaded ? Colors.green : Colors.grey,
                                  ),
                                ),
                          trailing: isDownloaded
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
                                    SizedBox(width: 4),
                                    Text(
                                      'محمّلة',
                                      style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : (isCurrentDownloading
                                  ? IconButton(
                                      icon: const Icon(Icons.cancel_rounded, color: AppColors.error, size: 22),
                                      tooltip: 'إلغاء التحميل',
                                      onPressed: () {
                                        setState(() => _isCancelled = true);
                                      },
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.download_rounded, color: AppColors.goldAccent, size: 22),
                                      tooltip: 'تحميل السورة',
                                      onPressed: _activeDownloadingSurah != null ? null : () => _startDownload(surah),
                                    )),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
