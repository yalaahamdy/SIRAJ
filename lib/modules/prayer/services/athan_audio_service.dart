import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/errors/result.dart';
import '../../../core/logging/app_logger.dart';
import '../domain/athan_sound_option.dart';

/// Abstract audio player adapter for Athan engine (§32).
abstract class AthanAudioPlayerAdapter {
  Future<void> playAsset(String assetPath);
  Future<void> stop();
  Future<void> setVolume(double volume);
  Future<void> dispose();
  Stream<bool> get isPlayingStream;
  Stream<Duration> get positionStream;
  Stream<Duration> get durationStream;
}

/// Production implementation using audioplayers package with reliable byte-streaming & context setup.
class ProductionAthanAudioPlayerAdapter implements AthanAudioPlayerAdapter {
  final AudioPlayer _player;

  ProductionAthanAudioPlayerAdapter([AudioPlayer? player]) : _player = player ?? AudioPlayer() {
    _initAudioContext();
    _player.setReleaseMode(ReleaseMode.stop);
  }

  void _initAudioContext() {
    try {
      _player.setAudioContext(
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
  Future<void> playAsset(String assetPath) async {
    await _player.stop();

    final fullAssetPath = assetPath.startsWith('assets/')
        ? assetPath
        : 'assets/$assetPath';
    final cleanPath = assetPath.startsWith('assets/')
        ? assetPath.substring('assets/'.length)
        : assetPath;

    try {
      final byteData = await rootBundle.load(fullAssetPath);
      await _player.play(BytesSource(byteData.buffer.asUint8List()));
    } catch (_) {
      await _player.play(AssetSource(cleanPath));
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }

  @override
  Stream<bool> get isPlayingStream => _player.onPlayerStateChanged.map((s) => s == PlayerState.playing);

  @override
  Stream<Duration> get positionStream => _player.onPositionChanged;

  @override
  Stream<Duration> get durationStream => _player.onDurationChanged;
}

/// Mock adapter for deterministic unit and widget tests.
class MockAthanAudioPlayerAdapter implements AthanAudioPlayerAdapter {
  bool _isPlaying = false;
  bool get isCurrentlyPlaying => _isPlaying;
  final _playingController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  @override
  Future<void> playAsset(String assetPath) async {
    _isPlaying = true;
    _playingController.add(true);
    _positionController.add(Duration.zero);
    _durationController.add(const Duration(minutes: 3, seconds: 15));
  }

  @override
  Future<void> stop() async {
    _isPlaying = false;
    _playingController.add(false);
    _positionController.add(Duration.zero);
  }

  @override
  Future<void> setVolume(double volume) async {}

  @override
  Future<void> dispose() async {
    await stop();
    await _playingController.close();
    await _positionController.close();
    await _durationController.close();
  }

  @override
  Stream<bool> get isPlayingStream => _playingController.stream;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<Duration> get durationStream => _durationController.stream;
}

/// Service responsible for on-device Athan audio playback, preview, and volume control (§32).
class AthanAudioService {
  final AthanAudioPlayerAdapter _adapter;
  final AppLogger? _logger;

  bool _isPlaying = false;
  AthanSoundOption? _currentOption;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  StreamSubscription? _playingSub;
  StreamSubscription? _posSub;
  StreamSubscription? _durSub;

  final _playerStateController = StreamController<bool>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();

  AthanAudioService({
    AthanAudioPlayerAdapter? adapter,
    AppLogger? logger,
  })  : _adapter = adapter ?? MockAthanAudioPlayerAdapter(),
        _logger = logger {
    _initListeners();
  }

  /// Convenience factory for production runtime.
  factory AthanAudioService.production({AppLogger? logger}) {
    return AthanAudioService(
      adapter: ProductionAthanAudioPlayerAdapter(),
      logger: logger,
    );
  }

  bool get isPlaying => _isPlaying;
  AthanSoundOption? get currentOption => _currentOption;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;

  Stream<bool> get isPlayingStream => _playerStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;

  void _initListeners() {
    _playingSub = _adapter.isPlayingStream.listen((playing) {
      _isPlaying = playing;
      _playerStateController.add(playing);
      if (!playing) {
        _currentOption = null;
        _currentPosition = Duration.zero;
      }
    });

    _posSub = _adapter.positionStream.listen((pos) {
      _currentPosition = pos;
      _positionController.add(pos);
    });

    _durSub = _adapter.durationStream.listen((dur) {
      _totalDuration = dur;
    });
  }

  /// Plays the selected Athan sound asset.
  Future<Result<void, Failure>> playAthan({
    required AthanSoundOption soundOption,
    double volume = 0.85,
  }) async {
    try {
      _logger?.info('Starting Athan playback: ${soundOption.displayNameArabic} at volume $volume');
      await stopAthan();

      _currentOption = soundOption;
      await _adapter.setVolume(volume.clamp(0.0, 1.0));
      await _adapter.playAsset(soundOption.assetPath);

      _isPlaying = true;
      _playerStateController.add(true);
      return Result.ok(null);
    } catch (e, st) {
      _logger?.error('Failed to play Athan audio', error: e, stackTrace: st);
      _isPlaying = false;
      _playerStateController.add(false);
      return Result.err(
        SystemFailure(message: 'فشل تشغيل صوت الأذان: ${e.toString()}'),
      );
    }
  }

  /// Plays a short preview of the Athan.
  Future<Result<void, Failure>> previewAthan({
    required AthanSoundOption soundOption,
    double volume = 0.85,
  }) async {
    return playAthan(soundOption: soundOption, volume: volume);
  }

  /// Stops any currently active Athan playback.
  Future<Result<void, Failure>> stopAthan() async {
    try {
      await _adapter.stop();
      _isPlaying = false;
      _currentOption = null;
      _currentPosition = Duration.zero;
      _playerStateController.add(false);
      return Result.ok(null);
    } catch (e) {
      return Result.err(SystemFailure(message: 'فشل إيقاف مشغل الأذان: $e'));
    }
  }

  /// Sets audio playback volume (0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    await _adapter.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Disposes audio player and stream controllers.
  Future<void> dispose() async {
    await stopAthan();
    await _playingSub?.cancel();
    await _posSub?.cancel();
    await _durSub?.cancel();
    await _adapter.dispose();
    await _playerStateController.close();
    await _positionController.close();
  }
}
