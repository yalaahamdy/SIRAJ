import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/ayah.dart';
import '../../../../modules/quran/domain/quran_reader_modes.dart';
import '../../../../modules/quran/domain/tajweed_rule.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';
import '../../theme/app_colors.dart';

/// Professional, card-free Quranic Ayah widget rendering flowing Uthmani calligraphy (§12..§16, §24).
/// Upholds a continuous digital Mushaf experience without jarring boxes or heavy dividers.
class AyahView extends StatelessWidget {
  final Ayah ayah;
  final bool isBookmarked;
  final bool isSelected;
  final bool isPlaying;
  final QuranTypographyConfig config;
  final String? translationText;
  final List<dynamic>? tajweedRules;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final double? fontSize;
  final double? lineHeight;
  final bool? showTranslation;
  final bool? showTajweed;
  final VoidCallback? onBookmarkTap;

  const AyahView({
    super.key,
    required this.ayah,
    this.isBookmarked = false,
    this.isSelected = false,
    this.isPlaying = false,
    this.config = const QuranTypographyConfig(),
    this.translationText,
    this.tajweedRules,
    this.fontSize,
    this.lineHeight,
    this.showTranslation,
    this.showTajweed,
    this.onBookmarkTap,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  /// Converts standard digits to authentic Arabic-Indic Quranic numerals (١, ٢, ٣...).
  static String toArabicIndic(int number) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    final s = number.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final d = int.tryParse(s[i]);
      if (d != null && d >= 0 && d <= 9) {
        buffer.write(arabicDigits[d]);
      } else {
        buffer.write(s[i]);
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveConfig = config.copyWith(
      fontSize: fontSize,
      lineHeight: lineHeight,
      showTranslation: showTranslation,
      showTajweed: showTajweed,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark ||
        effectiveConfig.themeMode == QuranReaderThemeMode.dark;

    // Background highlight state
    Color backgroundColor = Colors.transparent;
    if (isPlaying) {
      backgroundColor = effectiveConfig.resolvePlayingHighlightColor();
    } else if (isSelected) {
      backgroundColor = effectiveConfig.resolveHighlightColor();
    }

    final isMushafMode = effectiveConfig.readerMode == QuranReaderMode.mushaf;
    final isFocusMode = effectiveConfig.readerMode == QuranReaderMode.focus;
    final hasTranslation = (effectiveConfig.readerMode == QuranReaderMode.translation ||
            effectiveConfig.readerMode == QuranReaderMode.study ||
            effectiveConfig.showTranslation ||
            showTranslation == true) &&
        translationText != null &&
        translationText!.isNotEmpty;

    final quranTextStyle = effectiveConfig.buildQuranTextStyle();
    final ayahMarkerStyle = effectiveConfig.buildAyahMarkerStyle();
    final indicNumber = toArabicIndic(ayah.ayahNumber);

    return Semantics(
      label: 'سورة ${ayah.surahNumber}، الآية ${ayah.ayahNumber}. ${ayah.textUthmani}',
      selected: isSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(
                  color: AppColors.goldAccent.withValues(alpha: 0.4),
                  width: 1.0,
                )
              : null,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: isFocusMode ? 18.0 : 12.0,
          vertical: isMushafMode ? 2.0 : 4.0,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
            splashColor: AppColors.goldAccent.withValues(alpha: 0.1),
            highlightColor: AppColors.goldAccent.withValues(alpha: 0.08),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isFocusMode ? 8.0 : 10.0,
                vertical: isMushafMode ? 4.0 : 6.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bookmark / Sajdah subtle inline indicator
                  if (isBookmarked || ayah.hasSajdah) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isBookmarked) ...[
                            const Icon(
                              Icons.bookmark_rounded,
                              size: 14,
                              color: AppColors.goldAccent,
                            ),
                            const SizedBox(width: 4),
                          ],
                          if (ayah.hasSajdah) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'سجدة ۩',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  // Flowing Canonical Uthmani Arabic Text with Authentic Ayah Marker
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Builder(
                      builder: (context) {
                        if (config.showTajweed &&
                            tajweedRules != null &&
                            tajweedRules!.isNotEmpty) {
                          final spans = TajweedRenderer.buildSpans(
                            textUthmani: ayah.textUthmani,
                            rawRules: tajweedRules,
                            baseStyle: quranTextStyle,
                            isDark: isDark,
                          );

                          // Append authentic ornamental Ayah end marker
                          spans.add(
                            TextSpan(
                              text: ' ﴿$indicNumber﴾ ',
                              style: ayahMarkerStyle,
                            ),
                          );

                          return Text.rich(
                            TextSpan(children: spans),
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          );
                        }

                        return Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: ayah.textUthmani,
                                style: quranTextStyle,
                              ),
                              TextSpan(
                                text: ' ﴿$indicNumber﴾ ',
                                style: ayahMarkerStyle,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                        );
                      },
                    ),
                  ),

                  // Segregated Translation (when enabled)
                  if (hasTranslation) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Directionality(
                        textDirection: (effectiveConfig.translationLanguage == 'ur' ||
                                effectiveConfig.translationLanguage == 'ar' ||
                                effectiveConfig.translationLanguage == 'fa')
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Text(
                          translationText!,
                          style: TextStyle(
                            fontSize: (effectiveConfig.fontSize * 0.62).clamp(12.0, 20.0),
                            fontStyle: FontStyle.italic,
                            color: effectiveConfig.resolveSecondaryTextColor(),
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
