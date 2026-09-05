import 'package:flutter/material.dart';
import '../domain/quran_reader_modes.dart';
import '../recitation/domain/recitation_playback_policy.dart';

/// Supported canonical Arabic Quran typography families.
enum QuranFontFamily {
  amiri('Amiri', 'الأميري (مصحف المدينة)'),
  scheherazade('ScheherazadeNew', 'شهرزاد الجديد (نسخ متطور)'),
  system('sans-serif', 'خط النظام الافتراضي');

  final String fontFamily;
  final String displayNameArabic;

  const QuranFontFamily(this.fontFamily, this.displayNameArabic);
}

/// Modes of turning pages / scrolling in Mushaf reading.
enum QuranPageTurnMode {
  vertical('تمرير رأسي متصل', Icons.swap_vert_rounded),
  horizontal('تصفح أفقي بالصفحات', Icons.swap_horiz_rounded);

  final String labelArabic;
  final IconData icon;
  const QuranPageTurnMode(this.labelArabic, this.icon);
}

/// Dynamic typography and visual styling engine for Quranic reading.
class QuranTypographyConfig {
  final QuranFontFamily fontFamily;
  final double fontSize;
  final double lineHeight;
  final QuranReaderMode readerMode;
  final QuranReaderThemeMode themeMode;
  final QuranPageTurnMode pageTurnMode;
  final bool showTajweed;
  final bool showTranslation;
  final bool showWordByWord;
  final bool autoScroll;
  final String reciter;
  final double playbackSpeed;
  final int repeatCount;
  final PlaybackRepeatPolicy repeatPolicy;
  final int delayBetweenAyahsSeconds;
  final RecitationMode defaultRecitationMode;
  final bool hideTextDuringRecitation;
  final bool autoAdvanceRecitation;
  final double maxWidth;
  final bool showTafsir;
  final String translationLanguage;

  const QuranTypographyConfig({
    this.fontFamily = QuranFontFamily.amiri,
    this.fontSize = 24.0,
    this.lineHeight = 2.2,
    this.readerMode = QuranReaderMode.mushaf,
    this.themeMode = QuranReaderThemeMode.light,
    this.pageTurnMode = QuranPageTurnMode.vertical,
    this.showTajweed = false,
    this.showTranslation = false,
    this.showWordByWord = false,
    this.autoScroll = true,
    this.reciter = 'الشيخ عبد الباسط عبد الصمد',
    this.playbackSpeed = 1.0,
    this.repeatCount = 1,
    this.repeatPolicy = PlaybackRepeatPolicy.none,
    this.delayBetweenAyahsSeconds = 0,
    this.defaultRecitationMode = RecitationMode.recordAndReplay,
    this.hideTextDuringRecitation = true,
    this.autoAdvanceRecitation = true,
    this.maxWidth = 800.0,
    this.showTafsir = false,
    this.translationLanguage = 'en',
  });

  QuranTypographyConfig copyWith({
    QuranFontFamily? fontFamily,
    double? fontSize,
    double? lineHeight,
    QuranReaderMode? readerMode,
    QuranReaderThemeMode? themeMode,
    QuranPageTurnMode? pageTurnMode,
    bool? showTajweed,
    bool? showTranslation,
    bool? showWordByWord,
    bool? autoScroll,
    String? reciter,
    double? playbackSpeed,
    int? repeatCount,
    PlaybackRepeatPolicy? repeatPolicy,
    int? delayBetweenAyahsSeconds,
    RecitationMode? defaultRecitationMode,
    bool? hideTextDuringRecitation,
    bool? autoAdvanceRecitation,
    double? maxWidth,
    bool? showTafsir,
    String? translationLanguage,
  }) {
    return QuranTypographyConfig(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      readerMode: readerMode ?? this.readerMode,
      themeMode: themeMode ?? this.themeMode,
      pageTurnMode: pageTurnMode ?? this.pageTurnMode,
      showTajweed: showTajweed ?? this.showTajweed,
      showTranslation: showTranslation ?? this.showTranslation,
      showWordByWord: showWordByWord ?? this.showWordByWord,
      autoScroll: autoScroll ?? this.autoScroll,
      reciter: reciter ?? this.reciter,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      repeatCount: repeatCount ?? this.repeatCount,
      repeatPolicy: repeatPolicy ?? this.repeatPolicy,
      delayBetweenAyahsSeconds:
          delayBetweenAyahsSeconds ?? this.delayBetweenAyahsSeconds,
      defaultRecitationMode:
          defaultRecitationMode ?? this.defaultRecitationMode,
      hideTextDuringRecitation:
          hideTextDuringRecitation ?? this.hideTextDuringRecitation,
      autoAdvanceRecitation:
          autoAdvanceRecitation ?? this.autoAdvanceRecitation,
      maxWidth: maxWidth ?? this.maxWidth,
      showTafsir: showTafsir ?? this.showTafsir,
      translationLanguage: translationLanguage ?? this.translationLanguage,
    );
  }

