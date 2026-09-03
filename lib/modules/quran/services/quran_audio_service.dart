import 'dart:async';
import 'package:equatable/equatable.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../domain/quran_reciter.dart';
import '../store/canonical_quran_store.dart';

/// State of the Quran recitation audio engine (§14).
enum AudioPlaybackStatus {
  idle,
  playing,
  paused,
  stopped,
  buffering,
  missingAudio,
  error,
}

/// Supported repetition modes for Quranic memorization and recitation review (§14).
enum AudioRepeatMode {
  none,
  singleAyah,
  range,
  surah,
}

/// Snapshot report of the audio playback engine.
class AudioPlaybackReport extends Equatable {
  final AudioPlaybackStatus status;
  final int? surahNumber;
  final int? ayahNumber;
  final String reciterName;
  final QuranReciter? reciter;
  final double playbackSpeed;
  final String? statusMessageArabic;
  final Duration position;
  final Duration duration;
  final AudioRepeatMode repeatMode;
  final int repeatCount;
  final int currentIteration;
  final int? rangeStart;
  final int? rangeEnd;

  const AudioPlaybackReport({
    required this.status,
    this.surahNumber,
    this.ayahNumber,
    this.reciterName = 'الشيخ عبد الباسط عبد الصمد',
    this.reciter,
    this.playbackSpeed = 1.0,
    this.statusMessageArabic,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.repeatMode = AudioRepeatMode.none,
    this.repeatCount = 1,
    this.currentIteration = 1,
    this.rangeStart,
    this.rangeEnd,
  });

  AudioPlaybackReport copyWith({
    AudioPlaybackStatus? status,
    int? surahNumber,
    int? ayahNumber,
    String? reciterName,
    QuranReciter? reciter,
    double? playbackSpeed,
    String? statusMessageArabic,
    Duration? position,
    Duration? duration,
    AudioRepeatMode? repeatMode,
    int? repeatCount,
    int currentIteration = 1,
    int? rangeStart,
    int? rangeEnd,
  }) {
    return AudioPlaybackReport(
      status: status ?? this.status,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      reciterName: reciterName ?? this.reciterName,
      reciter: reciter ?? this.reciter,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      statusMessageArabic: statusMessageArabic ?? this.statusMessageArabic,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      repeatMode: repeatMode ?? this.repeatMode,
      repeatCount: repeatCount ?? this.repeatCount,
      currentIteration: currentIteration,
      rangeStart: rangeStart ?? this.rangeStart,
      rangeEnd: rangeEnd ?? this.rangeEnd,
    );
  }

  @override
  List<Object?> get props => [
        status,
        surahNumber,
        ayahNumber,
        reciterName,
        reciter,
        playbackSpeed,
        statusMessageArabic,
        position,
        duration,
        repeatMode,
        repeatCount,
        currentIteration,
        rangeStart,
        rangeEnd,
      ];
}

/// Abstract audio player adapter enabling testing and platform decoupling.
abstract class AudioPlayerAdapter {
  Future<bool> checkFileExists(String pathOrUrl);
  Future<void> play(String pathOrUrl);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> setPlaybackRate(double rate);
  void dispose();
}

/// In-memory safe audio player adapter for offline and test environments.
class MockAudioPlayerAdapter implements AudioPlayerAdapter {
  bool simulateMissingAudio;
  bool isPlaying = false;
  bool isPaused = false;
  double playbackRate = 1.0;

  MockAudioPlayerAdapter({this.simulateMissingAudio = false});

  @override
  Future<bool> checkFileExists(String pathOrUrl) async {
    return !simulateMissingAudio;
  }

  @override
  Future<void> play(String pathOrUrl) async {
    if (simulateMissingAudio) throw Exception('Audio file missing');
    isPlaying = true;
    isPaused = false;
  }

  @override
  Future<void> pause() async {
    isPaused = true;
    isPlaying = false;
  }

  @override
  Future<void> resume() async {
    isPlaying = true;
    isPaused = false;
  }

  @override
  Future<void> stop() async {
    isPlaying = false;
    isPaused = false;
  }

  @override
  Future<void> setPlaybackRate(double rate) async {
    playbackRate = rate;
  }

  @override
  void dispose() {}
}

/// Professional Quran recitation service supporting auto-scroll, range playback, and memorization repeat (§14).
class QuranAudioService {
  final ReadOnlyCanonicalQuranStore _store;
  final AudioPlayerAdapter _player;

  final StreamController<AudioPlaybackReport> _reportController =
      StreamController<AudioPlaybackReport>.broadcast();

  AudioPlaybackReport _currentReport = const AudioPlaybackReport(
    status: AudioPlaybackStatus.idle,
  );

  AudioRepeatMode _activeRepeatMode = AudioRepeatMode.none;
  int _targetRepeatCount = 1;
  int _currentIteration = 1;
  int? _rangeStart;
  int? _rangeEnd;

