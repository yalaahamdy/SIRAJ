import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'quran_audio_service.dart';

/// Real production audio player adapter with automatic local caching (§14, §15).
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

  static Future<File?> _getCachedAudioFile(String url) async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final uri = Uri.parse(url);
      final cleanName = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.join('_')
          : 'audio_${url.hashCode}.mp3';
      final cacheDir = Directory('${docDir.path}${Platform.pathSeparator}siraj_audio_cache');
      if (!cacheDir.existsSync()) {
        cacheDir.createSync(recursive: true);
      }
      return File('${cacheDir.path}${Platform.pathSeparator}$cleanName');
    } catch (_) {
      return null;
    }
  }

  static void _cacheAudioInBackground(String url, File? targetFile) async {
    if (targetFile == null || targetFile.existsSync()) return;
    try {
      final client = HttpClient();
      final req = await client.getUrl(Uri.parse(url));
      final res = await req.close();
      if (res.statusCode == 200) {
        final bytes = await res.fold<List<int>>([], (prev, elem) => prev..addAll(elem));
        if (bytes.isNotEmpty) {
          final tmp = File('${targetFile.path}.tmp');
          await tmp.writeAsBytes(bytes, flush: true);
          if (targetFile.existsSync()) targetFile.deleteSync();
          await tmp.rename(targetFile.path);
        }
      }
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
      final cached = await _getCachedAudioFile(pathOrUrl);
      if (cached != null && cached.existsSync() && cached.lengthSync() > 1024) {
        return true;
      }
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
      final cachedFile = await _getCachedAudioFile(pathOrUrl);
      if (cachedFile != null && cachedFile.existsSync() && cachedFile.lengthSync() > 1024) {
        await _player.play(DeviceFileSource(cachedFile.path));
      } else {
        await _player.play(UrlSource(pathOrUrl));
        _cacheAudioInBackground(pathOrUrl, cachedFile);
      }
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
