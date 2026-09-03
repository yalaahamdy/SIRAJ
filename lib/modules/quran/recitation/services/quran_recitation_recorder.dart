import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Adapter interface abstracting microphone audio recording (§18).
abstract class AudioRecorderAdapter {
  Future<bool> hasPermission();
  Future<bool> isRecording();
  Future<void> start({required String path});
  Future<String?> stop();
  Future<void> pause();
  Future<void> resume();
  void dispose();
}

/// Real production recorder using official record package.
class ProductionAudioRecorderAdapter implements AudioRecorderAdapter {
  final AudioRecorder _recorder;

  ProductionAudioRecorderAdapter({AudioRecorder? recorder})
      : _recorder = recorder ?? AudioRecorder();

  @override
  Future<bool> hasPermission() async {
    return _recorder.hasPermission();
  }

  @override
  Future<bool> isRecording() async {
    return _recorder.isRecording();
  }

  @override
  Future<void> start({required String path}) async {
    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
    );
    await _recorder.start(config, path: path);
  }

  @override
  Future<String?> stop() async {
    return _recorder.stop();
  }

  @override
  Future<void> pause() async {
    await _recorder.pause();
  }

  @override
  Future<void> resume() async {
    await _recorder.resume();
  }

  @override
  void dispose() {
    _recorder.dispose();
  }
}

/// Safe mock audio recorder for fast unit testing and headless CI.
class MockAudioRecorderAdapter implements AudioRecorderAdapter {
  bool permissionGranted;
  bool _isRecording = false;
  bool _isPaused = false;
  String? _lastPath;

  bool get isPaused => _isPaused;

  MockAudioRecorderAdapter({this.permissionGranted = true});

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<bool> isRecording() async => _isRecording;

  @override
  Future<void> start({required String path}) async {
    if (!permissionGranted) {
      throw StateError('Microphone permission denied');
    }
    _isRecording = true;
    _isPaused = false;
    _lastPath = path;

    // Create an empty dummy file if testing filesystem interactions
    try {
      final file = File(path);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
        file.writeAsStringSync('MOCK_AUDIO_PAYLOAD');
      }
    } catch (_) {}
  }

  @override
  Future<String?> stop() async {
    _isRecording = false;
    _isPaused = false;
    return _lastPath;
  }

  @override
  Future<void> pause() async {
    _isPaused = true;
  }

  @override
  Future<void> resume() async {
    _isPaused = false;
  }

  @override
  void dispose() {
    _isRecording = false;
  }
}

/// Service managing recitation recording files, storage quotas, and permissions (§17, §18).
class QuranRecitationRecorder {
  final AudioRecorderAdapter _adapter;
  final Directory? _customDirectory;

  static const int maxRetainedRecordings = 20;

  QuranRecitationRecorder({
    AudioRecorderAdapter? adapter,
    Directory? customDirectory,
  })  : _adapter = adapter ?? ProductionAudioRecorderAdapter(),
        _customDirectory = customDirectory;

  Future<bool> checkPermission() => _adapter.hasPermission();

  Future<bool> isRecording() => _adapter.isRecording();

  /// Resolves the dedicated local directory for recitation audio files.
  Future<Directory> getRecordingsDirectory() async {
    if (_customDirectory != null) {
      if (!_customDirectory.existsSync()) {
        _customDirectory.createSync(recursive: true);
      }
      return _customDirectory;
    }

    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'siraj_recitations'));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Begins recording a recitation session for the given surah and verse range.
  Future<String> startRecording({
    required int surahNumber,
    required int startAyah,
    required int endAyah,
  }) async {
    final hasPerm = await _adapter.hasPermission();
    if (!hasPerm) {
      throw StateError('إذن استخدام الميكروفون غير ممنوح. يرجى تفعيله من الإعدادات.');
    }

    // Clean up older recordings to maintain storage quota (§18)
    await _enforceStorageQuota();

    final dir = await getRecordingsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'rec_${surahNumber}_${startAyah}_${endAyah}_$timestamp.m4a';
    final fullPath = p.join(dir.path, fileName);

    await _adapter.start(path: fullPath);
    return fullPath;
  }

  /// Stops current recording and returns the saved file path.
  Future<String?> stopRecording() async {
    return _adapter.stop();
  }

  Future<void> pauseRecording() => _adapter.pause();

  Future<void> resumeRecording() => _adapter.resume();

  /// Deletes a specific recording file locally (§18).
  Future<bool> deleteRecording(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return false;
    try {
      final f = File(filePath);
      if (f.existsSync()) {
        f.deleteSync();
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Deletes the oldest recordings if count exceeds [maxRetainedRecordings].
  Future<void> _enforceStorageQuota() async {
    try {
      final dir = await getRecordingsDirectory();
      final entities = dir.listSync().whereType<File>().toList();
      if (entities.length >= maxRetainedRecordings) {
        entities.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
        final excess = entities.length - maxRetainedRecordings + 1;
        for (var i = 0; i < excess; i++) {
          entities[i].deleteSync();
        }
      }
    } catch (_) {}
  }

  void dispose() {
    _adapter.dispose();
  }
}
