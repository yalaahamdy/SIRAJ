import 'package:flutter/material.dart';
import '../../../../modules/quran/domain/quran_reader_modes.dart';
import '../../../../modules/quran/domain/surah.dart';
import '../../../../modules/quran/services/quran_typography_service.dart';

/// Authentic ornamental banner displayed at the beginning of each Surah (§12, §16).
/// Inspired by the Madinah and Cairo canonical Mushaf illuminated titlepieces.
/// Dynamically adapts to active Quran themes (Light, Dark, and Warm Parchment Sepia).
class SurahHeaderCard extends StatelessWidget {
  final Surah surah;
  final int? juzNumber;
  final QuranTypographyConfig? config;

  const SurahHeaderCard({
    super.key,
    required this.surah,
    this.juzNumber,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = config?.themeMode ??
        (Theme.of(context).brightness == Brightness.dark
            ? QuranReaderThemeMode.dark
            : QuranReaderThemeMode.light);

    final isDark = themeMode == QuranReaderThemeMode.dark;
    final isSepia = themeMode == QuranReaderThemeMode.sepia;

    // Theme-specific color palettes
    final Color cardBackground;
    final Color innerBannerBg;
    final Color borderGoldColor;
    final Color surahTitleColor;
    final Color metadataColor;
    final Color badgeBgColor;
    final Color badgeTextColor;
    final Color bismillahColor;
    final Color starAccentColor;

    if (isDark) {
      cardBackground = const Color(0xFF181D24);
      innerBannerBg = const Color(0xFF1E242D);
      borderGoldColor = const Color(0xFFD4AF37).withValues(alpha: 0.65);
      surahTitleColor = const Color(0xFFE5C07B);
      metadataColor = const Color(0xFFB0B8C1);
      badgeBgColor = const Color(0xFFD4AF37).withValues(alpha: 0.18);
      badgeTextColor = const Color(0xFFE5C07B);
      bismillahColor = const Color(0xFFE5C07B);
      starAccentColor = const Color(0xFFD4AF37);
    } else if (isSepia) {
      cardBackground = const Color(0xFFEDE3CE);
      innerBannerBg = const Color(0xFFF3EBD8);
      borderGoldColor = const Color(0xFFBFA15F);
      surahTitleColor = const Color(0xFF2C1F10);
      metadataColor = const Color(0xFF6B553B);
      badgeBgColor = const Color(0xFFBFA15F).withValues(alpha: 0.22);
      badgeTextColor = const Color(0xFF4A341D);
      bismillahColor = const Color(0xFF382614);
      starAccentColor = const Color(0xFF9E7E38);
    } else {
      cardBackground = const Color(0xFFF9F5EE);
      innerBannerBg = const Color(0xFFFFFDF9);
      borderGoldColor = const Color(0xFFD4AF37);
      surahTitleColor = const Color(0xFF1B3D2F);
      metadataColor = const Color(0xFF4A5568);
      badgeBgColor = const Color(0xFFD4AF37).withValues(alpha: 0.16);
      badgeTextColor = const Color(0xFF2C5E43);
      bismillahColor = const Color(0xFF22382D);
      starAccentColor = const Color(0xFFD4AF37);
    }

    final juzInfo = juzNumber != null ? ' • الجزء $juzNumber' : '';
    final pageInfo = surah.startPage > 0 ? ' • ص ${surah.startPage}' : '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 6, bottom: 20),
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border(
          top: BorderSide(color: borderGoldColor, width: 2.0),
          bottom: BorderSide(color: borderGoldColor, width: 2.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top subtle golden ornamental line
          Container(
            height: 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  borderGoldColor.withValues(alpha: 0.0),
                  borderGoldColor,
                  borderGoldColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // Central Cartouche & Frame
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: innerBannerBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: borderGoldColor.withValues(alpha: 0.5),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: borderGoldColor.withValues(alpha: 0.06),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                // Top metadata row with badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: borderGoldColor.withValues(alpha: 0.35),
                          width: 0.6,
                        ),
                      ),
                      child: Text(
                        'ترتيبها ${surah.number}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                    Text(
                      '${surah.revelationType.nameArabic} • آياتها ${surah.ayahCount}$juzInfo$pageInfo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: metadataColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Surah Name with Classical Arabesque Framing Ornaments
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '۞ ❖ ',
                        style: TextStyle(
                          fontSize: 14,
                          color: starAccentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'سُورَةُ ${surah.nameArabic}',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: surahTitleColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        ' ❖ ۞',
                        style: TextStyle(
                          fontSize: 14,
                          color: starAccentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  surah.nameEnglish,
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: metadataColor,
                  ),
                ),
              ],
            ),
          ),

          // Bottom subtle golden ornamental line
          Container(
            height: 1.5,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  borderGoldColor.withValues(alpha: 0.0),
                  borderGoldColor,
                  borderGoldColor.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // Authentic Bismillah (Omitted for Surah 1 where it is Ayah 1, and Surah 9 At-Tawbah)
          if (surah.number != 1 && surah.number != 9) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              child: Text(
                'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: bismillahColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
