import 'dart:async';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/sharawy_item.dart';
import '../store/sharawy_store.dart';

/// Result report for importing an offline Sheikh El-Sharawy ZIP archive or audio files.
class SharawyImportResult {
  final bool isSuccess;
  final int importedTracksCount;
  final int matchedExistingCount;
  final int totalBytes;
  final String? errorMessage;
  final String? targetDirectory;

  const SharawyImportResult({
    required this.isSuccess,
    this.importedTracksCount = 0,
    this.matchedExistingCount = 0,
    this.totalBytes = 0,
    this.errorMessage,
    this.targetDirectory,
  });
}

/// Service managing offline downloading, ZIP extraction, and local storage
/// for Sheikh Mohamed Metwally El-Sharawy's Tafsir Khawatir archive (§14, §20).
class SharawyOfflineAudioService {
  static SharawyOfflineAudioService? _instance;
  static SharawyOfflineAudioService get instance =>
      _instance ??= SharawyOfflineAudioService();

  static void setMockInstance(SharawyOfflineAudioService mock) {
    _instance = mock;
  }

  String? _baseStoragePath;
  bool _isInitialized = false;

  SharawyOfflineAudioService();

  /// Initializes the dedicated offline storage directory.
  Future<void> init({String? overrideBasePath}) async {
    if (overrideBasePath != null) {
      _baseStoragePath = overrideBasePath;
      _isInitialized = true;
      return;
    }

    if (_isInitialized && _baseStoragePath != null) return;

    try {
      final docDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory(
        '${docDir.path}${Platform.pathSeparator}siraj_sharawy_audio',
      );
      if (!audioDir.existsSync()) {
        await audioDir.create(recursive: true);
      }
      _baseStoragePath = audioDir.path;
      _isInitialized = true;
    } catch (_) {
      try {
        final tempDir = Directory(
          '${Directory.systemTemp.path}${Platform.pathSeparator}siraj_sharawy_audio',
        );
        if (!tempDir.existsSync()) {
          tempDir.createSync(recursive: true);
        }
        _baseStoragePath = tempDir.path;
        _isInitialized = true;
      } catch (_) {}
    }
  }

  String? get baseStoragePath => _baseStoragePath;

  /// Returns the local file path for a given Sharawy item if it exists on disk.
  Future<String?> getLocalFilePath(SharawyItem item) async {
    await init();
    if (_baseStoragePath == null) return null;

    if (item.localFilePath != null && item.localFilePath!.isNotEmpty) {
      final file = File(item.localFilePath!);
      if (file.existsSync() && file.lengthSync() > 1024) {
        return file.path;
      }
    }

    final idCandidate = File('$_baseStoragePath${Platform.pathSeparator}${item.id}.mp3');
    if (idCandidate.existsSync() && idCandidate.lengthSync() > 1024) {
      return idCandidate.path;
    }

    return null;
  }

  /// Downloads a Sharawy lesson from the archive to local storage with progress.
  Future<bool> downloadSharawyItem(
    SharawyItem item, {
    void Function(double progress)? onProgress,
    void Function(String error)? onError,
  }) async {
    await init();
    if (_baseStoragePath == null) {
      onError?.call('تعذر الوصول لمساحة التخزين المحلية');
      return false;
    }

    final targetFile = File('$_baseStoragePath${Platform.pathSeparator}${item.id}.mp3');
    if (targetFile.existsSync() && targetFile.lengthSync() > 1024) {
      onProgress?.call(1.0);
      return true;
    }

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 15);
      final request = await client.getUrl(Uri.parse(item.url));
      final response = await request.close();

      if (response.statusCode != 200 && response.statusCode != 302) {
        onError?.call('فشل التنزيل: رمز الاستجابة ${response.statusCode}');
        client.close();
        return false;
      }

      final contentLength = response.contentLength;
      var downloadedBytes = 0;
      final sink = targetFile.openWrite();

      await for (final chunk in response) {
        sink.add(chunk);
        downloadedBytes += chunk.length;
        if (contentLength > 0 && onProgress != null) {
          onProgress(downloadedBytes / contentLength);
        }
      }

      await sink.flush();
      await sink.close();
      client.close();

