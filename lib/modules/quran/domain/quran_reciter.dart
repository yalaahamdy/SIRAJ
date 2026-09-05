import 'dart:io';
import 'package:equatable/equatable.dart';

/// Reciter definition and audio source resolver for the Quran recitation engine (§14).
class QuranReciter extends Equatable {
  final String id;
  final String nameArabic;
  final String subTitle;
  final String? localDirectoryPath;
  final String? remoteBaseUrl;
  final String? assetPathPrefix;
  final bool isDefault;

  static String? customOfflineAudioBasePath;

  const QuranReciter({
    required this.id,
    required this.nameArabic,
    required this.subTitle,
    this.localDirectoryPath,
    this.remoteBaseUrl,
    this.assetPathPrefix,
    this.isDefault = false,
  });

  /// Resolves the candidate audio paths/URLs in order of priority:
  /// 1. Offline custom storage directory (imported ZIP or downloaded Surahs)
  /// 2. Local path on device (if available)
  /// 3. Remote CDN URL (if available)
  /// 4. Bundled asset (only if specifically defined for this reciter)
  List<String> resolveCandidateUris(int surahNumber, int ayahNumber) {
    final sPad = surahNumber.toString().padLeft(3, '0');
    final aPad = ayahNumber.toString().padLeft(3, '0');
    final fileName = '$sPad$aPad.mp3';

    final candidates = <String>[];
    final sep = Platform.pathSeparator;

    // 1. App-specific local offline directory (imported from ZIP or downloaded on-demand)
    if (customOfflineAudioBasePath != null && customOfflineAudioBasePath!.isNotEmpty) {
      candidates.add('$customOfflineAudioBasePath$sep$id$sep$fileName');
    }

    // 2. Local primary directory (e.g. for Sheikh Abdul Basit local folder on Windows/storage)
    if (localDirectoryPath != null && localDirectoryPath!.isNotEmpty) {
      candidates.add('$localDirectoryPath$sep$fileName');
      candidates.add('عبد الباسط عبد الصمد - المصحف المرتل$sep$fileName');
    }

    // 3. Remote primary CDN stream (EveryAyah high-bitrate)
    if (remoteBaseUrl != null && remoteBaseUrl!.isNotEmpty) {
      candidates.add('$remoteBaseUrl/$fileName');
    }

    // 4. Bundled assets fallback (only for reciters with offline packaged assets)
    if (assetPathPrefix != null && assetPathPrefix!.isNotEmpty) {
      candidates.add('$assetPathPrefix/$sPad/$aPad.mp3');
    }

    return candidates;
  }

  @override
  List<Object?> get props => [
        id,
        nameArabic,
        subTitle,
        localDirectoryPath,
        remoteBaseUrl,
        assetPathPrefix,
        isDefault,
      ];
}

/// Default Reciter: Sheikh Abdul Basit Abdul Samad (Murattal) with full local folder + 192kbps EveryAyah CDN.
const kDefaultAbdulBasitReciter = QuranReciter(
  id: 'abdulbasit_murattal',
  nameArabic: 'الشيخ عبد الباسط عبد الصمد',
  subTitle: 'المصحف المرتل (الافتراضي)',
  localDirectoryPath: r'D:\Downloads\Downloads\projects\SIRAJ\عبد الباسط عبد الصمد - المصحف المرتل',
  remoteBaseUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_192kbps',
  isDefault: true,
);

