import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Preset amplification levels for the audio booster.
enum AudioBoostPreset {
  normal(1.0, '100%', 'افتراضي'),
  mild(1.25, '125%', '+4 ديسيبل'),
  medium(1.5, '150%', '+8 ديسيبل'),
  high(1.75, '175%', '+12 ديسيبل'),
  max(2.0, '200%', 'تضخيم فائق +16 ديسيبل');

  final double multiplier;
  final String label;
  final String description;

  const AudioBoostPreset(this.multiplier, this.label, this.description);

  static AudioBoostPreset fromMultiplier(double m) {
    if (m >= 1.9) return AudioBoostPreset.max;
    if (m >= 1.65) return AudioBoostPreset.high;
    if (m >= 1.4) return AudioBoostPreset.medium;
    if (m >= 1.15) return AudioBoostPreset.mild;
    return AudioBoostPreset.normal;
  }
}

/// Service managing hardware/software audio amplification up to 200% (§14, §20, §32).
/// Interfaces with Android's native LoudnessEnhancer AudioEffect to safely amplify quiet recordings
/// without distortion, serving historic Tawasheeh, Cairo Quran Radio, Sheikh Sharawy's lessons, and Quran recitation.
class SirajAudioBoostService extends ChangeNotifier {
  static final SirajAudioBoostService instance = SirajAudioBoostService();

  static const MethodChannel _channel = MethodChannel('com.siraj.app/audio_booster');

  double _boostLevel = 1.0;
  bool _isSupported = true;
  bool _isDeNoiseEnabled = true;

  double get boostLevel => _boostLevel;
  bool get isBoosted => _boostLevel > 1.0;
  bool get isSupported => _isSupported;
  bool get isDeNoiseEnabled => _isDeNoiseEnabled;
  AudioBoostPreset get currentPreset => AudioBoostPreset.fromMultiplier(_boostLevel);
  int get gainMilliBels => ((_boostLevel - 1.0) * 1600).toInt().clamp(0, 2000);
  List<double> get presetLevels => AudioBoostPreset.values.map((p) => p.multiplier).toList();

  SirajAudioBoostService() {
    _init();
  }

  Future<void> _init() async {
    if (kIsWeb || !Platform.isAndroid) {
      _isSupported = false;
      return;
    }
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        _isSupported = true;
        return;
      }
    } catch (_) {}

    try {
      final supported = await _channel.invokeMethod<bool>('isSupported');
      _isSupported = supported ?? true;
    } catch (_) {
      _isSupported = false;
    }
  }

  /// Sets audio amplification level (1.0 = 100%, up to 2.0 = 200%).
  Future<void> setBoostLevel(double level) async {
    final clamped = level.clamp(1.0, 2.0);
    _boostLevel = clamped;
    notifyListeners();

    if (kIsWeb || !Platform.isAndroid) return;
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      await _channel.invokeMethod('setBoostLevel', {
        'level': clamped,
        'deNoise': _isDeNoiseEnabled,
      });
    } catch (e) {
      debugPrint('Error applying native audio boost: $e');
    }
  }

  /// Sets whether vocal de-noise notch filter is active.
  Future<void> setDeNoise(bool enabled) async {
    _isDeNoiseEnabled = enabled;
    notifyListeners();

    if (kIsWeb || !Platform.isAndroid) return;
    try {
      if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    } catch (_) {}

    try {
      await _channel.invokeMethod('setDeNoise', {'enabled': enabled});
    } catch (e) {
      debugPrint('Error toggling native de-noise: $e');
    }
  }

  /// Toggles vocal de-noising on/off.
  Future<void> toggleDeNoise() => setDeNoise(!_isDeNoiseEnabled);

  /// Sets boost by preset.
  Future<void> setPreset(AudioBoostPreset preset) => setBoostLevel(preset.multiplier);

  /// Cycles to next boost level for quick one-tap boosting.
  Future<void> cycleNext() async {
    switch (currentPreset) {
      case AudioBoostPreset.normal:
        await setPreset(AudioBoostPreset.mild);
        break;
      case AudioBoostPreset.mild:
        await setPreset(AudioBoostPreset.medium);
        break;
      case AudioBoostPreset.medium:
        await setPreset(AudioBoostPreset.high);
        break;
      case AudioBoostPreset.high:
        await setPreset(AudioBoostPreset.max);
        break;
      case AudioBoostPreset.max:
        await setPreset(AudioBoostPreset.normal);
        break;
    }
  }

  /// Resets audio boost to normal (100%).
  Future<void> reset() => setBoostLevel(1.0);
}
