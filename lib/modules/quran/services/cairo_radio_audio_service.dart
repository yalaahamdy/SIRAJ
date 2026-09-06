import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import '../domain/cairo_radio_station.dart';
import '../domain/tawasheeh_item.dart';
import 'tawasheeh_offline_audio_service.dart';

/// Abstract adapter for radio stream audio player to allow 100% testability.
abstract class RadioAudioPlayerAdapter {
  Future<void> playUrl(String url);
  Future<void> pause();
  Future<void> stop();
  Future<void> setVolume(double volume);
  Future<void> seek(Duration position);
  Future<void> setPlaybackRate(double rate);
  Future<void> dispose();
  Stream<PlayerState> get onPlayerStateChanged;
  Stream<Duration> get onPositionChanged;
  Stream<Duration> get onDurationChanged;
}

/// Safe mock radio player adapter for unit tests and headless environments.
class MockRadioPlayerAdapter implements RadioAudioPlayerAdapter {
  final List<String> playedUrls = [];
  final List<double> setVolumes = [];
  double playbackRate = 1.0;
  bool isPaused = false;
  bool isStopped = false;
  bool isDisposed = false;
  bool shouldThrowOnFirstUrl = false;

  final StreamController<PlayerState> _playerStateController =
      StreamController<PlayerState>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();

  @override
  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;

  @override
  Stream<Duration> get onPositionChanged => _positionController.stream;

  @override
  Stream<Duration> get onDurationChanged => _durationController.stream;

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
  Future<void> seek(Duration position) async {
    _positionController.add(position);
  }

  @override
  Future<void> setPlaybackRate(double rate) async {
    playbackRate = rate;
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await _playerStateController.close();
    await _positionController.close();
    await _durationController.close();
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
      if (url.startsWith('http://') || url.startsWith('https://')) {
        await _player!.play(UrlSource(url));
      } else {
        await _player!.play(DeviceFileSource(url));
      }
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
  Future<void> seek(Duration position) async {
    if (_player != null) {
      await _player!.seek(position);
    }
  }

  @override
  Future<void> setPlaybackRate(double rate) async {
    if (_player != null) {
      await _player!.setPlaybackRate(rate);
    }
  }

  @override
  Stream<PlayerState> get onPlayerStateChanged {
    if (_player != null) {
      return _player!.onPlayerStateChanged;
    }
    return _fallbackController.stream;
  }

  @override
  Stream<Duration> get onPositionChanged =>
      _player?.onPositionChanged ?? const Stream.empty();

  @override
  Stream<Duration> get onDurationChanged =>
      _player?.onDurationChanged ?? const Stream.empty();
}

/// Operating mode of the Cairo Quran Radio audio engine (§14, §20).
enum CairoRadioMode {
  liveRadio,
  tawasheeh,
}

/// Dedicated live radio service orchestrating Cairo Quran Radio streaming and Tawasheeh playback (§14, §20).
class CairoRadioAudioService {
  static CairoRadioAudioService? _instance;

  final RadioAudioPlayerAdapter _player;
  final CairoRadioStation station;

  CairoRadioMode _mode = CairoRadioMode.liveRadio;
  TawasheehItem? _currentTawasheeh;
  List<TawasheehItem> _tawasheehPlaylist = [];
  int _currentTawasheehIndex = 0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isShuffle = false;
  bool _isRepeat = false;

  CairoRadioStatus _status = CairoRadioStatus.idle;
  int _activeUrlIndex = 0;
  double _volume = 0.85;
  double _previousVolume = 0.85;
  bool _isMuted = false;
  String? _errorMessage;

  // Sleep Timer state
  Timer? _sleepCountdownTimer;
  Duration? _sleepTimerRemaining;
  DateTime? _sleepTargetTime;
  RadioSleepTimerDuration _activeSleepDuration = RadioSleepTimerDuration.none;

  /// Callback fired when sleep timer reaches zero and initiates shutdown.
  void Function()? onSleepTimerCompleted;

