import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../storage/storage_contract.dart';

/// Sound effect asset paths for SIRAJ.
class SirajAudioEffects {
  static const String effectsPrefix = 'assets/audio/effects/';

  static const String tap = '${effectsPrefix}tap_click.wav';
  static const String tasbih = '${effectsPrefix}tasbih_click.wav';
  static const String completion = '${effectsPrefix}tasbih_complete.wav';
  static const String pageFlip = '${effectsPrefix}page_flip.wav';
  static const String bookmark = '${effectsPrefix}bookmark_set.wav';
  static const String recitationSuccess = '${effectsPrefix}recitation_success.wav';
}

/// Abstract adapter for low-latency feedback sound playback.
abstract class FeedbackAudioPlayerAdapter {
  Future<void> playAsset(String assetPath, {double volume = 1.0});
  Future<void> stop();
  Future<void> dispose();
}

/// Production implementation using audioplayers in lowLatency mode.
class ProductionFeedbackAudioPlayerAdapter implements FeedbackAudioPlayerAdapter {
  final AudioPlayer _player;
  bool _initialized = false;

  ProductionFeedbackAudioPlayerAdapter([AudioPlayer? player])
      : _player = player ?? AudioPlayer() {
    _init();
  }

  void _init() {
    try {
      _player.setReleaseMode(ReleaseMode.stop);
      _player.setPlayerMode(PlayerMode.lowLatency);
      _player.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.assistanceSonification,
            audioFocus: AndroidAudioFocus.none,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.ambient,
            options: const {
              AVAudioSessionOptions.mixWithOthers,
            },
          ),
        ),
      );
      _initialized = true;
    } catch (_) {}
  }

  @override
  Future<void> playAsset(String assetPath, {double volume = 1.0}) async {
    try {
      if (!_initialized) {
        _init();
      }
      await _player.setVolume(volume.clamp(0.0, 1.0));
      await _player.stop();

      final fullAssetPath = assetPath.startsWith('assets/')
          ? assetPath
          : 'assets/$assetPath';
      final cleanPath = assetPath.startsWith('assets/')
          ? assetPath.substring('assets/'.length)
          : assetPath;

      try {
        final byteData = await rootBundle.load(fullAssetPath);
        await _player.play(
          BytesSource(byteData.buffer.asUint8List()),
          mode: PlayerMode.lowLatency,
        );
      } catch (_) {
        await _player.play(
          AssetSource(cleanPath),
          mode: PlayerMode.lowLatency,
        );
      }
    } catch (_) {
      // Gracefully catch platform audio exceptions on test/headless environments
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}
  }

  @override
  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (_) {}
  }
}

/// Central service controlling tactile & feedback audio effects across SIRAJ.
class SirajFeedbackAudioService {
  static const String _storageKey = 'siraj_enable_sound_effects';
  static SirajFeedbackAudioService? _instance;

  final FeedbackAudioPlayerAdapter _player;
  KeyValueStore? _store;
  bool _isEnabled = true;
  double _volume = 0.85;

  /// Optional checker predicate to prevent sound effects when Quran is reciting.
  bool Function()? isQuranPlaying;

  SirajFeedbackAudioService({
    FeedbackAudioPlayerAdapter? player,
    StorageRegistry? storageRegistry,
    bool isEnabled = true,
  })  : _player = player ?? ProductionFeedbackAudioPlayerAdapter(),
        _isEnabled = isEnabled {
    if (storageRegistry != null) {
      initStorage(storageRegistry);
    }
  }

  /// Global singleton instance.
  static SirajFeedbackAudioService get instance {
    _instance ??= SirajFeedbackAudioService();
    return _instance!;
  }

  /// Sets or resets the singleton instance (useful for unit testing).
  static void setMockInstance(SirajFeedbackAudioService mock) {
    _instance = mock;
  }

  bool get isEnabled => _isEnabled;
  double get volume => _volume;

  /// Initializes persistence using storage registry.
  Future<void> initStorage(StorageRegistry storageRegistry) async {
    _store = storageRegistry.getStoreForModule('mod_system_settings');
    if (_store != null) {
      try {
        final res = await _store!.getBool(_storageKey);
        if (res.isSuccess && res.valueOrNull != null) {
          _isEnabled = res.valueOrNull!;
        }
      } catch (_) {}
    }
  }

  /// Toggles sound effects on or off and persists user preference.
  Future<void> setSoundEnabled(bool enabled) async {
    if (_isEnabled == enabled) return;
    _isEnabled = enabled;
    if (_store != null) {
      try {
        await _store!.setBool(_storageKey, enabled);
      } catch (_) {}
    }
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
  }

  /// Generic playback method with safety and Quran-playback checks.
  Future<void> playEffect(String assetPath, {double? customVolume}) async {
    if (!_isEnabled) return;
    if (isQuranPlaying != null && isQuranPlaying!()) {
      // Do not play effects while Quran recitation is active
      return;
    }
    await _player.playAsset(assetPath, volume: customVolume ?? _volume);
  }

  // --- Specific Domain Audio Triggers ---

  /// Soft UI click for button taps and tab switches.
  Future<void> playTap() => playEffect(SirajAudioEffects.tap, customVolume: 0.6);

  /// Wooden Misbaha bead clack for Adhkar & Tasbih counter.
  Future<void> playTasbih() => playEffect(SirajAudioEffects.tasbih, customVolume: 0.9);

  /// Uplifting gentle chime when completing a target Dhikr count.
  Future<void> playCompletion() => playEffect(SirajAudioEffects.completion, customVolume: 0.85);

  /// Subtle paper rustle when turning a Mushaf page.
  Future<void> playPageFlip() => playEffect(SirajAudioEffects.pageFlip, customVolume: 0.7);

  /// Gentle notification chime when setting or removing an Ayah bookmark.
  Future<void> playBookmark() => playEffect(SirajAudioEffects.bookmark, customVolume: 0.75);

  /// Uplifting melodic chime on successful recitation or session finish.
  Future<void> playSuccess() => playEffect(SirajAudioEffects.recitationSuccess, customVolume: 0.85);

  Future<void> dispose() async {
    await _player.dispose();
  }
}
