import 'package:equatable/equatable.dart';

/// Recitation operating modes (§3, §4).
enum RecitationMode {
  /// Mode A: Record audio locally, hide text, replay, and self-evaluate.
  recordAndReplay,

  /// Mode B: Real-time speech recognition, smart alignment, and reveal hints.
  recognition,
}

/// Policies for repeating Quranic audio playback during memorization drills (§14, §15).
enum PlaybackRepeatPolicy {
  /// Play once and stop.
  none,

  /// Repeat the current Ayah N times.
  ayah,

  /// Repeat the current Range N times.
  range,

  /// Repeat the entire Surah N times.
  surah,
}

/// Supported audio speeds verified on native audio players (§15).
class PlaybackSpeedOptions {
  static const List<double> supportedSpeeds = [0.75, 1.0, 1.25, 1.5];

  static bool isSupported(double speed) =>
      supportedSpeeds.contains(speed);
}

/// Complete recitation playback and memorization policy configuration.
class RecitationPolicyConfig extends Equatable {
  final PlaybackRepeatPolicy repeatPolicy;
  final int repeatCount;
  final double playbackSpeed;
  final Duration delayBetweenAyahs;
  final bool autoAdvance;
  final bool autoScroll;

  const RecitationPolicyConfig({
    this.repeatPolicy = PlaybackRepeatPolicy.none,
    this.repeatCount = 1,
    this.playbackSpeed = 1.0,
    this.delayBetweenAyahs = Duration.zero,
    this.autoAdvance = true,
    this.autoScroll = true,
  })  : assert(repeatCount >= 1, 'repeatCount must be >= 1'),
        assert(playbackSpeed >= 0.5 && playbackSpeed <= 2.0, 'Speed must be between 0.5 and 2.0');

  RecitationPolicyConfig copyWith({
    PlaybackRepeatPolicy? repeatPolicy,
    int? repeatCount,
    double? playbackSpeed,
    Duration? delayBetweenAyahs,
    bool? autoAdvance,
    bool? autoScroll,
  }) {
    return RecitationPolicyConfig(
      repeatPolicy: repeatPolicy ?? this.repeatPolicy,
      repeatCount: repeatCount ?? this.repeatCount,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      delayBetweenAyahs: delayBetweenAyahs ?? this.delayBetweenAyahs,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      autoScroll: autoScroll ?? this.autoScroll,
    );
  }

  Map<String, dynamic> toJson() => {
        'repeatPolicy': repeatPolicy.name,
        'repeatCount': repeatCount,
        'playbackSpeed': playbackSpeed,
        'delayBetweenAyahsMs': delayBetweenAyahs.inMilliseconds,
        'autoAdvance': autoAdvance,
        'autoScroll': autoScroll,
      };

  factory RecitationPolicyConfig.fromJson(Map<String, dynamic> json) =>
      RecitationPolicyConfig(
        repeatPolicy: PlaybackRepeatPolicy.values.firstWhere(
          (p) => p.name == json['repeatPolicy'],
          orElse: () => PlaybackRepeatPolicy.none,
        ),
        repeatCount: json['repeatCount'] as int? ?? 1,
        playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? 1.0,
        delayBetweenAyahs: Duration(
          milliseconds: json['delayBetweenAyahsMs'] as int? ?? 0,
        ),
        autoAdvance: json['autoAdvance'] as bool? ?? true,
        autoScroll: json['autoScroll'] as bool? ?? true,
      );

  @override
  List<Object?> get props => [
        repeatPolicy,
        repeatCount,
        playbackSpeed,
        delayBetweenAyahs,
        autoAdvance,
        autoScroll,
      ];
}