  // Broadcasters
  final _statusController = StreamController<CairoRadioStatus>.broadcast();
  final _sleepTimerController = StreamController<Duration?>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();
  final _modeController = StreamController<CairoRadioMode>.broadcast();
  final _tawasheehController = StreamController<TawasheehItem?>.broadcast();

  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<Duration>? _durSub;

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
      } else if (state == PlayerState.completed) {
        if (_mode == CairoRadioMode.tawasheeh) {
          if (_isRepeat && _currentTawasheeh != null) {
            playTawasheeh(_currentTawasheeh!);
          } else {
            nextTawasheeh();
          }
        }
      }
    });

    _posSub = _player.onPositionChanged.listen((pos) {
      _currentPosition = pos;
      _positionController.add(pos);
    });

    _durSub = _player.onDurationChanged.listen((dur) {
      if (dur > Duration.zero) {
        _totalDuration = dur;
        _durationController.add(dur);
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
  DateTime? get sleepTargetTime => _sleepTargetTime;

  CairoRadioMode get mode => _mode;
  Stream<CairoRadioMode> get modeStream => _modeController.stream;
  TawasheehItem? get currentTawasheeh => _currentTawasheeh;
  Stream<TawasheehItem?> get currentTawasheehStream => _tawasheehController.stream;
  List<TawasheehItem> get tawasheehPlaylist => List.unmodifiable(_tawasheehPlaylist);
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;

  List<String> get _allUrls => [
        station.primaryStreamUrl,
        ...station.backupStreamUrls,
      ];

  String get currentActiveUrl => _allUrls[_activeUrlIndex.clamp(0, _allUrls.length - 1)];

  void _setStatus(CairoRadioStatus newStatus) {
    _status = newStatus;
    _statusController.add(_status);
  }

  /// Switches operating mode between Live Radio and Tawasheeh.
  void setMode(CairoRadioMode newMode) {
    if (_mode == newMode) return;
    _mode = newMode;
    _modeController.add(_mode);
  }

  /// Plays a specific Tawasheeh item, optionally setting the active playlist.
  Future<void> playTawasheeh(TawasheehItem item, {List<TawasheehItem>? playlist}) async {
    _mode = CairoRadioMode.tawasheeh;
    _modeController.add(_mode);
    _currentTawasheeh = item;
    _tawasheehController.add(item);

    if (playlist != null && playlist.isNotEmpty) {
      _tawasheehPlaylist = List.from(playlist);
      _currentTawasheehIndex = _tawasheehPlaylist.indexWhere((it) => it.id == item.id);
      if (_currentTawasheehIndex == -1) _currentTawasheehIndex = 0;
    }

    _currentPosition = Duration.zero;
    _totalDuration = Duration(seconds: item.durationSeconds.toInt());
    _positionController.add(_currentPosition);
    _durationController.add(_totalDuration);

    _errorMessage = null;
    _setStatus(CairoRadioStatus.connecting);
    onPlaybackStarted?.call();

    final localPath = await TawasheehOfflineAudioService.instance.getLocalFilePath(item);
    final audioSource = (localPath != null && localPath.isNotEmpty) ? localPath : item.url;

    try {
      await _player.setVolume(_isMuted ? 0.0 : _volume);
      await _player.playUrl(audioSource);
      _setStatus(CairoRadioStatus.playing);
    } catch (e) {
      _errorMessage = (localPath != null && localPath.isNotEmpty)
          ? 'تعذر تشغيل الملف الصوتي المحلي.'
          : 'تعذر تشغيل الابتهال، يرجى التحقق من اتصال الإنترنت.';
      _setStatus(CairoRadioStatus.error);
    }
  }

  /// Plays or resumes live Cairo radio stream.
  Future<void> playLiveRadio() async {
    _mode = CairoRadioMode.liveRadio;
    _modeController.add(_mode);
    await play();
  }

  /// Advances to the next Tawasheeh in playlist.
  Future<void> nextTawasheeh() async {
    if (_tawasheehPlaylist.isEmpty) return;
    if (_isShuffle) {
      final randIndex = (DateTime.now().millisecondsSinceEpoch % _tawasheehPlaylist.length);
      _currentTawasheehIndex = randIndex;
    } else {
      _currentTawasheehIndex = (_currentTawasheehIndex + 1) % _tawasheehPlaylist.length;
    }
    await playTawasheeh(_tawasheehPlaylist[_currentTawasheehIndex]);
  }

  /// Returns to the previous Tawasheeh in playlist.
  Future<void> previousTawasheeh() async {
    if (_tawasheehPlaylist.isEmpty) return;
    _currentTawasheehIndex =
        (_currentTawasheehIndex - 1 + _tawasheehPlaylist.length) % _tawasheehPlaylist.length;
    await playTawasheeh(_tawasheehPlaylist[_currentTawasheehIndex]);
  }

  /// Seeks to a specific timestamp in the current audio track.
  Future<void> seek(Duration position) async {
    _currentPosition = position;
    _positionController.add(position);
    await _player.seek(position);
  }

  /// Toggles shuffle mode for Tawasheeh playback.
  void toggleShuffle() {
    _isShuffle = !_isShuffle;
  }

  /// Toggles single track repeat mode.
  void toggleRepeat() {
    _isRepeat = !_isRepeat;
  }

  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;

  /// Updates audio playback rate (e.g. 0.75x, 1.0x, 1.25x, 1.5x, 2.0x).
  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _player.setPlaybackRate(speed);
  }

  /// Starts or resumes audio playback depending on active mode.
  Future<void> play() async {
    if (_mode == CairoRadioMode.tawasheeh && _currentTawasheeh != null) {
      if (_status == CairoRadioStatus.paused) {
        try {
          await _player.playUrl(_currentTawasheeh!.url);
          _setStatus(CairoRadioStatus.playing);
          onPlaybackStarted?.call();
          return;
        } catch (_) {}
      }
      await playTawasheeh(_currentTawasheeh!);
      return;
    }

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

  /// Configures and starts an automated sleep timer based on standard preset intervals.
  void setSleepTimer(RadioSleepTimerDuration duration) {
    cancelSleepTimer();
    _activeSleepDuration = duration;

    if (duration == RadioSleepTimerDuration.none) {
      _sleepTimerRemaining = null;
      _sleepTargetTime = null;
      _sleepTimerController.add(null);
      return;
    }

    _startSleepTimerWithDuration(Duration(minutes: duration.minutes));
  }

  /// Configures and starts an automated sleep timer with an arbitrary duration (e.g. for testing).
  void setCustomSleepTimer(Duration duration, {RadioSleepTimerDuration preset = RadioSleepTimerDuration.fifteenMinutes}) {
    cancelSleepTimer();
    _activeSleepDuration = preset;
    _startSleepTimerWithDuration(duration);
  }

  void _startSleepTimerWithDuration(Duration duration) {
    _sleepTargetTime = DateTime.now().add(duration);
    _sleepTimerRemaining = duration;
    _sleepTimerController.add(_sleepTimerRemaining);

    _sleepCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkSleepTimerExpiry();
    });
  }

  /// Evaluates sleep timer against wall-clock time, resilient to OS Doze mode and screen locks.
  Future<void> checkSleepTimer() async {
    await _checkSleepTimerExpiry();
  }

  Future<void> _checkSleepTimerExpiry() async {
    if (_sleepTargetTime == null) {
      cancelSleepTimer();
      return;
    }

    final diff = _sleepTargetTime!.difference(DateTime.now());
    if (diff <= Duration.zero) {
      // Target time reached or passed -> authoritative immediate shutdown
      cancelSleepTimer();
      await forceSleepStop();
    } else {
      _sleepTimerRemaining = diff;
      _sleepTimerController.add(_sleepTimerRemaining);
    }
  }

  /// Performs an authoritative, hard shutdown of playback when sleep timer expires.
  Future<void> forceSleepStop() async {
    _setStatus(CairoRadioStatus.idle);
    _activeUrlIndex = 0;
    try {
      await _player.setVolume(0.0);
    } catch (_) {}
    try {
      await _player.pause();
    } catch (_) {}
    try {
      await _player.stop();
    } catch (_) {}
    onSleepTimerCompleted?.call();
  }

  /// Cancels any active sleep timer.
  void cancelSleepTimer() {
    _sleepCountdownTimer?.cancel();
    _sleepCountdownTimer = null;
    _sleepTimerRemaining = null;
    _sleepTargetTime = null;
    _activeSleepDuration = RadioSleepTimerDuration.none;
    _sleepTimerController.add(null);
  }

  Future<void> dispose() async {
    cancelSleepTimer();
    _playerStateSub?.cancel();
    _posSub?.cancel();
    _durSub?.cancel();
    await _player.dispose();
    await _statusController.close();
    await _sleepTimerController.close();
    await _positionController.close();
    await _durationController.close();
    await _modeController.close();
    await _tawasheehController.close();
  }
}
