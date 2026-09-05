import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/domain/quran_reader_modes.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_target.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_word.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';
import '../../../../core/audio/siraj_feedback_audio_service.dart';
import '../../theme/app_colors.dart';

/// Authentic horizontal page-by-page Mushaf view (§1, §2, §3).
/// Displays Quran verses divided cleanly by canonical Mushaf pages,
/// allowing horizontal swiping from right to left (RTL) with ornamental
/// headers, footers, page borders, and complete recitation support.
class QuranMushafPageView extends StatefulWidget {
  final Surah surah;
  final List<Ayah> ayahs;
  final QuranTypographyConfig config;
  final int? selectedAyahNumber;
  final int? playingAyahNumber;
  final Set<int> bookmarkedAyahs;
  final QuranRecitationTarget? activeRecitationTarget;
  final bool isRecitationActive;
  final bool isRecitationTextHidden;
  final Map<int, List<QuranRecitationWord>>? recitationWordsMap;
  final PageController? pageController;
  final void Function(Ayah ayah) onAyahTap;
  final void Function(Ayah ayah)? onAyahDoubleTap;
  final void Function(Ayah ayah)? onAyahLongPress;
  final ValueChanged<int>? onPageChanged;
  final VoidCallback? onPreviousSurah;
  final VoidCallback? onNextSurah;
  final String? previousSurahName;
  final String? nextSurahName;

  const QuranMushafPageView({
    super.key,
    required this.surah,
    required this.ayahs,
    required this.config,
    this.selectedAyahNumber,
    this.playingAyahNumber,
    this.bookmarkedAyahs = const {},
    this.activeRecitationTarget,
    this.isRecitationActive = false,
    this.isRecitationTextHidden = false,
    this.recitationWordsMap,
    this.pageController,
    required this.onAyahTap,
    this.onAyahDoubleTap,
    this.onAyahLongPress,
    this.onPageChanged,
    this.onPreviousSurah,
    this.onNextSurah,
    this.previousSurahName,
    this.nextSurahName,
  });

  @override
  State<QuranMushafPageView> createState() => _QuranMushafPageViewState();
}

class _QuranMushafPageViewState extends State<QuranMushafPageView> {
  late final PageController _internalController;
  PageController get _pageController => widget.pageController ?? _internalController;

  final Map<int, TapGestureRecognizer> _tapRecognizers = {};
  DateTime? _lastTapTime;
  int? _lastTappedAyah;

