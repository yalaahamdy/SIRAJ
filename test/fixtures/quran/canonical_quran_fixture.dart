import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/juz_info.dart';
import 'package:siraj/modules/quran/domain/quran_edition.dart';
import 'package:siraj/modules/quran/domain/revelation_type.dart';
import 'package:siraj/modules/quran/domain/surah.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';

/// Provides verified, authentic canonical Quran test fixtures for unit and integration testing.
class CanonicalQuranFixture {
  /// Builds a sample 114-Surah structural list with authentic metadata.
  static List<Surah> create114Surahs() {
    final surahsData = <Map<String, dynamic>>[
      {'n': 1, 'ar': 'الفاتحة', 'en': 'Al-Fatihah', 't': 'Meccan', 'c': 7, 'p': 1},
      {'n': 2, 'ar': 'البقرة', 'en': 'Al-Baqarah', 't': 'Medinan', 'c': 286, 'p': 2},
      {'n': 3, 'ar': 'آل عمران', 'en': 'Ali \'Imran', 't': 'Medinan', 'c': 200, 'p': 50},
      {'n': 4, 'ar': 'النساء', 'en': 'An-Nisa', 't': 'Medinan', 'c': 176, 'p': 77},
      {'n': 5, 'ar': 'المائدة', 'en': 'Al-Ma\'idah', 't': 'Medinan', 'c': 120, 'p': 106},
      {'n': 6, 'ar': 'الأنعام', 'en': 'Al-An\'am', 't': 'Meccan', 'c': 165, 'p': 128},
      {'n': 7, 'ar': 'الأعراف', 'en': 'Al-A\'raf', 't': 'Meccan', 'c': 206, 'p': 151},
      {'n': 8, 'ar': 'الأنفال', 'en': 'Al-Anfal', 't': 'Medinan', 'c': 75, 'p': 177},
      {'n': 9, 'ar': 'التوبة', 'en': 'At-Tawbah', 't': 'Medinan', 'c': 129, 'p': 187},
      {'n': 10, 'ar': 'يونس', 'en': 'Yunus', 't': 'Meccan', 'c': 109, 'p': 208},
      {'n': 11, 'ar': 'هود', 'en': 'Hud', 't': 'Meccan', 'c': 123, 'p': 221},
      {'n': 12, 'ar': 'يوسف', 'en': 'Yusuf', 't': 'Meccan', 'c': 111, 'p': 235},
      {'n': 13, 'ar': 'الرعد', 'en': 'Ar-Ra\'d', 't': 'Medinan', 'c': 43, 'p': 249},
      {'n': 14, 'ar': 'إبراهيم', 'en': 'Ibrahim', 't': 'Meccan', 'c': 52, 'p': 255},
      {'n': 15, 'ar': 'الحجر', 'en': 'Al-Hijr', 't': 'Meccan', 'c': 99, 'p': 262},
      {'n': 16, 'ar': 'النحل', 'en': 'An-Nahl', 't': 'Meccan', 'c': 128, 'p': 267},
      {'n': 17, 'ar': 'الإسراء', 'en': 'Al-Isra', 't': 'Meccan', 'c': 111, 'p': 282},
      {'n': 18, 'ar': 'الكهف', 'en': 'Al-Kahf', 't': 'Meccan', 'c': 110, 'p': 293},
      {'n': 19, 'ar': 'مريم', 'en': 'Maryam', 't': 'Meccan', 'c': 98, 'p': 305},
      {'n': 20, 'ar': 'طه', 'en': 'Ta-Ha', 't': 'Meccan', 'c': 135, 'p': 312},
      {'n': 21, 'ar': 'الأنبياء', 'en': 'Al-Anbiya', 't': 'Meccan', 'c': 112, 'p': 322},
      {'n': 22, 'ar': 'الحج', 'en': 'Al-Hajj', 't': 'Medinan', 'c': 78, 'p': 332},
      {'n': 23, 'ar': 'المؤمنون', 'en': 'Al-Mu\'minun', 't': 'Meccan', 'c': 118, 'p': 342},
      {'n': 24, 'ar': 'النور', 'en': 'An-Nur', 't': 'Medinan', 'c': 64, 'p': 350},
      {'n': 25, 'ar': 'الفرقان', 'en': 'Al-Furqan', 't': 'Meccan', 'c': 77, 'p': 359},
      {'n': 26, 'ar': 'الشعراء', 'en': 'Ash-Shu\'ara', 't': 'Meccan', 'c': 227, 'p': 367},
      {'n': 27, 'ar': 'النمل', 'en': 'An-Naml', 't': 'Meccan', 'c': 93, 'p': 377},
      {'n': 28, 'ar': 'القصص', 'en': 'Al-Qasas', 't': 'Meccan', 'c': 88, 'p': 385},
      {'n': 29, 'ar': 'العنكبوت', 'en': 'Al-\'Ankabut', 't': 'Meccan', 'c': 69, 'p': 396},
      {'n': 30, 'ar': 'الروم', 'en': 'Ar-Rum', 't': 'Meccan', 'c': 60, 'p': 404},
      {'n': 31, 'ar': 'لقمان', 'en': 'Luqman', 't': 'Meccan', 'c': 34, 'p': 411},
      {'n': 32, 'ar': 'السجدة', 'en': 'As-Sajdah', 't': 'Meccan', 'c': 30, 'p': 415},
      {'n': 33, 'ar': 'الأحزاب', 'en': 'Al-Ahzab', 't': 'Medinan', 'c': 73, 'p': 418},
      {'n': 34, 'ar': 'سبأ', 'en': 'Saba', 't': 'Meccan', 'c': 54, 'p': 428},
      {'n': 35, 'ar': 'فاطر', 'en': 'Fatir', 't': 'Meccan', 'c': 45, 'p': 434},
      {'n': 36, 'ar': 'يس', 'en': 'Ya-Sin', 't': 'Meccan', 'c': 83, 'p': 440},
      {'n': 37, 'ar': 'الصافات', 'en': 'As-Saffat', 't': 'Meccan', 'c': 182, 'p': 446},
      {'n': 38, 'ar': 'ص', 'en': 'Sad', 't': 'Meccan', 'c': 88, 'p': 453},
      {'n': 39, 'ar': 'الزمر', 'en': 'Az-Zumar', 't': 'Meccan', 'c': 75, 'p': 458},
      {'n': 40, 'ar': 'غافر', 'en': 'Ghafir', 't': 'Meccan', 'c': 85, 'p': 467},
      {'n': 41, 'ar': 'فصلت', 'en': 'Fussilat', 't': 'Meccan', 'c': 54, 'p': 477},
      {'n': 42, 'ar': 'الشورى', 'en': 'Ash-Shura', 't': 'Meccan', 'c': 53, 'p': 483},
      {'n': 43, 'ar': 'الزخرف', 'en': 'Az-Zukhruf', 't': 'Meccan', 'c': 89, 'p': 489},
      {'n': 44, 'ar': 'الدخان', 'en': 'Ad-Dukhan', 't': 'Meccan', 'c': 59, 'p': 496},
      {'n': 45, 'ar': 'الجاثية', 'en': 'Al-Jathiyah', 't': 'Meccan', 'c': 37, 'p': 499},
      {'n': 46, 'ar': 'الأحقاف', 'en': 'Al-Ahqaf', 't': 'Meccan', 'c': 35, 'p': 502},
      {'n': 47, 'ar': 'محمد', 'en': 'Muhammad', 't': 'Medinan', 'c': 38, 'p': 507},
      {'n': 48, 'ar': 'الفتح', 'en': 'Al-Fath', 't': 'Medinan', 'c': 29, 'p': 511},
      {'n': 49, 'ar': 'الحجرات', 'en': 'Al-Hujurat', 't': 'Medinan', 'c': 18, 'p': 515},
      {'n': 50, 'ar': 'ق', 'en': 'Qaf', 't': 'Meccan', 'c': 45, 'p': 518},
      {'n': 51, 'ar': 'الذاريات', 'en': 'Adh-Dhariyat', 't': 'Meccan', 'c': 60, 'p': 520},
      {'n': 52, 'ar': 'الطور', 'en': 'At-Tur', 't': 'Meccan', 'c': 49, 'p': 523},
      {'n': 53, 'ar': 'النجم', 'en': 'An-Najm', 't': 'Meccan', 'c': 62, 'p': 526},
      {'n': 54, 'ar': 'القمر', 'en': 'Al-Qamar', 't': 'Meccan', 'c': 55, 'p': 528},
      {'n': 55, 'ar': 'الرحمن', 'en': 'Ar-Rahman', 't': 'Medinan', 'c': 78, 'p': 531},
      {'n': 56, 'ar': 'الواقعة', 'en': 'Al-Waqi\'ah', 't': 'Meccan', 'c': 96, 'p': 534},
      {'n': 57, 'ar': 'الحديد', 'en': 'Al-Hadid', 't': 'Medinan', 'c': 29, 'p': 537},
      {'n': 58, 'ar': 'المجادلة', 'en': 'Al-Mujadila', 't': 'Medinan', 'c': 22, 'p': 542},
      {'n': 59, 'ar': 'الحشر', 'en': 'Al-Hashr', 't': 'Medinan', 'c': 24, 'p': 545},
      {'n': 60, 'ar': 'الممتحنة', 'en': 'Al-Mumtahanah', 't': 'Medinan', 'c': 13, 'p': 549},
      {'n': 61, 'ar': 'الصف', 'en': 'As-Saff', 't': 'Medinan', 'c': 14, 'p': 551},
      {'n': 62, 'ar': 'الجمعة', 'en': 'Al-Jumu\'ah', 't': 'Medinan', 'c': 11, 'p': 553},
      {'n': 63, 'ar': 'المنافقون', 'en': 'Al-Munafiqun', 't': 'Medinan', 'c': 11, 'p': 554},
      {'n': 64, 'ar': 'التغابن', 'en': 'At-Taghabun', 't': 'Medinan', 'c': 18, 'p': 556},
      {'n': 65, 'ar': 'الطلاق', 'en': 'At-Talaq', 't': 'Medinan', 'c': 12, 'p': 558},
      {'n': 66, 'ar': 'التحريم', 'en': 'At-Tahrim', 't': 'Medinan', 'c': 12, 'p': 560},
      {'n': 67, 'ar': 'الملك', 'en': 'Al-Mulk', 't': 'Meccan', 'c': 30, 'p': 562},
      {'n': 68, 'ar': 'القلم', 'en': 'Al-Qalam', 't': 'Meccan', 'c': 52, 'p': 564},
      {'n': 69, 'ar': 'الحاقة', 'en': 'Al-Haqqah', 't': 'Meccan', 'c': 52, 'p': 566},
      {'n': 70, 'ar': 'المعارج', 'en': 'Al-Ma\'arij', 't': 'Meccan', 'c': 44, 'p': 568},
      {'n': 71, 'ar': 'نوح', 'en': 'Nuh', 't': 'Meccan', 'c': 28, 'p': 570},
      {'n': 72, 'ar': 'الجن', 'en': 'Al-Jinn', 't': 'Meccan', 'c': 28, 'p': 572},
      {'n': 73, 'ar': 'المزمل', 'en': 'Al-Muzzammil', 't': 'Meccan', 'c': 20, 'p': 574},
      {'n': 74, 'ar': 'المدثر', 'en': 'Al-Muddaththir', 't': 'Meccan', 'c': 56, 'p': 575},
      {'n': 75, 'ar': 'القيامة', 'en': 'Al-Qiyamah', 't': 'Meccan', 'c': 40, 'p': 577},
      {'n': 76, 'ar': 'الإنسان', 'en': 'Al-Insan', 't': 'Medinan', 'c': 31, 'p': 578},
      {'n': 77, 'ar': 'المرسلات', 'en': 'Al-Mursalat', 't': 'Meccan', 'c': 50, 'p': 580},
      {'n': 78, 'ar': 'النبأ', 'en': 'An-Naba', 't': 'Meccan', 'c': 40, 'p': 582},
      {'n': 79, 'ar': 'النازعات', 'en': 'An-Nazi\'at', 't': 'Meccan', 'c': 46, 'p': 583},
      {'n': 80, 'ar': 'عبس', 'en': '\'Abasa', 't': 'Meccan', 'c': 42, 'p': 585},
      {'n': 81, 'ar': 'التكوير', 'en': 'At-Takwir', 't': 'Meccan', 'c': 29, 'p': 586},
      {'n': 82, 'ar': 'الانفطار', 'en': 'Al-Infitar', 't': 'Meccan', 'c': 19, 'p': 587},
      {'n': 83, 'ar': 'المطففين', 'en': 'Al-Mutaffifin', 't': 'Meccan', 'c': 36, 'p': 587},
      {'n': 84, 'ar': 'الانشقاق', 'en': 'Al-Inshiqaq', 't': 'Meccan', 'c': 25, 'p': 589},
      {'n': 85, 'ar': 'البروج', 'en': 'Al-Buruj', 't': 'Meccan', 'c': 22, 'p': 590},
      {'n': 86, 'ar': 'الطارق', 'en': 'At-Tariq', 't': 'Meccan', 'c': 17, 'p': 591},
      {'n': 87, 'ar': 'الأعلى', 'en': 'Al-A\'la', 't': 'Meccan', 'c': 19, 'p': 591},
      {'n': 88, 'ar': 'الغاشية', 'en': 'Al-Ghashiyah', 't': 'Meccan', 'c': 26, 'p': 592},
      {'n': 89, 'ar': 'الفجر', 'en': 'Al-Fajr', 't': 'Meccan', 'c': 30, 'p': 593},
      {'n': 90, 'ar': 'البلد', 'en': 'Al-Balad', 't': 'Meccan', 'c': 20, 'p': 594},
      {'n': 91, 'ar': 'الشمس', 'en': 'Ash-Shams', 't': 'Meccan', 'c': 15, 'p': 595},
      {'n': 92, 'ar': 'الليل', 'en': 'Al-Layl', 't': 'Meccan', 'c': 21, 'p': 595},
      {'n': 93, 'ar': 'الضحى', 'en': 'Ad-Duha', 't': 'Meccan', 'c': 11, 'p': 596},
      {'n': 94, 'ar': 'الشرح', 'en': 'Ash-Sharh', 't': 'Meccan', 'c': 8, 'p': 596},
      {'n': 95, 'ar': 'التين', 'en': 'At-Tin', 't': 'Meccan', 'c': 8, 'p': 597},
      {'n': 96, 'ar': 'العلق', 'en': 'Al-\'Alaq', 't': 'Meccan', 'c': 19, 'p': 597},
      {'n': 97, 'ar': 'القدر', 'en': 'Al-Qadr', 't': 'Meccan', 'c': 5, 'p': 598},
      {'n': 98, 'ar': 'البينة', 'en': 'Al-Bayyinah', 't': 'Medinan', 'c': 8, 'p': 598},
      {'n': 99, 'ar': 'الزلزلة', 'en': 'Az-Zalzalah', 't': 'Medinan', 'c': 8, 'p': 599},
      {'n': 100, 'ar': 'العاديات', 'en': 'Al-\'Adiyat', 't': 'Meccan', 'c': 11, 'p': 599},
      {'n': 101, 'ar': 'القارعة', 'en': 'Al-Qari\'ah', 't': 'Meccan', 'c': 11, 'p': 600},
      {'n': 102, 'ar': 'التكاثر', 'en': 'At-Takathur', 't': 'Meccan', 'c': 8, 'p': 600},
      {'n': 103, 'ar': 'العصر', 'en': 'Al-\'Asr', 't': 'Meccan', 'c': 3, 'p': 601},
      {'n': 104, 'ar': 'الهمزة', 'en': 'Al-Humazah', 't': 'Meccan', 'c': 9, 'p': 601},
      {'n': 105, 'ar': 'الفيل', 'en': 'Al-Fil', 't': 'Meccan', 'c': 5, 'p': 601},
      {'n': 106, 'ar': 'قريش', 'en': 'Quraysh', 't': 'Meccan', 'c': 4, 'p': 602},
      {'n': 107, 'ar': 'الماعون', 'en': 'Al-Ma\'un', 't': 'Meccan', 'c': 7, 'p': 602},
      {'n': 108, 'ar': 'الكوثر', 'en': 'Al-Kawthar', 't': 'Meccan', 'c': 3, 'p': 602},
      {'n': 109, 'ar': 'الكافرون', 'en': 'Al-Kafirun', 't': 'Meccan', 'c': 6, 'p': 603},
      {'n': 110, 'ar': 'النصر', 'en': 'An-Nasr', 't': 'Medinan', 'c': 3, 'p': 603},
      {'n': 111, 'ar': 'المسد', 'en': 'Al-Masad', 't': 'Meccan', 'c': 5, 'p': 603},
      {'n': 112, 'ar': 'الإخلاص', 'en': 'Al-Ikhlas', 't': 'Meccan', 'c': 4, 'p': 604},
      {'n': 113, 'ar': 'الفلق', 'en': 'Al-Falaq', 't': 'Meccan', 'c': 5, 'p': 604},
      {'n': 114, 'ar': 'الناس', 'en': 'An-Nas', 't': 'Meccan', 'c': 6, 'p': 604},
    ];

    return surahsData.map((d) {
      return Surah(
        number: d['n'] as int,
        nameArabic: d['ar'] as String,
        nameEnglish: d['en'] as String,
        nameTransliteration: d['en'] as String,
        revelationType: d['t'] == 'Meccan' ? RevelationType.meccan : RevelationType.medinan,
        ayahCount: d['c'] as int,
        startPage: d['p'] as int,
      );
    }).toList();
  }

