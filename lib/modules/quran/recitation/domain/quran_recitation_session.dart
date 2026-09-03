import 'package:equatable/equatable.dart';
import 'recitation_playback_policy.dart';

/// Status of an active or concluded recitation session.
enum RecitationSessionStatus {
  inProgress,
  completed,
  cancelled,
  interrupted,
}

/// Represents a single recitation session (§7, §13).
/// Strict design invariant: Contains NO religious scores, piety scores, or spiritual rankings.
class QuranRecitationSession extends Equatable {
  final String sessionId;
  final int surahNumber;
  final String surahNameArabic;
  final int startAyah;
  final int endAyah;
  final RecitationMode mode;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? audioPath;
  final int totalWords;
  final int recognizedWordsCount;
  final int revealedWordsCount;
  final int uncertainWordsCount;
  final Duration duration;
  final RecitationSessionStatus status;

  const QuranRecitationSession({
    required this.sessionId,
    required this.surahNumber,
    required this.surahNameArabic,
    required this.startAyah,
    required this.endAyah,
    required this.mode,
    required this.startedAt,
    this.endedAt,
    this.audioPath,
    required this.totalWords,
    this.recognizedWordsCount = 0,
    this.revealedWordsCount = 0,
    this.uncertainWordsCount = 0,
    this.duration = Duration.zero,
    this.status = RecitationSessionStatus.inProgress,
  });

  QuranRecitationSession copyWith({
    DateTime? endedAt,
    String? audioPath,
    int? totalWords,
    int? recognizedWordsCount,
    int? revealedWordsCount,
    int? uncertainWordsCount,
    Duration? duration,
    RecitationSessionStatus? status,
  }) {
    return QuranRecitationSession(
      sessionId: sessionId,
      surahNumber: surahNumber,
      surahNameArabic: surahNameArabic,
      startAyah: startAyah,
      endAyah: endAyah,
      mode: mode,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      audioPath: audioPath ?? this.audioPath,
      totalWords: totalWords ?? this.totalWords,
      recognizedWordsCount: recognizedWordsCount ?? this.recognizedWordsCount,
      revealedWordsCount: revealedWordsCount ?? this.revealedWordsCount,
      uncertainWordsCount: uncertainWordsCount ?? this.uncertainWordsCount,
      duration: duration ?? this.duration,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'surahNumber': surahNumber,
        'surahNameArabic': surahNameArabic,
        'startAyah': startAyah,
        'endAyah': endAyah,
        'mode': mode.name,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'audioPath': audioPath,
        'totalWords': totalWords,
        'recognizedWordsCount': recognizedWordsCount,
        'revealedWordsCount': revealedWordsCount,
        'uncertainWordsCount': uncertainWordsCount,
        'durationMs': duration.inMilliseconds,
        'status': status.name,
      };

  factory QuranRecitationSession.fromJson(Map<String, dynamic> json) =>
      QuranRecitationSession(
        sessionId: json['sessionId'] as String,
        surahNumber: json['surahNumber'] as int,
        surahNameArabic: json['surahNameArabic'] as String? ?? '',
        startAyah: json['startAyah'] as int,
        endAyah: json['endAyah'] as int,
        mode: RecitationMode.values.firstWhere(
          (m) => m.name == json['mode'],
          orElse: () => RecitationMode.recordAndReplay,
        ),
        startedAt: DateTime.parse(json['startedAt'] as String),
        endedAt: json['endedAt'] != null
            ? DateTime.parse(json['endedAt'] as String)
            : null,
        audioPath: json['audioPath'] as String?,
        totalWords: json['totalWords'] as int? ?? 0,
        recognizedWordsCount: json['recognizedWordsCount'] as int? ?? 0,
        revealedWordsCount: json['revealedWordsCount'] as int? ?? 0,
        uncertainWordsCount: json['uncertainWordsCount'] as int? ?? 0,
        duration: Duration(milliseconds: json['durationMs'] as int? ?? 0),
        status: RecitationSessionStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => RecitationSessionStatus.completed,
        ),
      );

  @override
  List<Object?> get props => [
        sessionId,
        surahNumber,
        surahNameArabic,
        startAyah,
        endAyah,
        mode,
        startedAt,
        endedAt,
        audioPath,
        totalWords,
        recognizedWordsCount,
        revealedWordsCount,
        uncertainWordsCount,
        duration,
        status,
      ];
}