      onProgress?.call(1.0);
      return true;
    } catch (e) {
      if (targetFile.existsSync()) {
        try {
          await targetFile.delete();
        } catch (_) {}
      }
      onError?.call('حدث خطأ أثناء تنزيل المقطع: $e');
      return false;
    }
  }

  /// Imports Sheikh El-Sharawy lessons from a ZIP archive.
  Future<SharawyImportResult> importFromZip({
    String? explicitZipPath,
    SharawyStore? store,
    void Function(int current, int total, String fileName)? onProgress,
  }) async {
    await init();
    if (_baseStoragePath == null) {
      return const SharawyImportResult(
        isSuccess: false,
        errorMessage: 'تعذر الوصول لمجلد التخزين المحلي للخواطر',
      );
    }

    String? zipPath = explicitZipPath;
    if (zipPath == null) {
      try {
        final files = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['zip'],
          dialogTitle: 'اختر ملف ZIP يحتوي على خواطر الشيخ الشعراوي',
        );
        if (files.isEmpty || files.first.path == null) {
          return const SharawyImportResult(
            isSuccess: false,
            errorMessage: 'تم إلغاء اختيار ملف الـ ZIP',
          );
        }
        zipPath = files.first.path!;
      } catch (e) {
        return SharawyImportResult(
          isSuccess: false,
          errorMessage: 'فشل في فتح نافذة اختيار الملفات: $e',
        );
      }
    }

    final String finalZipPath = zipPath;
    final zipFile = File(finalZipPath);
    if (!zipFile.existsSync()) {
      return const SharawyImportResult(
        isSuccess: false,
        errorMessage: 'ملف الـ ZIP المحدد غير موجود',
      );
    }

    try {
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      var importedCount = 0;
      var matchedCount = 0;
      var totalExtractedBytes = 0;

      final totalFiles = archive.length;

      for (final file in archive) {
        if (!file.isFile) continue;
        final nameLower = file.name.toLowerCase();
        if (!nameLower.endsWith('.mp3') &&
            !nameLower.endsWith('.m4a') &&
            !nameLower.endsWith('.aac') &&
            !nameLower.endsWith('.wav')) {
          continue;
        }

        final rawFilename = file.name.split('/').last.split('\\').last;
        final cleanTitle = _cleanTrackTitle(rawFilename);

        final targetFile = File('$_baseStoragePath${Platform.pathSeparator}$rawFilename');
        final data = file.content as List<int>;
        await targetFile.writeAsBytes(data);
        totalExtractedBytes += data.length;
        importedCount++;
        onProgress?.call(importedCount, totalFiles, rawFilename);

        // Check if track matches existing catalog item by url or id
        SharawyItem? matchedItem;
        if (store != null) {
          for (final item in store.allItems) {
            if (!item.isCustomLocal &&
                (item.filename.toLowerCase() == rawFilename.toLowerCase() ||
                    item.cleanTitle == cleanTitle)) {
              matchedItem = item;
              break;
            }
          }
        }

        if (matchedItem != null) {
          store?.updateLocalPath(matchedItem.id, targetFile.path);
          matchedCount++;
        } else {
          final customId = 'sharawy_custom_${DateTime.now().millisecondsSinceEpoch}_$importedCount';
          final customItem = SharawyItem(
            id: customId,
            cleanTitle: cleanTitle,
            fullTitle: rawFilename,
            surahNumber: 0,
            surahName: 'التنزيلات',
            verseRange: '',
            scholar: 'الشيخ محمد متولي الشعراوي',
            duration: '--:--',
            durationSeconds: 0.0,
            url: '',
            filename: rawFilename,
            sizeBytes: data.length,
            localFilePath: targetFile.path,
            isCustomLocal: true,
          );
          store?.addCustomItem(customItem);
          importedCount++;
        }
      }

      onProgress?.call(totalFiles, totalFiles, 'اكتمل الاستيراد');
      return SharawyImportResult(
        isSuccess: true,
        importedTracksCount: importedCount,
        matchedExistingCount: matchedCount,
        totalBytes: totalExtractedBytes,
        targetDirectory: _baseStoragePath,
      );
    } catch (e) {
      return SharawyImportResult(
        isSuccess: false,
        errorMessage: 'حدث خطأ أثناء فك ضغط الأرشيف: $e',
      );
    }
  }

  /// Calculates total size of downloaded Sharawy audio files in bytes.
  Future<int> getTotalStorageUsageBytes() async {
    await init();
    if (_baseStoragePath == null) return 0;
    try {
      final dir = Directory(_baseStoragePath!);
      if (!dir.existsSync()) return 0;
      var total = 0;
      for (final entity in dir.listSync(recursive: true)) {
        if (entity is File) {
          total += entity.lengthSync();
        }
      }
      return total;
    } catch (_) {
      return 0;
    }
  }

  /// Deletes all downloaded audio files from the device.
  Future<bool> clearAllOfflineAudio({SharawyStore? store}) async {
    await init();
    if (_baseStoragePath == null) return false;
    try {
      final dir = Directory(_baseStoragePath!);
      if (dir.existsSync()) {
        for (final entity in dir.listSync(recursive: true)) {
          if (entity is File) {
            try {
              entity.deleteSync();
            } catch (_) {}
          }
        }
      }
      if (store != null) {
        for (final it in store.allItems) {
          if (it.localFilePath != null) {
            store.updateLocalPath(it.id, '');
          }
        }
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  String _cleanTrackTitle(String filename) {
    var name = filename;
    final dotIdx = name.lastIndexOf('.');
    if (dotIdx != -1) name = name.substring(0, dotIdx);
    name = name.replaceAll(RegExp(r'^[0-9]+[_\-\s]+'), '');
    name = name.replaceAll(RegExp(r'[_\-]+'), ' ').trim();
    return name.isNotEmpty ? name : filename;
  }
}
