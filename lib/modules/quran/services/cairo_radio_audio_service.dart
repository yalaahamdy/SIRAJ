import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../domain/cairo_radio_station.dart';

/// Abstract adapter for radio stream audio player to allow 100% testability.
abstract class RadioAudioPlayerAdapter {
  Future<void> playUrl(String url);
  Future<void> pause();
  Future<void> stop();
  Future<void> setVolume(double volume);
  Future<void> dispose();
  Stream<PlayerState> get onPlayerStateChanged;
}

/// Safe mock radio player adapter for unit tests and headless environments.
class MockRadioPlayerAdapter implements RadioAudioPlayerAdapter {
  final List<String> playedUrls = [];
  final List<double> setVolumes = [];
  bool isPaused = false;
  bool isStopped = false;
  bool isDisposed = false;
  bool shouldThrowOnFirstUrl = false;

  final StreamController<PlayerState> _playerStateController =
      StreamController<PlayerState>.broadcast();

  @override
  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;

  @override
  Future<void> playUrl(String url) async {
    if (shouldThrowOnFirstUrl && playedUrls.isEmpty) {
      playedUrls.add(url);
      throw Exception('Simulated network connection failure on primary URL');
    }
    playedUrls.add(url);
    isPaused = false;
    isStopped = false;
    _playerStateController.add(PlayerState.playing);
  }

  @override
  Future<void> pause() async {
    isPaused = true;
    _playerStateController.add(PlayerState.paused);
  }

  @override
  Future<void> stop() async {
    isStopped = true;
    _playerStateController.add(PlayerState.stopped);
  }

  @override
  Future<void> setVolume(double volume) async {
    setVolumes.add(volume);
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await _playerStateController.close();
  }
}

/// Production player adapter wrapping audioplayers AudioPlayer with fail-soft safety.
class ProductionRadioPlayerAdapter implements RadioAudioPlayerAdapter {
  AudioPlayer? _player;
  final StreamController<PlayerState> _fallbackController =
      StreamController<PlayerState>.broadcast();

  ProductionRadioPlayerAdapter([AudioPlayer? player]) {
    try {
      _player = player ?? AudioPlayer();
      _initAudioContext();
    } catch (_) {
      _player = null;
    }
  }

  void _initAudioContext() {
    if (_player == null) return;
    try {
      _player!.setReleaseMode(ReleaseMode.stop);
      _player!.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
        ),
      );
    } catch (_) {}
  }

  @override
  Future<void> playUrl(String url) async {
    if (_player != null) {
      await _player!.stop();
      await _player!.play(UrlSource(url));
    } else {
      _fallbackController.add(PlayerState.playing);
    }
  }

  @override
  Future<void> pause() async {
    if (_player != null) {
      await _player!.pause();
    } else {
      _fallbackController.add(PlayerState.paused);
    }
  }

  @override
  Future<void> stop() async {
    if (_player != null) {
      await _player!.stop();
    } else {
      _fallbackController.add(PlayerState.stopped);
    }
  }

  @override
  Future<void> setVolume(double volume) async {
    if (_player != null) {
      await _player!.setVolume(volume);
    }
  }

  @override
  Future<void> dispose() async {
    if (_player != null) {
      await _player!.dispose();
    }
    await _fallbackController.close();
  }

  @override
  Stream<PlayerState> get onPlayerStateChanged {
    if (_player != null) {
      return _player!.onPlayerStateChanged;
    }
    return _fallbackController.stream;
  }
}

/// Dedicated live radio service orchestrating Cairo Quran Radio streaming (§14, §20).
class CairoRadioAudioService {
  static CairoRadioAudioService? _instance;

  final RadioAudioPlayerAdapter _player;
  final CairoRadioStation station;

  CairoRadioStatus _status = CairoRadioStatus.idle;
  int _activeUrlIndex = 0;
  double _volume = 0.85;
  double _previousVolume = 0.85;
  bool _isMuted = false;
  String? _errorMessage;

  // Sleep Timer state
  Timer? _sleepCountdownTimer;
  Duration? _sleepTimerRemaining;
  RadioSleepTimerDuration _activeSleepDuration = RadioSleepTimerDuration.none;

  // Broadcasters
  final _statusController = StreamController<CairoRadioStatus>.broadcast();
  final _sleepTimerController = StreamController<Duration?>.broadcast();
  StreamSubscription<PlayerState>? _playerStateSub;

  /// External callback triggered when radio starts, used to halt Quran ayah recitation.
  void Function()? onPlaybackStarted;

  CairoRadioAudioService({
    RadioAudioPlayerAdapter? player,
    CairoRadioStation? radioStation,
  })  : _player = player ?? MockRadioPlayerAdapter(),
        station = radioStation ?? CairoRadioStation.cairoQuranRadio {
    _initSubscription();
  }

  /// Global singleton instance.
  static CairoRadioAudioService get instance {
    _instance ??= CairoRadioAudioService();
    return _instance!;
  }

  /// Setter for testing/mocking.
  static void setMockInstance(CairoRadioAudioService mock) {
    _instance = mock;
  }

