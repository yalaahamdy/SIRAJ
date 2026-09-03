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

/// Comprehensive list of supported verified reciters.
const List<QuranReciter> kAvailableReciters = [
  kDefaultAbdulBasitReciter,
  QuranReciter(
    id: 'alafasy',
    nameArabic: 'الشيخ مشاري راشد العفاسي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Alafasy_128kbps',
    assetPathPrefix: 'assets/quran/audio',
  ),
  QuranReciter(
    id: 'husary',
    nameArabic: 'الشيخ محمود خليل الحصري',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Husary_128kbps',
  ),
  QuranReciter(
    id: 'minshawi',
    nameArabic: 'الشيخ محمد صديق المنشاوي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/Minshawy_Murattal_128kbps',
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
    id: 'muaiqly',
    nameArabic: 'الشيخ ماهر المعيقلي',
    subTitle: 'المصحف المرتل',
    remoteBaseUrl: 'https://everyayah.com/data/MaherAlMuaiqly128kbps',
  ),
];