  late Map<int, List<Ayah>> _pageGroups;
  late List<int> _pageNumbers;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _internalController = PageController();
    _rebuildPageGroups();
  }

  @override
  void didUpdateWidget(QuranMushafPageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ayahs != widget.ayahs || oldWidget.surah != widget.surah) {
      _rebuildPageGroups();
    }
  }

  void _rebuildPageGroups() {
    final groups = <int, List<Ayah>>{};
    for (final ayah in widget.ayahs) {
      groups.putIfAbsent(ayah.pageNumber, () => []).add(ayah);
    }
    _pageGroups = groups;
    _pageNumbers = groups.keys.toList()..sort();
  }

  @override
  void dispose() {
    for (final recognizer in _tapRecognizers.values) {
      recognizer.dispose();
    }
    _tapRecognizers.clear();
    if (widget.pageController == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _handleAyahTap(Ayah ayah) {
    final now = DateTime.now();
    if (_lastTappedAyah == ayah.ayahNumber &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 350) {
      _lastTapTime = null;
      _lastTappedAyah = null;
      widget.onAyahDoubleTap?.call(ayah);
    } else {
      _lastTapTime = now;
      _lastTappedAyah = ayah.ayahNumber;
      widget.onAyahTap(ayah);
    }
  }

  String _toArabicIndic(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return number.toString().split('').map((char) {
      final d = int.tryParse(char);
      return d != null ? arabicDigits[d] : char;
    }).join('');
  }

  List<InlineSpan> _buildPageSpans(
    List<Ayah> pageAyahs,
    TextStyle baseStyle,
    TextStyle markerStyle,
  ) {
    final spans = <InlineSpan>[];
    final isDark = widget.config.themeMode == QuranReaderThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark;

    for (final ayah in pageAyahs) {
      final isSelected = widget.selectedAyahNumber == ayah.ayahNumber;
      final isPlaying = widget.playingAyahNumber == ayah.ayahNumber;
      final inRecitation = widget.isRecitationActive &&
          widget.activeRecitationTarget != null &&
          ayah.ayahNumber >= widget.activeRecitationTarget!.startAyah &&
          ayah.ayahNumber <= widget.activeRecitationTarget!.endAyah;

      Color? textHighlightBg;
      if (isPlaying) {
        textHighlightBg = widget.config.resolvePlayingHighlightColor();
      } else if (isSelected) {
        textHighlightBg = widget.config.resolveHighlightColor();
      } else if (inRecitation &&
          !widget.isRecitationTextHidden &&
          widget.recitationWordsMap == null) {
        textHighlightBg = const Color(0xFF2E7D32).withValues(alpha: 0.12);
      }

      final ayahStyle = textHighlightBg != null
          ? baseStyle.copyWith(backgroundColor: textHighlightBg)
          : baseStyle;

      TextStyle ayahMarkerStyle;
      if (inRecitation || isSelected) {
        ayahMarkerStyle = markerStyle.copyWith(
          color: const Color(0xFF2E7D32),
          backgroundColor: Colors.transparent,
          fontWeight: FontWeight.bold,
        );
      } else if (isPlaying) {
        ayahMarkerStyle = markerStyle.copyWith(
          color: AppColors.primary,
          backgroundColor: Colors.transparent,
          fontWeight: FontWeight.bold,
        );
      } else {
        ayahMarkerStyle = markerStyle.copyWith(
          backgroundColor: Colors.transparent,
        );
      }

      final recognizer = _tapRecognizers.putIfAbsent(
        ayah.ayahNumber,
        () => TapGestureRecognizer(),
      );
      recognizer.onTap = () => _handleAyahTap(ayah);

      if (inRecitation && widget.isRecitationTextHidden) {
        spans.add(
          TextSpan(
            text: ayah.textUthmani,
            style: ayahStyle.copyWith(color: Colors.transparent),
            recognizer: _tapRecognizers[ayah.ayahNumber],
          ),
        );
      } else if (inRecitation && widget.recitationWordsMap != null) {
        final words = widget.recitationWordsMap![ayah.ayahNumber] ?? [];
        for (final word in words) {
          if (word.isVisible) {
            final isRevealed = word.state == RecitationWordState.revealed;
            final isMistake = word.state == RecitationWordState.mistake;
            spans.add(
              TextSpan(
                text: '${word.canonicalText} ',
                style: ayahStyle.copyWith(
                  color: isMistake
                      ? (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626))
                      : isRevealed
                          ? (isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309))
                          : widget.config.resolveTextColor(),
                  backgroundColor: isMistake
                      ? const Color(0xFFEF4444).withValues(alpha: isDark ? 0.25 : 0.18)
                      : isRevealed
                          ? (isDark
                              ? const Color(0xFFFBBF24).withValues(alpha: 0.22)
                              : const Color(0xFFB45309).withValues(alpha: 0.15))
                          : const Color(0xFF2E7D32).withValues(alpha: 0.15),
                  decoration: isMistake ? TextDecoration.underline : null,
                  decorationColor: const Color(0xFFEF4444),
                  decorationStyle: TextDecorationStyle.wavy,
                ),
                recognizer: _tapRecognizers[ayah.ayahNumber],
              ),
            );
          } else {
            spans.add(
              TextSpan(
                text: '${word.canonicalText} ',
                style: ayahStyle.copyWith(color: Colors.transparent),
                recognizer: _tapRecognizers[ayah.ayahNumber],
              ),
            );
          }
        }
      } else {
        spans.add(
          TextSpan(
            text: ayah.textUthmani,
            style: ayahStyle,
            recognizer: _tapRecognizers[ayah.ayahNumber],
          ),
        );
      }

      final indicNumber = _toArabicIndic(ayah.ayahNumber);
      spans.add(
        TextSpan(
          text: ' ﴿$indicNumber﴾ ',
          style: ayahMarkerStyle,
          recognizer: _tapRecognizers[ayah.ayahNumber],
        ),
      );
    }

    return spans;
  }

  Widget _buildSurahHeaderBanner(bool isDark) {
    final bannerBg = widget.config.resolveSurahBannerColor();
    final borderColor = widget.config.resolvePageBorderColor();
    final accentColor = widget.config.resolvePageAccentColor();
    final textColor = widget.config.resolveTextColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: bannerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('❖ ', style: TextStyle(color: accentColor, fontSize: 13)),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'سورة ${widget.surah.nameArabic}',
                    style: TextStyle(
                      fontFamily: widget.config.fontFamily.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
                ),
              ),
              Text(' ❖', style: TextStyle(color: accentColor, fontSize: 13)),
            ],
          ),
          if (widget.surah.number != 9 && widget.surah.number != 1) ...[
            const SizedBox(height: 6),
            Text(
              'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
              style: TextStyle(
                fontFamily: widget.config.fontFamily.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMushafPage(int pageNumber, List<Ayah> pageAyahs) {
    final isDark = widget.config.themeMode == QuranReaderThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark;
    final pageSurfaceColor = widget.config.resolvePageSurfaceColor();
    final pageBorderColor = widget.config.resolvePageBorderColor();
    final accentColor = widget.config.resolvePageAccentColor();
    final baseStyle = widget.config.buildQuranTextStyle();
    final markerStyle = widget.config.buildAyahMarkerStyle();
    final isFirstPageOfSurah = pageAyahs.any((a) => a.ayahNumber == 1);
    final juzNum = pageAyahs.isNotEmpty ? pageAyahs.first.juzNumber : 1;

    return Container(
      color: pageSurfaceColor,
      child: Column(
        children: [
          // Top Page Ornamental Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'الجزء ${_toArabicIndic(juzNum)}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                    fontFamily: widget.config.fontFamily.fontFamily,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      'سورة ${widget.surah.nameArabic}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                        fontFamily: widget.config.fontFamily.fontFamily,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: pageBorderColor,
          ),

          // Main Quran Text Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isFirstPageOfSurah) _buildSurahHeaderBanner(isDark),
                  Text.rich(
                    TextSpan(
                      children: _buildPageSpans(pageAyahs, baseStyle, markerStyle),
                    ),
                    textAlign: TextAlign.justify,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Page Ornamental Footer with Page Number
          Divider(
            height: 1,
            thickness: 1,
            color: pageBorderColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '❖ ﴿ ${_toArabicIndic(pageNumber)} ﴾ ❖',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    fontFamily: widget.config.fontFamily.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_pageNumbers.isEmpty) return const SizedBox.shrink();

    final isFirstPage = _currentPageIndex == 0;
    final isLastPage = _currentPageIndex >= _pageNumbers.length - 1;

    final canGoPrevSurah = isFirstPage && widget.surah.number > 1 && widget.onPreviousSurah != null;
    final canGoNextSurah = isLastPage && widget.surah.number < 114 && widget.onNextSurah != null;

    final prevSurahTitle = widget.previousSurahName != null
        ? 'سورة ${widget.previousSurahName}'
        : 'السورة السابقة';
    final nextSurahTitle = widget.nextSurahName != null
        ? 'سورة ${widget.nextSurahName}'
        : 'السورة التالية';

    return Column(
      children: [
        // Horizontal PageView
        Expanded(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pageNumbers.length,
              onPageChanged: (idx) {
                if (_currentPageIndex != idx) {
                  SirajFeedbackAudioService.instance.playPageFlip();
                }
                setState(() => _currentPageIndex = idx);
                widget.onPageChanged?.call(_pageNumbers[idx]);
              },
              itemBuilder: (context, index) {
                final pageNum = _pageNumbers[index];
                final pageAyahs = _pageGroups[pageNum] ?? [];
                return _buildMushafPage(pageNum, pageAyahs);
              },
            ),
          ),
        ),

        // Bottom Page Quick Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous Page / Previous Surah Button
              TextButton.icon(
                onPressed: _currentPageIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    : (canGoPrevSurah ? widget.onPreviousSurah : null),
                icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                label: Text(
                  _currentPageIndex > 0
                      ? 'الصفحة السابقة'
                      : (widget.surah.number > 1 ? prevSurahTitle : 'بداية المصحف'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: widget.config.resolvePageAccentColor(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.config.resolveQuickBarSurfaceColor(),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.config.resolvePageBorderColor().withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  '${_currentPageIndex + 1} من ${_pageNumbers.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.config.resolveTextColor(),
                  ),
                ),
              ),
              // Next Page / Next Surah Button
              TextButton.icon(
                onPressed: _currentPageIndex < _pageNumbers.length - 1
                    ? () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    : (canGoNextSurah ? widget.onNextSurah : null),
                icon: Text(
                  _currentPageIndex < _pageNumbers.length - 1
                      ? 'الصفحة التالية'
                      : (widget.surah.number < 114 ? nextSurahTitle : 'خاتمة المصحف'),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                label: const Icon(Icons.arrow_back_ios_rounded, size: 14),
                style: TextButton.styleFrom(
                  foregroundColor: widget.config.resolvePageAccentColor(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