  void _initSubscription() {
    _playerStateSub = _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing && _status != CairoRadioStatus.playing) {
        _setStatus(CairoRadioStatus.playing);
      } else if (state == PlayerState.paused && _status != CairoRadioStatus.paused) {
        _setStatus(CairoRadioStatus.paused);
      } else if (state == PlayerState.stopped && _status != CairoRadioStatus.idle) {
        _setStatus(CairoRadioStatus.idle);
      }
    });
  }

  // --- Getters ---
  CairoRadioStatus get status => _status;
  Stream<CairoRadioStatus> get statusStream => _statusController.stream;
  Stream<Duration?> get sleepTimerStream => _sleepTimerController.stream;
  double get volume => _volume;
  bool get isMuted => _isMuted;
  bool get isPlaying => _status == CairoRadioStatus.playing;
  bool get isConnecting => _status == CairoRadioStatus.connecting;
  String? get errorMessage => _errorMessage;
  RadioSleepTimerDuration get activeSleepDuration => _activeSleepDuration;
  Duration? get sleepTimerRemaining => _sleepTimerRemaining;

  List<String> get _allUrls => [
        station.primaryStreamUrl,
        ...station.backupStreamUrls,
      ];

  String get currentActiveUrl => _allUrls[_activeUrlIndex.clamp(0, _allUrls.length - 1)];

  void _setStatus(CairoRadioStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
  }

  /// Starts or resumes the live radio stream with automatic fallback on connection error.
  Future<void> play() async {
    if (_status == CairoRadioStatus.paused) {
      try {
        await _player.playUrl(currentActiveUrl);
        _setStatus(CairoRadioStatus.playing);
        onPlaybackStarted?.call();
        return;
      } catch (_) {
        // Fallback to full reconnect
      }
    }

    _errorMessage = null;
    _setStatus(CairoRadioStatus.connecting);
    onPlaybackStarted?.call();

    await _attemptStreamPlayback();
  }

  Future<void> _attemptStreamPlayback() async {
    final targetUrl = currentActiveUrl;

    try {
      await _player.setVolume(_isMuted ? 0.0 : _volume);
      await _player.playUrl(targetUrl);
      _setStatus(CairoRadioStatus.playing);
    } catch (e) {
      // If primary URL failed, try next backup URL
      if (_activeUrlIndex + 1 < _allUrls.length) {
        _activeUrlIndex++;
        // Retry immediately with the next backup stream
        await _attemptStreamPlayback();
      } else {
        // All stream URLs failed
        _errorMessage = 'تعذر الاتصال بالبث المباشر. يرجى التحقق من اتصال الإنترنت.';
        _setStatus(CairoRadioStatus.error);
      }
    }
  }

  /// Pauses the live stream.
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (_) {}
    _setStatus(CairoRadioStatus.paused);
  }

  /// Completely stops the live radio stream and resets fallback index.
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
    _setStatus(CairoRadioStatus.idle);
    _activeUrlIndex = 0;
  }

  /// Retries connecting starting again from primary stream URL.
  Future<void> retry() async {
    _activeUrlIndex = 0;
    _errorMessage = null;
    await play();
  }

  /// Sets audio volume between 0.0 and 1.0.
  Future<void> setVolume(double newVol) async {
    _volume = newVol.clamp(0.0, 1.0);
    if (_isMuted) {
      _isMuted = false;
    }
    await _player.setVolume(_volume);
  }

  /// Toggles mute state.
  Future<void> toggleMute() async {
    if (_isMuted) {
      _isMuted = false;
      _volume = _previousVolume > 0.0 ? _previousVolume : 0.85;
      await _player.setVolume(_volume);
    } else {
      _previousVolume = _volume;
      _isMuted = true;
      _volume = 0.0;
      await _player.setVolume(0.0);
    }
  }

  // --- Sleep Timer Engine ---

  /// Configures and starts an automated sleep timer.
  void setSleepTimer(RadioSleepTimerDuration duration) {
    cancelSleepTimer();
    _activeSleepDuration = duration;

    if (duration == RadioSleepTimerDuration.none) {
      _sleepTimerRemaining = null;
      _sleepTimerController.add(null);
      return;
    }

    _sleepTimerRemaining = Duration(minutes: duration.minutes);
    _sleepTimerController.add(_sleepTimerRemaining);

    _sleepCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sleepTimerRemaining == null || _sleepTimerRemaining!.inSeconds <= 1) {
        // Timer completed -> stop live stream gracefully
        cancelSleepTimer();
        stop();
      } else {
        _sleepTimerRemaining = _sleepTimerRemaining! - const Duration(seconds: 1);
        _sleepTimerController.add(_sleepTimerRemaining);
      }
    });
  }

  /// Cancels any active sleep timer.
  void cancelSleepTimer() {
    _sleepCountdownTimer?.cancel();
    _sleepCountdownTimer = null;
    _sleepTimerRemaining = null;
    _activeSleepDuration = RadioSleepTimerDuration.none;
    _sleepTimerController.add(null);
  }

  Future<void> dispose() async {
    cancelSleepTimer();
    _playerStateSub?.cancel();
    await _player.dispose();
    await _statusController.close();
    await _sleepTimerController.close();
  }
}
