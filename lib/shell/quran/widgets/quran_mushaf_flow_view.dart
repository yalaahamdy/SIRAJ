import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/domain/quran_reader_modes.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_target.dart';
import '../../../../modules/quran/recitation/domain/quran_recitation_word.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';
import '../../theme/app_colors.dart';

/// Continuous inline Arabic flow renderer for Quranic text (§2, §3).
/// Groups verses by page with authentic ornamental page dividers,
/// while allowing continuous horizontal flow within each page.
class QuranMushafFlowView extends StatefulWidget {
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
  final void Function(Ayah ayah) onAyahTap;
  final void Function(Ayah ayah)? onAyahDoubleTap;
  final void Function(Ayah ayah)? onAyahLongPress;

  const QuranMushafFlowView({
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
    required this.onAyahTap,
    this.onAyahDoubleTap,
    this.onAyahLongPress,
  });

  @override
  State<QuranMushafFlowView> createState() => _QuranMushafFlowViewState();
}

class _QuranMushafFlowViewState extends State<QuranMushafFlowView> {
  final Map<int, TapGestureRecognizer> _tapRecognizers = {};
  DateTime? _lastTapTime;
  int? _lastTappedAyah;

  @override
  void dispose() {
    for (final recognizer in _tapRecognizers.values) {
      recognizer.dispose();
    }
    _tapRecognizers.clear();
    super.dispose();
  }

  void _handleAyahTap(Ayah ayah) {
    final now = DateTime.now();
    if (_lastTappedAyah == ayah.ayahNumber &&
        _lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds < 350) {
      // Double tap detected
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

  Widget _buildMushafPageDivider(BuildContext context, int pageNumber) {
    final isDark = widget.config.themeMode == QuranReaderThemeMode.dark ||
        Theme.of(context).brightness == Brightness.dark;
    final indicPage = _toArabicIndic(pageNumber);
    final goldColor = AppColors.goldAccent;
    final dividerColor = goldColor.withValues(alpha: isDark ? 0.35 : 0.45);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dividerColor.withValues(alpha: 0.0),
                    dividerColor,
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E232D) : const Color(0xFFFBF8F0),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: goldColor.withValues(alpha: 0.5),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_stories_rounded,
                  size: 13,
                  color: goldColor,
                ),
                const SizedBox(width: 6),
                Text(
                  'نهاية صفحة $indicPage',
                  style: TextStyle(
                    fontFamily: widget.config.fontFamily.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? const Color(0xFFD4AF37) : const Color(0xFF8C6D1F),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '❖',
                  style: TextStyle(
                    fontSize: 9,
                    color: goldColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1.2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    dividerColor,
                    dividerColor.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
        // Mode A completed: revealed text has gentle emerald highlight
        textHighlightBg = const Color(0xFF2E7D32).withValues(alpha: 0.12);
      }

      final ayahStyle = textHighlightBg != null
          ? baseStyle.copyWith(backgroundColor: textHighlightBg)
          : baseStyle;

      // Ayah Marker Styling:
      TextStyle ayahMarkerStyle;
      if (inRecitation || isSelected) {
        ayahMarkerStyle = markerStyle.copyWith(
          color: const Color(0xFF2E7D32), // Islamic Emerald Green
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

      // In-Place Recitation Text Veiling & Streaming Logic
      if (inRecitation && widget.isRecitationTextHidden) {
        // Mode A: Text is 100% transparent in place, preserving exact layout and typography
        spans.add(
          TextSpan(
            text: ayah.textUthmani,
            style: ayahStyle.copyWith(
              color: Colors.transparent,
            ),
            recognizer: _tapRecognizers[ayah.ayahNumber],
          ),
        );
      } else if (inRecitation && widget.recitationWordsMap != null) {
        // Mode B: FastConformer Word-by-Word Streaming Reveal
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
            // Hidden word: 100% transparent in place
            spans.add(
              TextSpan(
                text: '${word.canonicalText} ',
                style: ayahStyle.copyWith(
                  color: Colors.transparent,
                ),
                recognizer: _tapRecognizers[ayah.ayahNumber],
              ),
            );
          }
        }
      } else {
        // Normal text OR Mode A Revealed Text after recording:
        spans.add(
          TextSpan(
            text: ayah.textUthmani,
            style: ayahStyle,
            recognizer: _tapRecognizers[ayah.ayahNumber],
          ),
        );
      }

      // Compact, non-breaking Ayah marker ﴿١﴾
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

  @override
  Widget build(BuildContext context) {
    if (widget.ayahs.isEmpty) return const SizedBox.shrink();

    final baseStyle = widget.config.buildQuranTextStyle();
    final markerStyle = widget.config.buildAyahMarkerStyle();

    // Group ayahs by pageNumber
    final pageGroups = <int, List<Ayah>>{};
    for (final ayah in widget.ayahs) {
      pageGroups.putIfAbsent(ayah.pageNumber, () => []).add(ayah);
    }

    final pages = pageGroups.keys.toList()..sort();

    // Fast path: if all verses are on one page
    if (pages.length <= 1) {
      final spans = _buildPageSpans(widget.ayahs, baseStyle, markerStyle);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text.rich(
          TextSpan(children: spans),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        ),
      );
    }

    // Multi-page flow with elegant page dividers
    final pageWidgets = <Widget>[];
    for (int i = 0; i < pages.length; i++) {
      final pageNum = pages[i];
      final pageAyahs = pageGroups[pageNum]!;
      final pageSpans = _buildPageSpans(pageAyahs, baseStyle, markerStyle);

      pageWidgets.add(
        Text.rich(
          TextSpan(children: pageSpans),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        ),
      );

      // Add page divider between pages
      if (i < pages.length - 1) {
        pageWidgets.add(_buildMushafPageDivider(context, pageNum));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: pageWidgets,
      ),
    );
  }
}