  QuranReciter _activeReciter = kDefaultAbdulBasitReciter;
  double _playbackSpeed = 1.0;

  QuranAudioService({
    required ReadOnlyCanonicalQuranStore store,
    AudioPlayerAdapter? player,
    QuranReciter? defaultReciter,
  })  : _store = store,
        _player = player ?? MockAudioPlayerAdapter(),
        _activeReciter = defaultReciter ?? kDefaultAbdulBasitReciter;

  AudioPlaybackReport get currentReport => _currentReport;
  Stream<AudioPlaybackReport> get reportStream => _reportController.stream;
  QuranReciter get activeReciter => _activeReciter;
  double get playbackSpeed => _playbackSpeed;

  void _emit(AudioPlaybackReport report) {
    _currentReport = report;
    if (!_reportController.isClosed) {
      _reportController.add(report);
    }
  }

  /// Sets the active Quran reciter.
  void setReciter(QuranReciter reciter) {
    _activeReciter = reciter;
    _emit(_currentReport.copyWith(
      reciterName: reciter.nameArabic,
      reciter: reciter,
    ));
  }

  /// Sets playback speed/rate (e.g. 0.75, 1.0, 1.25, 1.5, 2.0).
  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _player.setPlaybackRate(speed);
    _emit(_currentReport.copyWith(playbackSpeed: speed));
  }

  /// Sets repeat parameters for memorization drills.
  void configureRepeat({
    required AudioRepeatMode mode,
    int repeatCount = 1,
  }) {
    _activeRepeatMode = mode;
    _targetRepeatCount = repeatCount;
    _currentIteration = 1;
  }

  /// Plays a specific Ayah by Surah and Ayah number.
  Future<Result<bool, Failure>> playAyah(int surahNumber, int ayahNumber) async {
    final ayahRes = _store.getAyah(surahNumber, ayahNumber);
    if (ayahRes.isFailure) {
      _emit(
        AudioPlaybackReport(
          status: AudioPlaybackStatus.error,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          reciterName: _activeReciter.nameArabic,
          reciter: _activeReciter,
          playbackSpeed: _playbackSpeed,
          statusMessageArabic: 'الآية غير موجودة في المصحف: $surahNumber:$ayahNumber',
        ),
      );
      return Result.err(ayahRes.failureOrNull!);
    }

    final candidateUris = _activeReciter.resolveCandidateUris(surahNumber, ayahNumber);
    String resolvedUri = '';
    for (final uri in candidateUris) {
      if (await _player.checkFileExists(uri)) {
        resolvedUri = uri;
        break;
      }
    }

    if (resolvedUri.isEmpty) {
      _emit(
        AudioPlaybackReport(
          status: AudioPlaybackStatus.missingAudio,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          reciterName: _activeReciter.nameArabic,
          reciter: _activeReciter,
          playbackSpeed: _playbackSpeed,
          statusMessageArabic: 'الملف الصوتي للآية غير متوفر حالياً',
          repeatMode: _activeRepeatMode,
          repeatCount: _targetRepeatCount,
          currentIteration: _currentIteration,
          rangeStart: _rangeStart,
          rangeEnd: _rangeEnd,
        ),
      );
      return Result.err(
        const ContentNotFoundFailure(
          message: 'الملف الصوتي للآية غير متوفر حالياً',
          code: 'AUDIO_NOT_FOUND',
        ),
      );
    }

    try {
      await _player.play(resolvedUri);
      if (_playbackSpeed != 1.0) {
        await _player.setPlaybackRate(_playbackSpeed);
      }
      _emit(
        AudioPlaybackReport(
          status: AudioPlaybackStatus.playing,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          reciterName: _activeReciter.nameArabic,
          reciter: _activeReciter,
          playbackSpeed: _playbackSpeed,
          statusMessageArabic: 'جارٍ الاستماع: سورة $surahNumber آية $ayahNumber (${_activeReciter.nameArabic})',
          repeatMode: _activeRepeatMode,
          repeatCount: _targetRepeatCount,
          currentIteration: _currentIteration,
          rangeStart: _rangeStart,
          rangeEnd: _rangeEnd,
        ),
      );
      return Result.ok(true);
    } catch (e) {
      _emit(
        AudioPlaybackReport(
          status: AudioPlaybackStatus.error,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          reciterName: _activeReciter.nameArabic,
          reciter: _activeReciter,
          playbackSpeed: _playbackSpeed,
          statusMessageArabic: 'خطأ في تشغيل الصوت: $e',
        ),
      );
      return Result.err(
        SystemFailure(message: 'خطأ في تشغيل الصوت: $e', code: 'AUDIO_PLAY_ERROR'),
      );
    }
  }

  /// Initiates full sequential playback of an entire Surah starting from a given verse.
  Future<Result<bool, Failure>> playSurah(int surahNumber, {int startAyah = 1}) async {
    _activeRepeatMode = AudioRepeatMode.surah;
    _rangeStart = null;
    _rangeEnd = null;
    return playAyah(surahNumber, startAyah);
  }

  /// Initiates sequential playback of a specified verse range with repeat support (§14).
  Future<Result<bool, Failure>> playRange(
    int surahNumber,
    int startAyah,
    int endAyah, {
    int repeatCount = 1,
  }) async {
    _activeRepeatMode = AudioRepeatMode.range;
    _rangeStart = startAyah <= endAyah ? startAyah : endAyah;
    _rangeEnd = startAyah <= endAyah ? endAyah : startAyah;
    _targetRepeatCount = repeatCount;
    _currentIteration = 1;

    return playAyah(surahNumber, _rangeStart!);
  }

  /// Pauses active playback.
  Future<void> pause() async {
    if (_currentReport.status == AudioPlaybackStatus.playing) {
      await _player.pause();
      _emit(
        AudioPlaybackReport(
          status: AudioPlaybackStatus.paused,
          surahNumber: _currentReport.surahNumber,
          ayahNumber: _currentReport.ayahNumber,
          statusMessageArabic: 'التلاوة متوقفة مؤقتاً',
          repeatMode: _activeRepeatMode,
          repeatCount: _targetRepeatCount,
          currentIteration: _currentIteration,
          rangeStart: _rangeStart,
          rangeEnd: _rangeEnd,
        ),
      );
    }
  }

  /// Resumes paused playback.
  Future<void> resume() async {
    if (_currentReport.status == AudioPlaybackStatus.paused &&
        _currentReport.surahNumber != null &&
        _currentReport.ayahNumber != null) {
      await _player.resume();
      _emit(
        AudioPlaybackReport(
          status: AudioPlaybackStatus.playing,
          surahNumber: _currentReport.surahNumber,
          ayahNumber: _currentReport.ayahNumber,
          statusMessageArabic: 'جارٍ الاستماع',
          repeatMode: _activeRepeatMode,
          repeatCount: _targetRepeatCount,
          currentIteration: _currentIteration,
          rangeStart: _rangeStart,
          rangeEnd: _rangeEnd,
        ),
      );
    }
  }

  /// Stops playback completely.
  Future<void> stop() async {
    await _player.stop();
    _activeRepeatMode = AudioRepeatMode.none;
    _rangeStart = null;
    _rangeEnd = null;
    _emit(
      const AudioPlaybackReport(
        status: AudioPlaybackStatus.stopped,
        statusMessageArabic: 'تم إيقاف التلاوة',
      ),
    );
  }

  /// Transitions to the next Ayah, respecting active repeat and range parameters.
  Future<Result<bool, Failure>> nextAyah() async {
    final currentS = _currentReport.surahNumber;
    final currentA = _currentReport.ayahNumber;
    if (currentS == null || currentA == null) {
      return playAyah(1, 1);
    }

    // Range playback boundary check
    if (_activeRepeatMode == AudioRepeatMode.range && _rangeEnd != null) {
      if (currentA < _rangeEnd!) {
        return playAyah(currentS, currentA + 1);
      } else {
        // Reached end of range: check repeat iteration
        if (_currentIteration < _targetRepeatCount) {
          _currentIteration++;
          return playAyah(currentS, _rangeStart ?? 1);
        } else {
          await stop();
          return Result.ok(false);
        }
      }
    }

    // Single Ayah repeat check
    if (_activeRepeatMode == AudioRepeatMode.singleAyah) {
      if (_currentIteration < _targetRepeatCount) {
        _currentIteration++;
        return playAyah(currentS, currentA);
      }
    }

    // Standard sequential progression
    final surahRes = _store.getSurah(currentS);
    if (surahRes.isSuccess && currentA < surahRes.valueOrNull!.ayahCount) {
      return playAyah(currentS, currentA + 1);
    } else if (currentS < 114) {
      return playAyah(currentS + 1, 1);
    } else {
      await stop();
      return Result.ok(false);
    }
  }

  /// Transitions to the previous Ayah.
  Future<Result<bool, Failure>> previousAyah() async {
    final currentS = _currentReport.surahNumber;
    final currentA = _currentReport.ayahNumber;
    if (currentS == null || currentA == null) return Result.ok(false);

    if (_activeRepeatMode == AudioRepeatMode.range && _rangeStart != null) {
      if (currentA > _rangeStart!) {
        return playAyah(currentS, currentA - 1);
      }
      return Result.ok(false);
    }

    if (currentA > 1) {
      return playAyah(currentS, currentA - 1);
    } else if (currentS > 1) {
      final prevSurahRes = _store.getSurah(currentS - 1);
      if (prevSurahRes.isSuccess) {
        return playAyah(currentS - 1, prevSurahRes.valueOrNull!.ayahCount);
      }
    }
    return Result.ok(false);
  }


  void dispose() {
    _player.dispose();
    _reportController.close();
  }
}