  Map<String, dynamic> toJson() => {
        'fontFamily': fontFamily.name,
        'fontSize': fontSize,
        'lineHeight': lineHeight,
        'readerMode': readerMode.name,
        'themeMode': themeMode.name,
        'pageTurnMode': pageTurnMode.name,
        'showTajweed': showTajweed,
        'showTranslation': showTranslation,
        'showWordByWord': showWordByWord,
        'autoScroll': autoScroll,
        'reciter': reciter,
        'playbackSpeed': playbackSpeed,
        'repeatCount': repeatCount,
        'repeatPolicy': repeatPolicy.name,
        'delayBetweenAyahsSeconds': delayBetweenAyahsSeconds,
        'defaultRecitationMode': defaultRecitationMode.name,
        'hideTextDuringRecitation': hideTextDuringRecitation,
        'autoAdvanceRecitation': autoAdvanceRecitation,
        'maxWidth': maxWidth,
        'showTafsir': showTafsir,
        'translationLanguage': translationLanguage,
      };

  factory QuranTypographyConfig.fromJson(Map<String, dynamic> json) {
    return QuranTypographyConfig(
      fontFamily: QuranFontFamily.values.firstWhere(
        (f) => f.name == json['fontFamily'],
        orElse: () => QuranFontFamily.amiri,
      ),
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 24.0,
      lineHeight: (json['lineHeight'] as num?)?.toDouble() ?? 2.2,
      readerMode: QuranReaderMode.values.firstWhere(
        (m) => m.name == json['readerMode'],
        orElse: () => QuranReaderMode.mushaf,
      ),
      themeMode: QuranReaderThemeMode.values.firstWhere(
        (t) => t.name == json['themeMode'],
        orElse: () => QuranReaderThemeMode.light,
      ),
      pageTurnMode: QuranPageTurnMode.values.firstWhere(
        (p) => p.name == json['pageTurnMode'],
        orElse: () => QuranPageTurnMode.vertical,
      ),
      showTajweed: json['showTajweed'] as bool? ?? false,
      showTranslation: json['showTranslation'] as bool? ?? false,
      showWordByWord: json['showWordByWord'] as bool? ?? false,
      autoScroll: json['autoScroll'] as bool? ?? true,
      reciter: json['reciter'] as String? ?? 'مشاري راشد العفاسي',
      playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
      repeatCount: (json['repeatCount'] as num?)?.toInt() ?? 1,
      repeatPolicy: PlaybackRepeatPolicy.values.firstWhere(
        (p) => p.name == json['repeatPolicy'],
        orElse: () => PlaybackRepeatPolicy.none,
      ),
      delayBetweenAyahsSeconds:
          json['delayBetweenAyahsSeconds'] as int? ?? 0,
      defaultRecitationMode: RecitationMode.values.firstWhere(
        (m) => m.name == json['defaultRecitationMode'],
        orElse: () => RecitationMode.recordAndReplay,
      ),
      hideTextDuringRecitation:
          json['hideTextDuringRecitation'] as bool? ?? true,
      autoAdvanceRecitation:
          json['autoAdvanceRecitation'] as bool? ?? true,
      maxWidth: (json['maxWidth'] as num?)?.toDouble() ?? 800.0,
      showTafsir: json['showTafsir'] as bool? ?? false,
      translationLanguage: json['translationLanguage'] as String? ?? 'en',
    );
  }

