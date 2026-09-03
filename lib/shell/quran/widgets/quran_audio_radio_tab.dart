import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/quran_reciter.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../../../modules/quran/quran_module.dart';
import '../../../../modules/quran/services/quran_audio_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Professional Quran Audio Studio & Radio Sub-Tab (§14, §16, §20).
/// Provides an authentic, compact, and full-featured listening experience:
/// - Selecting reciters (default: Sheikh Abdul Basit Abdul Samad)
/// - Playback speed control (0.75x, 1.0x, 1.25x, 1.5x, 2.0x)
/// - Surah selection & verse navigation
/// - Compact responsive player card designed for mobile screens
/// - Direct link to Mushaf reader & quick one-tap Surah playlist
class QuranAudioRadioTab extends StatefulWidget {
  final QuranModule quranModule;
  final List<Surah> surahs;
  final Function(int surahNumber, {int? targetPage, int? targetAyah}) onOpenSurah;

  const QuranAudioRadioTab({
    super.key,
    required this.quranModule,
    required this.surahs,
    required this.onOpenSurah,
  });

  @override
  State<QuranAudioRadioTab> createState() => _QuranAudioRadioTabState();
}

class _QuranAudioRadioTabState extends State<QuranAudioRadioTab> {
  late QuranAudioService _audioService;
  StreamSubscription<AudioPlaybackReport>? _audioSub;
  AudioPlaybackReport _report = const AudioPlaybackReport(
    status: AudioPlaybackStatus.idle,
  );

  int _selectedSurahNumber = 1;
  int _selectedAyahNumber = 1;
  final TextEditingController _surahSearchController = TextEditingController();
  String _surahSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _audioService = widget.quranModule.audioService;
    _report = _audioService.currentReport;

    if (_report.surahNumber != null) {
      _selectedSurahNumber = _report.surahNumber!;
      _selectedAyahNumber = _report.ayahNumber ?? 1;
    }

