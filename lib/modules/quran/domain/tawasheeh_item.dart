import 'package:equatable/equatable.dart';

/// Represents a single historic Tawasheeh or Ibtihal track (§14, §20).
class TawasheehItem extends Equatable {
  final String id;
  final String cleanTitle;
  final String fullTitle;
  final String reciter;
  final String duration;
  final double durationSeconds;
  final String url;
  final String? localFilePath;
  final bool isCustomLocal;

  const TawasheehItem({
    required this.id,
    required this.cleanTitle,
    required this.fullTitle,
    required this.reciter,
    required this.duration,
    required this.durationSeconds,
    required this.url,
    this.localFilePath,
    this.isCustomLocal = false,
  });

  bool get isOfflineAvailable =>
      localFilePath != null && localFilePath!.isNotEmpty;

  TawasheehItem copyWith({
    String? id,
    String? cleanTitle,
    String? fullTitle,
    String? reciter,
    String? duration,
    double? durationSeconds,
    String? url,
    String? localFilePath,
    bool? isCustomLocal,
  }) {
    return TawasheehItem(
      id: id ?? this.id,
      cleanTitle: cleanTitle ?? this.cleanTitle,
      fullTitle: fullTitle ?? this.fullTitle,
      reciter: reciter ?? this.reciter,
      duration: duration ?? this.duration,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      url: url ?? this.url,
      localFilePath: localFilePath ?? this.localFilePath,
      isCustomLocal: isCustomLocal ?? this.isCustomLocal,
    );
  }

  factory TawasheehItem.fromJson(Map<String, dynamic> json) {
    return TawasheehItem(
      id: json['id'] as String? ?? '',
      cleanTitle: json['cleanTitle'] as String? ?? json['title'] as String? ?? '',
      fullTitle: json['title'] as String? ?? json['cleanTitle'] as String? ?? '',
      reciter: json['reciter'] as String? ?? 'كبار المبتهلين',
      duration: json['duration'] as String? ?? '--:--',
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0.0,
      url: json['url'] as String? ?? '',
      localFilePath: json['localFilePath'] as String?,
      isCustomLocal: json['isCustomLocal'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cleanTitle': cleanTitle,
        'title': fullTitle,
        'reciter': reciter,
        'duration': duration,
        'durationSeconds': durationSeconds,
        'url': url,
        if (localFilePath != null) 'localFilePath': localFilePath,
        'isCustomLocal': isCustomLocal,
      };

  @override
  List<Object?> get props => [id, cleanTitle, reciter, url, localFilePath, isCustomLocal];
}
