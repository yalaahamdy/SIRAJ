import 'package:equatable/equatable.dart';

/// Immutable domain model representing a single episode or lesson from
/// Sheikh Mohamed Metwally El-Sharawy's Tafsir Khawatir archive (§14, §20).
class SharawyItem extends Equatable {
  final String id;
  final String cleanTitle;
  final String fullTitle;
  final int surahNumber;
  final String surahName;
  final String verseRange;
  final String scholar;
  final String duration;
  final double durationSeconds;
  final String url;
  final String filename;
  final int sizeBytes;
  final String? localFilePath;
  final bool isCustomLocal;

  const SharawyItem({
    required this.id,
    required this.cleanTitle,
    required this.fullTitle,
    required this.surahNumber,
    required this.surahName,
    required this.verseRange,
    required this.scholar,
    required this.duration,
    required this.durationSeconds,
    required this.url,
    required this.filename,
    required this.sizeBytes,
    this.localFilePath,
    this.isCustomLocal = false,
  });

  bool get isOfflineAvailable =>
      localFilePath != null && localFilePath!.isNotEmpty;

  SharawyItem copyWith({
    String? id,
    String? cleanTitle,
    String? fullTitle,
    int? surahNumber,
    String? surahName,
    String? verseRange,
    String? scholar,
    String? duration,
    double? durationSeconds,
    String? url,
    String? filename,
    int? sizeBytes,
    String? localFilePath,
    bool? isCustomLocal,
  }) {
    return SharawyItem(
      id: id ?? this.id,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      fullTitle: fullTitle ?? this.fullTitle,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      verseRange: verseRange ?? this.verseRange,
      scholar: scholar ?? this.scholar,
      duration: duration ?? this.duration,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      url: url ?? this.url,
      filename: filename ?? this.filename,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      localFilePath: localFilePath ?? this.localFilePath,
      isCustomLocal: isCustomLocal ?? this.isCustomLocal,
    );
  }

  factory SharawyItem.fromJson(Map<String, dynamic> json) {
    return SharawyItem(
      id: json['id'] as String? ?? '',
      cleanTitle: json['cleanTitle'] as String? ?? json['title'] as String? ?? '',
      fullTitle: json['title'] as String? ?? json['cleanTitle'] as String? ?? '',
      surahNumber: (json['surahNumber'] as num?)?.toInt() ?? 0,
      surahName: json['surahName'] as String? ?? 'المقدمات',
      verseRange: json['verseRange'] as String? ?? '',
      scholar: json['scholar'] as String? ?? 'الشيخ محمد متولي الشعراوي',
      duration: json['duration'] as String? ?? '--:--',
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0.0,
      url: json['url'] as String? ?? '',
      filename: json['filename'] as String? ?? '',
      sizeBytes: (json['sizeBytes'] as num?)?.toInt() ?? 0,
      localFilePath: json['localFilePath'] as String?,
      isCustomLocal: json['isCustomLocal'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cleanTitle': cleanTitle,
        'title': fullTitle,
        'surahNumber': surahNumber,
        'surahName': surahName,
        'verseRange': verseRange,
        'scholar': scholar,
        'duration': duration,
        'durationSeconds': durationSeconds,
        'url': url,
        'filename': filename,
        'sizeBytes': sizeBytes,
        if (localFilePath != null) 'localFilePath': localFilePath,
        'isCustomLocal': isCustomLocal,
      };

  @override
  List<Object?> get props => [
        id,
        cleanTitle,
        surahNumber,
        surahName,
        verseRange,
        scholar,
        url,
        localFilePath,
        isCustomLocal,
      ];
}
