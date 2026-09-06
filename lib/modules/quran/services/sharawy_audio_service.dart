import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../../../core/notifications/siraj_media_notification_service.dart';
import '../domain/cairo_radio_station.dart';
import '../domain/sharawy_item.dart';
import 'cairo_radio_audio_service.dart';

/// Playback status of Sheikh El-Sharawy Khawatir audio engine.
enum SharawyAudioStatus {
  idle,
  connecting,
  playing,
  paused,
  error,
}

/// Comprehensive, robust audio service for playing Sheikh Mohamed Metwally El-Sharawy's
/// Tafsir Khawatir archive with background notification controls and absolute sleep timer (§14, §20, §32).
class SharawyAudioService {
  final RadioAudioPlayerAdapter _player;

  SharawyAudioStatus _status = SharawyAudioStatus.idle;
  SharawyItem? _currentItem;
  List<SharawyItem> _playlist = [];
  int _currentIndex = -1;

  double _volume = 0.85;
  double _playbackRate = 1.0;
  bool _isMuted = false;
  bool _autoPlayNext = true;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Absolute Wall-Clock Sleep Timer State
  RadioSleepTimerDuration _activeSleepDuration = RadioSleepTimerDuration.none;
  DateTime? _sleepTargetTime;
  Duration? _sleepTimerRemaining;
  Timer? _sleepTicker;
  VoidCallback? onSleepTimerCompleted;
  VoidCallback? onPlaybackStarted;

  final StreamController<SharawyAudioStatus> _statusController =
      StreamController<SharawyAudioStatus>.broadcast();
  final StreamController<SharawyItem?> _itemController =
      StreamController<SharawyItem?>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration?> _sleepTimerController =
      StreamController<Duration?>.broadcast();

  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration>? _durationSub;

  SharawyAudioService({RadioAudioPlayerAdapter? player})
      : _player = player ??
            (_isTestEnvironment()
                ? MockRadioPlayerAdapter()
                : ProductionRadioPlayerAdapter()) {
    _init();
  }

  static bool _isTestEnvironment() {
    try {
      return Platform.environment.containsKey('FLUTTER_TEST');
    } catch (_) {
      return false;
    }
  }

  // Getters
  SharawyAudioStatus get status => _status;
  SharawyItem? get currentItem => _currentItem;
  List<SharawyItem> get playlist => List.unmodifiable(_playlist);
  int get currentIndex => _currentIndex;
  double get volume => _volume;
  double get playbackRate => _playbackRate;
  bool get isMuted => _isMuted;
  bool get autoPlayNext => _autoPlayNext;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  RadioSleepTimerDuration get activeSleepDuration => _activeSleepDuration;
  DateTime? get sleepTargetTime => _sleepTargetTime;
  Duration? get sleepTimerRemaining => _sleepTimerRemaining;

  Stream<SharawyAudioStatus> get statusStream => _statusController.stream;
  Stream<SharawyItem?> get currentItemStream => _itemController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<Duration?> get sleepTimerStream => _sleepTimerController.stream;

  DateTime? _lastNotificationProgressTime;