  /// Resolves background color according to the active reader theme preset.
  Color resolveBackgroundColor(BuildContext context) {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFFFAF8F5); // Crisp, gentle warm ivory
      case QuranReaderThemeMode.dark:
        return const Color(0xFF14171A); // Deep non-fatiguing charcoal
      case QuranReaderThemeMode.sepia:
        return const Color(0xFFF4ECD8); // Authentic warm Madinah Mushaf parchment
    }
  }

  /// Resolves dominant text color according to the active theme preset.
  Color resolveTextColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFF1B242C);
      case QuranReaderThemeMode.dark:
        return const Color(0xFFE8EAED);
      case QuranReaderThemeMode.sepia:
        return const Color(0xFF2C2216);
    }
  }

  /// Resolves secondary / translation text color according to the active theme preset.
  Color resolveSecondaryTextColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFF5A6672);
      case QuranReaderThemeMode.dark:
        return const Color(0xFF9AA0A6);
      case QuranReaderThemeMode.sepia:
        return const Color(0xFF6B5A45);
    }
  }

  /// Resolves active selection highlight background color.
  Color resolveHighlightColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFFD4AF37).withValues(alpha: 0.18);
      case QuranReaderThemeMode.dark:
        return const Color(0xFFE5C158).withValues(alpha: 0.22);
      case QuranReaderThemeMode.sepia:
        return const Color(0xFFB8860B).withValues(alpha: 0.20);
    }
  }

  /// Resolves currently playing audio recitation highlight color.
  Color resolvePlayingHighlightColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFF0F766E).withValues(alpha: 0.15);
      case QuranReaderThemeMode.dark:
        return const Color(0xFF14B8A6).withValues(alpha: 0.20);
      case QuranReaderThemeMode.sepia:
        return const Color(0xFF2D5A43).withValues(alpha: 0.18);
    }
  }

  /// Builds the authoritative Quranic Arabic text style.
  TextStyle buildQuranTextStyle() {
    return TextStyle(
      fontFamily: fontFamily.fontFamily,
      fontSize: fontSize,
      height: lineHeight,
      fontWeight: FontWeight.normal,
      color: resolveTextColor(),
      letterSpacing: 0.2,
      fontFeatures: const [
        FontFeature.enable('liga'), // Standard Arabic ligatures
        FontFeature.enable('dlig'), // Discretionary ligatures
      ],
    );
  }

  /// Builds end-of-ayah marker badge style.
  TextStyle buildAyahMarkerStyle() {
    return TextStyle(
      fontFamily: fontFamily.fontFamily,
      fontSize: (fontSize * 0.75).clamp(14.0, 28.0),
      fontWeight: FontWeight.bold,
      color: themeMode == QuranReaderThemeMode.dark
          ? const Color(0xFFE5C158)
          : const Color(0xFF9E7D23),
    );
  }

  /// Resolves page surface background color for Mushaf page card.
  Color resolvePageSurfaceColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFFFFFFFF); // Crisp white page on warm ivory canvas
      case QuranReaderThemeMode.dark:
        return const Color(0xFF181C22); // Deep non-fatiguing charcoal
      case QuranReaderThemeMode.sepia:
        return const Color(0xFFFAF5E8); // Authentic warm Madinah page surface
    }
  }

  /// Resolves page border color according to the theme.
  Color resolvePageBorderColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFFC8A951).withValues(alpha: 0.50);
      case QuranReaderThemeMode.dark:
        return const Color(0xFFE5C158).withValues(alpha: 0.35);
      case QuranReaderThemeMode.sepia:
        return const Color(0xFFB8860B).withValues(alpha: 0.45);
    }
  }

  /// Resolves high-contrast ornamental and header accent color for the Mushaf page.
  Color resolvePageAccentColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFF78350F); // Warm bronze/chestnut (contrast > 8:1)
      case QuranReaderThemeMode.dark:
        return const Color(0xFFFBBF24); // Radiant amber gold (contrast > 10:1)
      case QuranReaderThemeMode.sepia:
        return const Color(0xFF5C3813); // Deep parchment sepia (contrast > 7.5:1)
    }
  }

  /// Resolves surah header banner background color.
  Color resolveSurahBannerColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFFFDF9F0);
      case QuranReaderThemeMode.dark:
        return const Color(0xFF222832);
      case QuranReaderThemeMode.sepia:
        return const Color(0xFFEFE4CC);
    }
  }

  /// Resolves quick-bar chip background color.
  Color resolveQuickBarSurfaceColor() {
    switch (themeMode) {
      case QuranReaderThemeMode.light:
        return const Color(0xFFF0EBE1);
      case QuranReaderThemeMode.dark:
        return const Color(0xFF21262F);
      case QuranReaderThemeMode.sepia:
        return const Color(0xFFE5D7B5);
    }
  }
}