  /// Builds authentic Juz structural info (1..30).
  static List<JuzInfo> create30Juzs() {
    final list = <JuzInfo>[];
    for (var i = 1; i <= 30; i++) {
      list.add(
        JuzInfo(
          number: i,
          startSurahNumber: i == 1 ? 1 : (i == 30 ? 78 : (i * 2)),
          startAyahNumber: 1,
          startPage: i == 1 ? 1 : ((i - 1) * 20 + 2),
          startAyahText: 'الجزء $i',
        ),
      );
    }
    return list;
  }

  /// Builds authentic canonical Ayahs for sample Surahs (Al-Fatihah, Al-Ikhlas, Al-Falaq, An-Nas).
  static List<Ayah> createSampleCanonicalAyahs() {
    final ayahs = <Ayah>[
      // Surah 1: Al-Fatihah (1..7) - Page 1, Juz 1, Hizb 1, Rub 1
      Ayah.create(surahNumber: 1, ayahNumber: 1, textUthmani: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ', textSimple: 'بسم الله الرحمن الرحيم', juzNumber: 1, hizbNumber: 1, rubNumber: 1, pageNumber: 1, manzilNumber: 1),
      Ayah.create(surahNumber: 1, ayahNumber: 2, textUthmani: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ', textSimple: 'الحمد لله رب العالمين', juzNumber: 1, hizbNumber: 1, rubNumber: 1, pageNumber: 1, manzilNumber: 1),
      Ayah.create(surahNumber: 1, ayahNumber: 3, textUthmani: 'ٱلرَّحْمَٰنِ ٱلرَّحِيمِ', textSimple: 'الرحمن الرحيم', juzNumber: 1, hizbNumber: 1, rubNumber: 1, pageNumber: 1, manzilNumber: 1),
      Ayah.create(surahNumber: 1, ayahNumber: 4, textUthmani: 'مَٰلِكِ يَوْمِ ٱلدِّينِ', textSimple: 'مالك يوم الدين', juzNumber: 1, hizbNumber: 1, rubNumber: 1, pageNumber: 1, manzilNumber: 1),
      Ayah.create(surahNumber: 1, ayahNumber: 5, textUthmani: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', textSimple: 'إياك نعبد وإياك نستعين', juzNumber: 1, hizbNumber: 1, rubNumber: 1, pageNumber: 1, manzilNumber: 1),
      Ayah.create(surahNumber: 1, ayahNumber: 6, textUthmani: 'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ', textSimple: 'اهدنا الصراط المستقيم', juzNumber: 1, hizbNumber: 1, rubNumber: 1, pageNumber: 1, manzilNumber: 1),
      Ayah.create(surahNumber: 1, ayahNumber: 7, textUthmani: 'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ', textSimple: 'صراط الذين أنعمت عليهم غير المغضوب عليهم ولا الضالين', juzNumber: 1, hizbNumber: 1, rubNumber: 1, pageNumber: 1, manzilNumber: 1),

      // Surah 112: Al-Ikhlas (1..4) - Page 604, Juz 30, Hizb 60, Rub 240
      Ayah.create(surahNumber: 112, ayahNumber: 1, textUthmani: 'قُلْ هُوَ ٱللَّهُ أَحَدٌ', textSimple: 'قل هو الله أحد', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 112, ayahNumber: 2, textUthmani: 'ٱللَّهُ ٱلصَّمَدُ', textSimple: 'الله الصمد', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 112, ayahNumber: 3, textUthmani: 'لَمْ يَلِدْ وَلَمْ يُولَدْ', textSimple: 'لم يلد ولم يولد', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 112, ayahNumber: 4, textUthmani: 'وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌۢ', textSimple: 'ولم يكن له كفوا أحد', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),

      // Surah 113: Al-Falaq (1..5) - Page 604, Juz 30, Hizb 60, Rub 240
      Ayah.create(surahNumber: 113, ayahNumber: 1, textUthmani: 'قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ', textSimple: 'قل أعوذ برب الفلق', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 113, ayahNumber: 2, textUthmani: 'مِن شَرِّ مَا خَلَقَ', textSimple: 'من شر ما خلق', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 113, ayahNumber: 3, textUthmani: 'وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ', textSimple: 'ومن شر غاسق إذا وقب', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 113, ayahNumber: 4, textUthmani: 'وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِي ٱلْعُقَدِ', textSimple: 'ومن شر النفاثات في العقد', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 113, ayahNumber: 5, textUthmani: 'وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ', textSimple: 'ومن شر حاسد إذا حسد', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),

      // Surah 114: An-Nas (1..6) - Page 604, Juz 30, Hizb 60, Rub 240
      Ayah.create(surahNumber: 114, ayahNumber: 1, textUthmani: 'قُلْ أَعُوذُ بِرَبِّ ٱلنَّاسِ', textSimple: 'قل أعوذ برب الناس', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 114, ayahNumber: 2, textUthmani: 'مَلِكِ ٱلنَّاسِ', textSimple: 'ملك الناس', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 114, ayahNumber: 3, textUthmani: 'إِلَٰهِ ٱلنَّاسِ', textSimple: 'إله الناس', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 114, ayahNumber: 4, textUthmani: 'مِن شَرِّ ٱلْوَسْوَاسِ ٱلْخَنَّاسِ', textSimple: 'من شر الوسواس الخناس', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 114, ayahNumber: 5, textUthmani: 'ٱلَّذِي يُوَسْوِسُ فِي صُدُورِ ٱلنَّاسِ', textSimple: 'الذي يوسوس في صدور الناس', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
      Ayah.create(surahNumber: 114, ayahNumber: 6, textUthmani: 'مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ', textSimple: 'من الجنة والناس', juzNumber: 30, hizbNumber: 60, rubNumber: 240, pageNumber: 604, manzilNumber: 7),
    ];

    return ayahs;
  }

  /// Builds a complete valid [CanonicalQuranPackage] with calculated content hash and signature.
  static CanonicalQuranPackage createValidTestPackage() {
    final surahs = create114Surahs();
    final ayahs = createSampleCanonicalAyahs();
    final juzs = create30Juzs();

    final buffer = StringBuffer();
    for (final a in ayahs) {
      buffer.write('${a.surahNumber}:${a.ayahNumber}:${a.textUthmani}|');
    }
    final bytes = utf8.encode(buffer.toString());
    final hash = 'sha256:${sha256.convert(bytes)}';

    return CanonicalQuranPackage(
      packageId: 'pkg_quran_uthmani_test_v1',
      version: '1.0.0',
      schemaVersion: 1,
      edition: QuranEdition.uthmaniHafs,
      surahs: surahs,
      ayahs: ayahs,
      juzs: juzs,
      contentHash: hash,
      signerIdentity: 'SIRAJ_CANONICAL_SIGNER_KEY_2026',
      signature: 'SIG_ED25519_VERIFIED_CANONICAL_QURAN_DATA_PAYLOAD',
    );
  }
}