  void _init() {
    _playerStateSub = _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        _status = SharawyAudioStatus.playing;
        _statusController.add(_status);
        _updateMediaNotification(isPlaying: true);
      } else if (state == PlayerState.paused) {
        _status = SharawyAudioStatus.paused;
        _statusController.add(_status);
        _updateMediaNotification(isPlaying: false);
      } else if (state == PlayerState.completed) {
        _handlePlaybackCompleted();
      } else if (state == PlayerState.stopped) {
        _status = SharawyAudioStatus.idle;
        _statusController.add(_status);
        SirajMediaNotificationService.instance.cancelMediaNotification();
      }
    });

    _positionSub = _player.onPositionChanged.listen((pos) {
      _currentPosition = pos;
      _positionController.add(pos);
      if (_status == SharawyAudioStatus.playing) {
        final now = DateTime.now();
        if (_lastNotificationProgressTime == null ||
            now.difference(_lastNotificationProgressTime!).inSeconds >= 5) {
          _lastNotificationProgressTime = now;
          _updateMediaNotification(isPlaying: true);
        }
      }
    });

    _durationSub = _player.onDurationChanged.listen((dur) {
      _totalDuration = dur;
      _durationController.add(dur);
    });

    _attachMediaNotificationHandlers();
  }

  void _attachMediaNotificationHandlers() {
    SirajMediaNotificationService.instance.registerDelegate(
      SirajMediaType.sharawyKhawatir,
      _SharawyMediaNotificationDelegate(this),
    );
  }

  void setPlaylist(List<SharawyItem> items) {
    _playlist = List.from(items);
    if (_currentItem != null) {
      _currentIndex = _playlist.indexWhere((it) => it.id == _currentItem!.id);
    }
  }

  void setAutoPlayNext(bool value) {
    _autoPlayNext = value;
  }

  /// Plays a specific Sharawy Khawatir item.
  Future<void> playItem(SharawyItem item, {List<SharawyItem>? playlist}) async {
    if (playlist != null) {
      _playlist = List.from(playlist);
    }
    _currentIndex = _playlist.indexWhere((it) => it.id == item.id);
    _currentItem = item;
    _itemController.add(item);

    onPlaybackStarted?.call();

    _status = SharawyAudioStatus.connecting;
    _statusController.add(_status);
    _currentPosition = Duration.zero;
    _totalDuration = Duration(seconds: item.durationSeconds.toInt());
    _positionController.add(_currentPosition);
    _durationController.add(_totalDuration);

    final playUrl = (item.localFilePath != null && item.localFilePath!.isNotEmpty)
        ? item.localFilePath!
        : item.url;

    try {
      await _player.stop();
      await _player.setPlaybackRate(_playbackRate);
      await _player.playUrl(playUrl);
      _status = SharawyAudioStatus.playing;
      _statusController.add(_status);
      _updateMediaNotification(isPlaying: true);
    } catch (_) {
      _status = SharawyAudioStatus.error;
      _statusController.add(_status);
    }
  }

  Future<void> resume() async {
    if (_currentItem == null) return;
    if (_status == SharawyAudioStatus.paused) {
      onPlaybackStarted?.call();
      try {
        await _player.resume();
        if (_currentPosition > Duration.zero) {
          await _player.seek(_currentPosition);
        }
        _status = SharawyAudioStatus.playing;
        _statusController.add(_status);
        _updateMediaNotification(isPlaying: true);
      } catch (_) {
        _status = SharawyAudioStatus.error;
        _statusController.add(_status);
      }
    } else {
      await playItem(_currentItem!);
    }
  }

  Future<void> pause() async {
    if (_status == SharawyAudioStatus.playing) {
      await _player.pause();
      _status = SharawyAudioStatus.paused;
      _statusController.add(_status);
      _updateMediaNotification(isPlaying: false);
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _status = SharawyAudioStatus.idle;
    _statusController.add(_status);
    SirajMediaNotificationService.instance.cancelMediaNotification();
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
    _currentPosition = position;
    _positionController.add(position);
  }

  Future<void> skipForward([Duration offset = const Duration(seconds: 10)]) async {
    var target = _currentPosition + offset;
    if (target > _totalDuration && _totalDuration > Duration.zero) {
      target = _totalDuration;
    }
    await seek(target);
  }

  Future<void> skipBackward([Duration offset = const Duration(seconds: 10)]) async {
    var target = _currentPosition - offset;
    if (target < Duration.zero) {
      target = Duration.zero;
    }
    await seek(target);
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    if (_currentIndex + 1 < _playlist.length) {
      await playItem(_playlist[_currentIndex + 1]);
    } else if (_playlist.isNotEmpty) {
      // Loop back to first item
      await playItem(_playlist.first);
    }
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    if (_currentPosition.inSeconds > 5) {
      // Replay current item if already played for > 5s
      await seek(Duration.zero);
      return;
    }
    if (_currentIndex - 1 >= 0) {
      await playItem(_playlist[_currentIndex - 1]);
    } else {
      await playItem(_playlist.last);
    }
  }

  void _handlePlaybackCompleted() {
    if (_autoPlayNext && _playlist.isNotEmpty && _currentIndex + 1 < _playlist.length) {
      playNext();
    } else {
      _status = SharawyAudioStatus.idle;
      _statusController.add(_status);
      SirajMediaNotificationService.instance.cancelMediaNotification();
    }
  }

  Future<void> setPlaybackRate(double rate) async {
    _playbackRate = rate;
    await _player.setPlaybackRate(rate);
  }

  Future<void> setVolume(double vol) async {
    _volume = vol.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _player.setVolume(_volume);
    }
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _player.setVolume(_isMuted ? 0.0 : _volume);
  }

  // --- Absolute Sleep Timer Engine (§14, §20) ---

  void setSleepTimer(RadioSleepTimerDuration duration) {
    _activeSleepDuration = duration;
    _sleepTicker?.cancel();

    if (duration == RadioSleepTimerDuration.none) {
      _sleepTargetTime = null;
      _sleepTimerRemaining = null;
      _sleepTimerController.add(null);
      return;
    }

    final Duration dur = duration.duration;
    _sleepTargetTime = DateTime.now().add(dur);
    _sleepTimerRemaining = dur;
    _sleepTimerController.add(_sleepTimerRemaining);

    _sleepTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkSleepTimer();
    });
  }

  void setCustomSleepTimer(Duration duration) {
    _activeSleepDuration = RadioSleepTimerDuration.custom;
    _sleepTicker?.cancel();

    if (duration <= Duration.zero) {
      _sleepTargetTime = null;
      _sleepTimerRemaining = null;
      _sleepTimerController.add(null);
      return;
    }

    _sleepTargetTime = DateTime.now().add(duration);
    _sleepTimerRemaining = duration;
    _sleepTimerController.add(_sleepTimerRemaining);

    _sleepTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      checkSleepTimer();
    });
  }

  Future<void> checkSleepTimer() async {
    if (_sleepTargetTime == null) return;

    final now = DateTime.now();
    final remaining = _sleepTargetTime!.difference(now);

    if (remaining.isNegative || remaining == Duration.zero) {
      await forceSleepStop();
    } else {
      _sleepTimerRemaining = remaining;
      _sleepTimerController.add(remaining);
    }
  }

  Future<void> forceSleepStop() async {
    _sleepTicker?.cancel();
    _sleepTicker = null;
    _sleepTargetTime = null;
    _sleepTimerRemaining = null;
    _activeSleepDuration = RadioSleepTimerDuration.none;
    _sleepTimerController.add(null);

    await _player.setVolume(0.0);
    await _player.stop();
    _status = SharawyAudioStatus.idle;
    _statusController.add(_status);
    SirajMediaNotificationService.instance.cancelMediaNotification();

    onSleepTimerCompleted?.call();
  }

  void cancelSleepTimer() {
    setSleepTimer(RadioSleepTimerDuration.none);
  }

  void _updateMediaNotification({required bool isPlaying}) {
    if (_currentItem == null) return;
    SirajMediaNotificationService.instance.showMediaNotification(
      title: _currentItem!.cleanTitle,
      subtitle: 'الشيخ محمد متولي الشعراوي • خواطر التفسير',
      isPlaying: isPlaying,
      type: SirajMediaType.sharawyKhawatir,
      hasNext: _playlist.isNotEmpty,
      hasPrevious: _playlist.isNotEmpty,
      position: _currentPosition,
      duration: _totalDuration,
    );
  }

  Future<void> dispose() async {
    SirajMediaNotificationService.instance.unregisterDelegate(SirajMediaType.sharawyKhawatir);
    _sleepTicker?.cancel();
    await _playerStateSub?.cancel();
    await _positionSub?.cancel();
    await _durationSub?.cancel();
    await _player.dispose();
    await _statusController.close();
    await _itemController.close();
    await _positionController.close();
    await _durationController.close();
    await _sleepTimerController.close();
  }
}

/// Notification delegate handling transport controls specifically for Sheikh El-Sharawy Khawatir.
class _SharawyMediaNotificationDelegate implements SirajMediaNotificationDelegate {
  final SharawyAudioService service;
  _SharawyMediaNotificationDelegate(this.service);

  @override
  void onPlayPause() {
    if (service.status == SharawyAudioStatus.playing) {
      service.pause();
    } else if (service.status == SharawyAudioStatus.paused) {
      service.resume();
    }
  }

  @override
  void onNext() => service.playNext();

  @override
  void onPrevious() => service.playPrevious();

  @override
  void onSkipForward() => service.skipForward(const Duration(seconds: 10));

  @override
  void onSkipBackward() => service.skipBackward(const Duration(seconds: 10));

  @override
  void onStop() => service.stop();
}