/// Comprehensive list of supported verified reciters (30+ top renowned reciters across the Islamic world).
const List<QuranReciter> kAvailableReciters = [
  kDefaultAbdulBasitReciter,
  QuranReciter(
    id: 'abdulbasit_mujawwad',
    nameArabic: 'الشيخ عبد الباسط عبد الصمد (المجود)',
    subTitle: 'المصحف المجود',
    remoteBaseUrl: 'https://everyayah.com/data/Abdul_Basit_Mujawwad_128kbps',
  ),
  QuranReciter(
    id: 'minshawi',
    nameArabic: 'الشيخ محمد صديق المنشاوي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Minshawy_Murattal_128kbps',
  ),
  QuranReciter(
    id: 'minshawi_mujawwad',
    nameArabic: 'الشيخ محمد صديق المنشاوي (المجود)',
    subTitle: 'المصحف المجود',
    remoteBaseUrl: 'https://everyayah.com/data/Minshawy_Mujawwad_192kbps',
  ),
  QuranReciter(
    id: 'minshawi_teacher',
    nameArabic: 'الشيخ محمد صديق المنشاوي (المعلم)',
    subTitle: 'المصحف المعلم مع ترديد الأطفال',
    remoteBaseUrl: 'https://everyayah.com/data/Minshawy_Teacher_128kbps',
  ),
  QuranReciter(
    id: 'husary',
    nameArabic: 'الشيخ محمود خليل الحصري',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Husary_128kbps',
  ),
  QuranReciter(
    id: 'husary_mujawwad',
    nameArabic: 'الشيخ محمود خليل الحصري (المجود)',
    subTitle: 'المصحف المجود',
    remoteBaseUrl: 'https://everyayah.com/data/Husary_128kbps_Mujawwad',
  ),
  QuranReciter(
    id: 'husary_muallim',
    nameArabic: 'الشيخ محمود خليل الحصري (المعلم)',
    subTitle: 'المصحف المعلم',
    remoteBaseUrl: 'https://everyayah.com/data/Husary_Muallim_128kbps',
  ),
  QuranReciter(
    id: 'mustafa_ismail',
    nameArabic: 'الشيخ مصطفى إسماعيل (المجود)',
    subTitle: 'المصحف المجود',
    remoteBaseUrl: 'https://everyayah.com/data/Mustafa_Ismail_48kbps',
  ),
  QuranReciter(
    id: 'banna_murattal',
    nameArabic: 'الشيخ محمود علي البنا',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/mahmoud_ali_al_banna_32kbps',
  ),
  QuranReciter(
    id: 'tablaway',
    nameArabic: 'الشيخ محمد محمود الطبلاوي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Mohammad_al_Tablaway_128kbps',
  ),
  QuranReciter(
    id: 'neana',
    nameArabic: 'الشيخ أحمد نعينع',
    subTitle: 'المصحف المجود',
    remoteBaseUrl: 'https://everyayah.com/data/Ahmed_Neana_128kbps',
  ),
  QuranReciter(
    id: 'suessi',
    nameArabic: 'الشيخ علي حجاج السويسي',
    subTitle: 'المصحف المجود',
    remoteBaseUrl: 'https://everyayah.com/data/Ali_Hajjaj_AlSuesy_128kbps',
  ),
  QuranReciter(
    id: 'alafasy',
    nameArabic: 'الشيخ مشاري راشد العفاسي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Alafasy_128kbps',
    assetPathPrefix: 'assets/quran/audio',
  ),
  QuranReciter(
    id: 'sudais',
    nameArabic: 'الشيخ عبد الرحمن السديس',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Abdurrahmaan_As-Sudais_192kbps',
  ),
  QuranReciter(
    id: 'shuraym',
    nameArabic: 'الشيخ سعود الشريم',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Saood_ash-Shuraym_128kbps',
  ),
  QuranReciter(
    id: 'muaiqly',
    nameArabic: 'الشيخ ماهر المعيقلي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/MaherAlMuaiqly128kbps',
  ),
  QuranReciter(
    id: 'dussary',
    nameArabic: 'الشيخ ياسر الدوسري',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Yasser_Ad-Dussary_128kbps',
  ),
  QuranReciter(
    id: 'qatami',
    nameArabic: 'الشيخ ناصر القطامي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Nasser_Alqatami_128kbps',
  ),
  QuranReciter(
    id: 'ajamy',
    nameArabic: 'الشيخ أحمد بن علي العجمي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/ahmed_ibn_ali_al_ajamy_128kbps',
  ),
  QuranReciter(
    id: 'ghamadi',
    nameArabic: 'الشيخ سعد الغامدي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Ghamadi_40kbps',
  ),
  QuranReciter(
    id: 'shatri',
    nameArabic: 'الشيخ أبو بكر الشاطري',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Abu_Bakr_Ash-Shaatree_128kbps',
  ),
  QuranReciter(
    id: 'hudhaify',
    nameArabic: 'الشيخ علي الحذيفي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Hudhaify_128kbps',
  ),
  QuranReciter(
    id: 'ayyoub',
    nameArabic: 'الشيخ محمد أيوب',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Muhammad_Ayyoub_128kbps',
  ),
  QuranReciter(
    id: 'jibreel',
    nameArabic: 'الشيخ محمد جبريل',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Muhammad_Jibreel_128kbps',
  ),
  QuranReciter(
    id: 'ali_jaber',
    nameArabic: 'الشيخ علي جابر',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Ali_Jaber_64kbps',
  ),
  QuranReciter(
    id: 'basfar',
    nameArabic: 'الشيخ عبد الله بصفر',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Abdullah_Basfar_192kbps',
  ),
  QuranReciter(
    id: 'matroud',
    nameArabic: 'الشيخ عبد الله مطرود',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Abdullah_Matroud_128kbps',
  ),
  QuranReciter(
    id: 'abbad',
    nameArabic: 'الشيخ فارس عباد',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Fares_Abbad_64kbps',
  ),
  QuranReciter(
    id: 'rifai',
    nameArabic: 'الشيخ هاني الرفاعي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Hani_Rifai_192kbps',
  ),
  QuranReciter(
    id: 'tunayji',
    nameArabic: 'الشيخ خليفة الطنيجي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/khalefa_al_tunaiji_64kbps',
  ),
  QuranReciter(
    id: 'budair',
    nameArabic: 'الشيخ صلاح البدير',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Salah_Al_Budair_128kbps',
  ),
  QuranReciter(
    id: 'juhaynee',
    nameArabic: 'الشيخ عبد الله عواد الجهني',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Abdullaah_3awwaad_Al-Juhaynee_128kbps',
  ),
  QuranReciter(
    id: 'akhdar',
    nameArabic: 'الشيخ إبراهيم الأخضر',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Ibrahim_Akhdar_32kbps',
  ),
  QuranReciter(
    id: 'qahtani',
    nameArabic: 'الشيخ خالد القحطاني',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Khaalid_Abdullaah_al-Qahtaanee_192kbps',
  ),
  QuranReciter(
    id: 'bukhatir',
    nameArabic: 'الشيخ صلاح بو خاطر',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Salaah_AbdulRahman_Bukhatir_128kbps',
  ),
  QuranReciter(
    id: 'muhsin_qasim',
    nameArabic: 'الشيخ عبد المحسن القاسم',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Muhsin_Al_Qasim_192kbps',
  ),
  QuranReciter(
    id: 'yaser_salamah',
    nameArabic: 'الشيخ ياسر سلامة',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Yaser_Salamah_128kbps',
  ),
  QuranReciter(
    id: 'ayman_sowaid',
    nameArabic: 'الدكتور أيمن رشدي سويد',
    subTitle: 'المصحف المعلم والتجويد',
    remoteBaseUrl: 'https://everyayah.com/data/Ayman_Sowaid_64kbps',
  ),
  QuranReciter(
    id: 'aziz_alili',
    nameArabic: 'الشيخ عزيز عليلي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/aziz_alili_128kbps',
  ),
  QuranReciter(
    id: 'sahl_yassin',
    nameArabic: 'الشيخ سهل ياسين',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Sahl_Yassin_128kbps',
  ),
];