    _audioSub = _audioService.reportStream.listen((rep) {
      if (mounted) {
        setState(() {
          _report = rep;
          if (rep.surahNumber != null) {
            _selectedSurahNumber = rep.surahNumber!;
            _selectedAyahNumber = rep.ayahNumber ?? 1;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioSub?.cancel();
    _surahSearchController.dispose();
    super.dispose();
  }

  Surah get _activeSurah {
    return widget.surahs.firstWhere(
      (s) => s.number == _selectedSurahNumber,
      orElse: () => widget.surahs.first,
    );
  }

  void _onPlayPausePressed() {
    if (_report.status == AudioPlaybackStatus.playing) {
      _audioService.pause();
    } else if (_report.status == AudioPlaybackStatus.paused &&
        _report.surahNumber == _selectedSurahNumber) {
      _audioService.resume();
    } else {
      _audioService.playAyah(_selectedSurahNumber, _selectedAyahNumber);
    }
  }

  void _onReciterChanged(QuranReciter? reciter) {
    if (reciter != null) {
      _audioService.setReciter(reciter);
      // If already playing, restart current verse with new reciter immediately
      if (_report.status == AudioPlaybackStatus.playing) {
        _audioService.playAyah(_selectedSurahNumber, _selectedAyahNumber);
      }
    }
  }

  void _onSpeedChanged(double speed) {
    _audioService.setPlaybackSpeed(speed);
  }

  void _onSurahSelected(int surahNumber) {
    setState(() {
      _selectedSurahNumber = surahNumber;
      _selectedAyahNumber = 1;
    });
    _audioService.playSurah(surahNumber, startAyah: 1);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPlaying = _report.status == AudioPlaybackStatus.playing;
    final currentSurah = _activeSurah;

    final filteredSurahs = _surahSearchQuery.isEmpty
        ? widget.surahs
        : widget.surahs.where((s) {
            return s.nameArabic.contains(_surahSearchQuery) ||
                s.nameEnglish.toLowerCase().contains(_surahSearchQuery.toLowerCase()) ||
                s.number.toString() == _surahSearchQuery;
          }).toList();

    return Column(
      children: [
        // 1. Sleek Compact Radio & Player Master Card
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(AppSpacing.s, AppSpacing.s, AppSpacing.s, 4),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B2129) : const Color(0xFFFAF7F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.goldAccent.withValues(alpha: isDark ? 0.35 : 0.45),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row 1: Surah Title & Verse Indicator + Reciter Selector & Mushaf Button
              Row(
                children: [
                  Icon(
                    isPlaying ? Icons.graphic_eq_rounded : Icons.radio_rounded,
                    color: AppColors.goldAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'سورة ${currentSurah.nameArabic}',
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '(آية $_selectedAyahNumber/${currentSurah.ayahCount})',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Reciter Selector Dropdown Chip
                  PopupMenuButton<QuranReciter>(
                    tooltip: 'اختيار القارئ',
                    initialValue: _audioService.activeReciter,
                    onSelected: _onReciterChanged,
                    itemBuilder: (context) {
                      return kAvailableReciters.map((reciter) {
                        final isSelected = reciter.id == _audioService.activeReciter.id;
                        return PopupMenuItem<QuranReciter>(
                          value: reciter,
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked_rounded
                                    : Icons.radio_button_unchecked_rounded,
                                size: 15,
                                color: isSelected ? AppColors.goldAccent : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      reciter.nameArabic,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      reciter.subTitle,
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              if (reciter.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.goldAccent.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'الافتراضي',
                                    style: TextStyle(fontSize: 9, color: AppColors.goldAccent),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppColors.goldAccent.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_rounded, size: 13, color: AppColors.goldAccent),
                          const SizedBox(width: 4),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 100),
                            child: Text(
                              _audioService.activeReciter.nameArabic,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down_rounded, size: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),

                  // Open in Mushaf Icon Button
                  IconButton(
                    icon: const Icon(Icons.menu_book_rounded, size: 18),
                    tooltip: 'قراءة في المصحف',
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    color: AppColors.goldAccent,
                    onPressed: () {
                      widget.onOpenSurah(
                        _selectedSurahNumber,
                        targetAyah: _selectedAyahNumber,
                        targetPage: currentSurah.startPage,
                      );
                    },
                  ),
                ],
              ),

              // Row 2: Compact Verse Scrubber Slider
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Text(
                      '1',
                      style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.goldAccent,
                          thumbColor: AppColors.goldAccent,
                          inactiveTrackColor: AppColors.goldAccent.withValues(alpha: 0.2),
                          trackHeight: 2.5,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                        ),
                        child: Slider(
                          value: _selectedAyahNumber.clamp(1, currentSurah.ayahCount).toDouble(),
                          min: 1,
                          max: currentSurah.ayahCount.toDouble(),
                          divisions: currentSurah.ayahCount > 1 ? currentSurah.ayahCount - 1 : 1,
                          onChanged: (val) {
                            final ayah = val.toInt();
                            setState(() => _selectedAyahNumber = ayah);
                            _audioService.playAyah(_selectedSurahNumber, ayah);
                          },
                        ),
                      ),
                    ),
                    Text(
                      '${currentSurah.ayahCount}',
                      style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[400] : Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Row 3: Compact Media Controls & Speed Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Playback Speed Selector Popup
                  PopupMenuButton<double>(
                    tooltip: 'سرعة التلاوة',
                    initialValue: _audioService.playbackSpeed,
                    onSelected: _onSpeedChanged,
                    itemBuilder: (context) {
                      return [0.75, 1.0, 1.25, 1.5, 2.0].map((spd) {
                        final isSel = (_audioService.playbackSpeed - spd).abs() < 0.05;
                        return PopupMenuItem<double>(
                          value: spd,
                          child: Text(
                            '${spd}x ${isSel ? '✓' : ''}',
                            style: TextStyle(
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                              color: isSel ? AppColors.goldAccent : null,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.speed_rounded, size: 13, color: Colors.grey),
                          const SizedBox(width: 3),
                          Text(
                            '${_audioService.playbackSpeed}x',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.arrow_drop_down_rounded, size: 14),
                        ],
                      ),
                    ),
                  ),

                  // Symmetrical Centered Media Controls
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Previous Surah
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded),
                        tooltip: 'السورة السابقة',
                        iconSize: 22,
                        visualDensity: VisualDensity.compact,
                        onPressed: _selectedSurahNumber > 1
                            ? () => _onSurahSelected(_selectedSurahNumber - 1)
                            : null,
                      ),
                      // Previous Ayah
                      IconButton(
                        icon: const Icon(Icons.fast_rewind_rounded),
                        tooltip: 'الآية السابقة',
                        iconSize: 22,
                        visualDensity: VisualDensity.compact,
                        onPressed: () => _audioService.previousAyah(),
                      ),
                      const SizedBox(width: 4),
                      // Compact Gold Play / Pause Button
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE5C07B), Color(0xFFD4AF37)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.goldAccent.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.black87,
                          ),
                          iconSize: 24,
                          onPressed: _onPlayPausePressed,
                        ),
                      ),
                      const SizedBox(width: 4),
                      // Next Ayah
                      IconButton(
                        icon: const Icon(Icons.fast_forward_rounded),
                        tooltip: 'الآية التالية',
                        iconSize: 22,
                        visualDensity: VisualDensity.compact,
                        onPressed: () => _audioService.nextAyah(),
                      ),
                      // Next Surah
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded),
                        tooltip: 'السورة التالية',
                        iconSize: 22,
                        visualDensity: VisualDensity.compact,
                        onPressed: _selectedSurahNumber < 114
                            ? () => _onSurahSelected(_selectedSurahNumber + 1)
                            : null,
                      ),
                    ],
                  ),

                  // Surah Revelation Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.goldAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      currentSurah.revelationType.nameArabic,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.goldAccent : AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. Compact Surah Search Input
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 2),
          child: TextField(
            controller: _surahSearchController,
            onChanged: (val) {
              setState(() => _surahSearchQuery = val.trim());
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن سورة للاستماع إليها مباشرة...',
              prefixIcon: const Icon(Icons.search_rounded, size: 20),
              suffixIcon: _surahSearchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _surahSearchController.clear();
                        setState(() => _surahSearchQuery = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),

        // 3. Surah List for Quick Direct Listening
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            itemCount: filteredSurahs.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final surah = filteredSurahs[index];
              final isThisSurahActive = surah.number == _selectedSurahNumber;
              final isThisSurahPlaying = isThisSurahActive && isPlaying;

              return ListTile(
                dense: true,
                selected: isThisSurahActive,
                selectedTileColor: AppColors.goldAccent.withValues(alpha: isDark ? 0.12 : 0.08),
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: isThisSurahActive
                      ? AppColors.goldAccent
                      : (isDark ? AppColors.surfaceDark : AppColors.primaryLight).withValues(alpha: 0.2),
                  foregroundColor: isThisSurahActive
                      ? Colors.black
                      : (isDark ? AppColors.goldAccent : AppColors.primary),
                  child: isThisSurahPlaying
                      ? const Icon(Icons.volume_up_rounded, size: 16)
                      : Text(
                          '${surah.number}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                ),
                title: Text(
                  'سورة ${surah.nameArabic}',
                  style: TextStyle(
                    fontWeight: isThisSurahActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  '${surah.nameEnglish} • ${surah.revelationType.nameArabic} • ${surah.ayahCount} آية',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: Icon(
                    isThisSurahPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                    color: AppColors.goldAccent,
                    size: 28,
                  ),
                  tooltip: isThisSurahPlaying ? 'إيقاف مؤقت' : 'استماع',
                  onPressed: () {
                    if (isThisSurahPlaying) {
                      _audioService.pause();
                    } else {
                      _onSurahSelected(surah.number);
                    }
                  },
                ),
                onTap: () {
                  _onSurahSelected(surah.number);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
