import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'quran_audio_service.dart';

/// Real production audio player adapter using audioplayers plugin (§14, §15).
class FlutterAudioPlayerAdapter implements AudioPlayerAdapter {
  final AudioPlayer _player;
  VoidCallback? onComplete;
  StreamSubscription? _completeSubscription;

  FlutterAudioPlayerAdapter({AudioPlayer? player, this.onComplete})
      : _player = player ?? AudioPlayer() {
    _initAudioContext();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      onComplete?.call();
    });
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
  Future<bool> checkFileExists(String pathOrUrl) async {
    if (pathOrUrl.startsWith('assets/')) {
      try {
        await rootBundle.load(pathOrUrl);
        return true;
      } catch (_) {
        return false;
      }
    }

    if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      final uri = Uri.tryParse(pathOrUrl);
      return uri != null && uri.hasScheme && uri.host.isNotEmpty;
    }

    try {
      final f = File(pathOrUrl);
      return f.existsSync();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> play(String pathOrUrl) async {
    await _player.stop();

    if (pathOrUrl.startsWith('assets/')) {
      try {
        final byteData = await rootBundle.load(pathOrUrl);
        await _player.play(BytesSource(byteData.buffer.asUint8List()));
      } catch (_) {
        final assetPath = pathOrUrl.replaceFirst('assets/', '');
        await _player.play(AssetSource(assetPath));
      }
    } else if (pathOrUrl.startsWith('http://') || pathOrUrl.startsWith('https://')) {
      await _player.play(UrlSource(pathOrUrl));
    } else {
      await _player.play(DeviceFileSource(pathOrUrl));
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> resume() async {
    await _player.resume();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }

  @override
  Future<void> setPlaybackRate(double rate) async {
    try {
      await _player.setPlaybackRate(rate);
    } catch (_) {}
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    _player.dispose();
  }
}
