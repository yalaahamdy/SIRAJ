import 'package:equatable/equatable.dart';

/// Status of the Holy Quran Radio live stream (§14, §20).
enum CairoRadioStatus {
  idle,
  connecting,
  playing,
  paused,
  error,
}

/// Metadata and streaming configuration for Cairo Quran Radio.
class CairoRadioStation extends Equatable {
  final String id;
  final String nameArabic;
  final String subtitleArabic;
  final String frequencyDescription;
  final String primaryStreamUrl;
  final List<String> backupStreamUrls;
  final String historicalNote;

  const CairoRadioStation({
    required this.id,
    required this.nameArabic,
    required this.subtitleArabic,
    required this.frequencyDescription,
    required this.primaryStreamUrl,
    required this.backupStreamUrls,
    required this.historicalNote,
  });

  /// Canonical configuration for the Holy Quran Radio from Cairo.
  static const CairoRadioStation cairoQuranRadio = CairoRadioStation(
    id: 'cairo_holy_quran_radio',
    nameArabic: 'إذاعة القرآن الكريم من القاهرة',
    subtitleArabic: 'البث الحي المباشر على مدار الساعة — جمهورية مصر العربية',
    frequencyDescription: 'FM 98.2 MHz — القاهرة الكبرى وعبر الأقمار الصناعية',
    primaryStreamUrl: 'https://stream.radiojar.com/8s5u5tpdtwzuv',
    backupStreamUrls: [
      'https://n0a.radiojar.com/8s5u5tpdtwzuv',
      'http://live.mp3quran.net:9702/',
    ],
    historicalNote:
        'أقدم إذاعة قرآنية في العالم، انطلقت في 25 مارس 1964م بمباركة كبار قراء وأعلام الأزهر الشريف: '
        'الشيخ محمود خليل الحصري، الشيخ محمد صديق المنشاوي، الشيخ عبد الباسط عبد الصمد، '
        'الشيخ مصطفى إسماعيل، والشيخ محمود علي البنا.',
  );

  @override
  List<Object?> get props => [
        id,
        nameArabic,
        subtitleArabic,
        frequencyDescription,
        primaryStreamUrl,
        backupStreamUrls,
        historicalNote,
      ];
}

/// Sleep timer options for live radio listening.
enum RadioSleepTimerDuration {
  none(0, 'معطل'),
  fifteenMinutes(15, '15 دقيقة'),
  thirtyMinutes(30, '30 دقيقة'),
  fortyFiveMinutes(45, '45 دقيقة'),
  sixtyMinutes(60, 'ساعة واحدة'),
  custom(0, 'مخصص');

  final int minutes;
  final String labelArabic;

  const RadioSleepTimerDuration(this.minutes, this.labelArabic);

  Duration get duration => Duration(minutes: minutes);
}
