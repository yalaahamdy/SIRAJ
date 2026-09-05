import 'dart:async';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/tawasheeh_item.dart';
import '../store/tawasheeh_store.dart';

/// Result report for importing an offline Tawasheeh ZIP archive or audio files.
class TawasheehImportResult {
  final bool isSuccess;
  final int importedTracksCount;
  final int matchedExistingCount;
  final int totalBytes;
  final String? errorMessage;
  final String? targetDirectory;

  const TawasheehImportResult({
    required this.isSuccess,
    this.importedTracksCount = 0,
    this.matchedExistingCount = 0,
    this.totalBytes = 0,
    this.errorMessage,
    this.targetDirectory,
  });
}

/// Service managing offline storage, ZIP extraction, and local playback
/// for rare Tawasheeh and Ibtihalat recordings (§14, §20).
class TawasheehOfflineAudioService {
  static TawasheehOfflineAudioService? _instance;
  static TawasheehOfflineAudioService get instance =>
      _instance ??= TawasheehOfflineAudioService();

  static void setMockInstance(TawasheehOfflineAudioService mock) {
    _instance = mock;
  }

  String? _baseStoragePath;
  bool _isInitialized = false;

  TawasheehOfflineAudioService();

  /// Initializes the dedicated offline Tawasheeh storage directory.
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
        '${docDir.path}${Platform.pathSeparator}siraj_tawasheeh_audio',
      );
      if (!audioDir.existsSync()) {
        await audioDir.create(recursive: true);
      }
      _baseStoragePath = audioDir.path;
      _isInitialized = true;
    } catch (e) {
      // Fallback for mock/test environments
      try {
        final tempDir = Directory(
          '${Directory.systemTemp.path}${Platform.pathSeparator}siraj_tawasheeh_audio',
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

  /// Returns the local file path for a given Tawasheeh item if it exists on disk.
  Future<String?> getLocalFilePath(TawasheehItem item) async {
    await init();
    if (_baseStoragePath == null) return null;

    // Check direct localFilePath if already assigned
    if (item.localFilePath != null && item.localFilePath!.isNotEmpty) {
      final file = File(item.localFilePath!);
      if (file.existsSync() && file.lengthSync() > 1024) {
        return file.path;
      }
    }

    // Check candidate by standardized ID: tawasheeh_001.mp3
    final idCandidate = File('$_baseStoragePath${Platform.pathSeparator}${item.id}.mp3');
    if (idCandidate.existsSync() && idCandidate.lengthSync() > 1024) {
      return idCandidate.path;
    }

    // Check candidate by matching title from directory
    final dir = Directory(_baseStoragePath!);
    if (dir.existsSync()) {
      try {
        final files = dir.listSync();
        for (final entity in files) {
          if (entity is File && entity.path.toLowerCase().endsWith('.mp3')) {
            final fileName = entity.uri.pathSegments.last;
            if (_matchesTawasheeh(fileName, item)) {
              return entity.path;
            }
          }
        }
      } catch (_) {}
    }

    return null;
  }

  /// Checks if a Tawasheeh item is downloaded or available offline.
  Future<bool> isItemDownloaded(TawasheehItem item) async {
    final path = await getLocalFilePath(item);
    return path != null;
  }

  /// Counts total valid offline audio files in storage.
  Future<int> getDownloadedCount() async {
    await init();
    if (_baseStoragePath == null) return 0;
    final dir = Directory(_baseStoragePath!);
    if (!dir.existsSync()) return 0;
    try {
      final files = dir.listSync();
      return files
          .where((f) => f is File && f.path.toLowerCase().endsWith('.mp3') && f.lengthSync() > 1024)
          .length;
    } catch (_) {
      return 0;
    }
  }

  /// Picks a ZIP archive from device storage and imports all MP3 recordings.
  Future<TawasheehImportResult?> pickAndImportZip({TawasheehStore? store}) async {
    await init();
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        dialogTitle: 'اختر ملف ZIP يحتوي على التواشيح والابتهالات',
      );

      if (files.isEmpty || files.first.path == null) {
        return null;
      }

      final zipFilePath = files.first.path!;
      return await importZipFile(zipFilePath: zipFilePath, store: store);
    } catch (e) {
      return TawasheehImportResult(
        isSuccess: false,
        errorMessage: 'تعذر اختيار ملف الـ ZIP: $e',
      );
    }
  }

  /// Picks individual audio files (MP3) from device storage and saves them locally.
  Future<TawasheehImportResult?> pickAndImportAudioFiles({TawasheehStore? store}) async {
    await init();
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'm4a', 'wav'],
        dialogTitle: 'اختر تسجيلات الابتهالات الصوتية',
      );

      if (files.isEmpty) return null;

      int imported = 0;
      int matched = 0;
      int bytes = 0;
      final newCustomItems = <TawasheehItem>[];

      for (final picked in files) {
        if (picked.path != null) {
          final srcFile = File(picked.path!);
          if (srcFile.existsSync()) {
            final fileName = picked.name;
            final destPath = '$_baseStoragePath${Platform.pathSeparator}$fileName';
            await srcFile.copy(destPath);
            imported++;
            bytes += srcFile.lengthSync();

            // Match against store
            TawasheehItem? matchedItem;
            if (store != null) {
              for (final it in store.allItems) {
                if (_matchesTawasheeh(fileName, it)) {
                  matchedItem = it;
                  store.updateLocalPath(it.id, destPath);
                  matched++;
                  break;
                }
              }
            }

            if (matchedItem == null && store != null) {
              final clean = fileName.replaceAll(RegExp(r'\.mp3$', caseSensitive: false), '').trim();
              newCustomItems.add(
                TawasheehItem(
                  id: 'local_tawasheeh_${DateTime.now().millisecondsSinceEpoch}_$imported',
                  cleanTitle: clean,
                  fullTitle: clean,
                  reciter: 'تسجيل محلي',
                  duration: '--:--',
                  durationSeconds: 0.0,
                  url: '',
                  localFilePath: destPath,
                  isCustomLocal: true,
                ),
              );
            }
          }
        }
      }

      if (newCustomItems.isNotEmpty && store != null) {
        store.addCustomItems(newCustomItems);
      }

      return TawasheehImportResult(
        isSuccess: imported > 0,
        importedTracksCount: imported,
        matchedExistingCount: matched,
        totalBytes: bytes,
        targetDirectory: _baseStoragePath,
      );
    } catch (e) {
      return TawasheehImportResult(
        isSuccess: false,
        errorMessage: 'تعذر استيراد الملفات الصوتية: $e',
      );
    }
  }

  /// Extracts and imports all MP3 recordings from a ZIP file archive with streaming.
  Future<TawasheehImportResult> importZipFile({
    required String zipFilePath,
    TawasheehStore? store,
    void Function(int count)? onProgress,
  }) async {
    await init();
    try {
      final zipFile = File(zipFilePath);
      if (!zipFile.existsSync()) {
        return const TawasheehImportResult(
          isSuccess: false,
          errorMessage: 'ملف الـ ZIP المحدد غير موجود على الجهاز.',
        );
      }

      final input = InputFileStream(zipFilePath);
      final archive = ZipDecoder().decodeStream(input);

      int importedCount = 0;
      int matchedCount = 0;
      int totalBytes = 0;
      final customItems = <TawasheehItem>[];

      for (final file in archive) {
        if (file.isFile) {
          final name = file.name;
          final baseName = name.split(RegExp(r'[/\\]')).last.trim();

          if (baseName.toLowerCase().endsWith('.mp3')) {
            final destPath = '$_baseStoragePath${Platform.pathSeparator}$baseName';
            final output = OutputFileStream(destPath);
            try {
              file.writeContent(output);
              importedCount++;
              totalBytes += file.size;
              onProgress?.call(importedCount);
            } finally {
              await output.close();
            }
            file.clear();

            // Match extracted audio with store items
            if (store != null) {
              bool matched = false;
              for (final it in store.allItems) {
                if (_matchesTawasheeh(baseName, it)) {
                  store.updateLocalPath(it.id, destPath);
                  matchedCount++;
                  matched = true;
                  break;
                }
              }

              if (!matched) {
                final clean = baseName
                    .replaceAll(RegExp(r'\.mp3$', caseSensitive: false), '')
                    .replaceAll(RegExp(r'^\d+[\s\-_]+'), '')
                    .trim();
                customItems.add(
                  TawasheehItem(
                    id: 'custom_zip_${DateTime.now().millisecondsSinceEpoch}_$importedCount',
                    cleanTitle: clean.isNotEmpty ? clean : baseName,
                    fullTitle: baseName,
                    reciter: _detectReciterName(baseName),
                    duration: '--:--',
                    durationSeconds: 0.0,
                    url: '',
                    localFilePath: destPath,
                    isCustomLocal: true,
                  ),
                );
              }
            }
          }
        }
      }

      await input.close();

      if (customItems.isNotEmpty && store != null) {
        store.addCustomItems(customItems);
      }

      if (importedCount == 0) {
        return const TawasheehImportResult(
          isSuccess: false,
          errorMessage: 'لم يتم العثور على أي ملفات MP3 داخل ملف الـ ZIP.',
        );
      }

      return TawasheehImportResult(
        isSuccess: true,
        importedTracksCount: importedCount,
        matchedExistingCount: matchedCount,
        totalBytes: totalBytes,
        targetDirectory: _baseStoragePath,
      );
    } catch (e) {
      return TawasheehImportResult(
        isSuccess: false,
        errorMessage: 'حدث خطأ أثناء فك ضغط ملف التواشيح: $e',
      );
    }
  }

  /// Downloads a specific Tawasheeh track on-demand from its archive.org URL.
  Future<bool> downloadTawasheehItem(
    TawasheehItem item, {
    void Function(double progress)? onProgress,
    void Function(String error)? onError,
  }) async {
    await init();
    if (_baseStoragePath == null || item.url.isEmpty) {
      onError?.call('رابط التحميل غير متوفر لهذا الابتهال.');
      return false;
    }

    final destPath = '$_baseStoragePath${Platform.pathSeparator}${item.id}.mp3';
    final destFile = File(destPath);

    if (destFile.existsSync() && destFile.lengthSync() > 1024) {
      onProgress?.call(1.0);
      return true;
    }

    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 20);

    try {
      final request = await client.getUrl(Uri.parse(item.url));
      final response = await request.close();

      if (response.statusCode == 200) {
        final totalLength = response.contentLength;
        int receivedBytes = 0;

        final fileSink = destFile.openWrite();
        await response.listen((chunk) {
          fileSink.add(chunk);
          receivedBytes += chunk.length;
          if (totalLength > 0) {
            onProgress?.call(receivedBytes / totalLength);
          }
        }).asFuture();

        await fileSink.close();
        client.close();
        return true;
      } else {
        onError?.call('فشل التنزيل (رمز الاستجابة: ${response.statusCode})');
        client.close(force: true);
        return false;
      }
    } catch (e) {
      onError?.call('خطأ أثناء تنزيل الابتهال: $e');
      client.close(force: true);
      return false;
    }
  }

  /// Clears all local Tawasheeh recordings to free device storage.
  Future<void> deleteOfflineTawasheeh({TawasheehStore? store}) async {
    await init();
    if (_baseStoragePath == null) return;
    final dir = Directory(_baseStoragePath!);
    if (dir.existsSync()) {
      await dir.delete(recursive: true);
      await dir.create(recursive: true);
    }
    if (store != null) {
      store.clearLocalPaths();
    }
  }

  /// Fuzzy matching between extracted filename and Tawasheeh metadata.
  bool _matchesTawasheeh(String fileName, TawasheehItem item) {
    final f = fileName.toLowerCase().trim();
    final clean = item.cleanTitle.toLowerCase().trim();
    final reciter = item.reciter.toLowerCase().trim();

    // Match by item ID
    if (f.startsWith(item.id.toLowerCase())) return true;

    // Match by prefix index (e.g. "16 - " or "01 - " matching id "tawasheeh_016")
    final match = RegExp(r'^0*(\d+)').firstMatch(f);
    if (match != null) {
      final fileIndex = int.tryParse(match.group(1)!);
      final itemIndex = int.tryParse(item.id.replaceAll(RegExp(r'[^\d]'), ''));
      if (fileIndex != null && itemIndex != null && fileIndex == itemIndex) {
        return true;
      }
    }

    // Match by reciter and significant title keywords
    if (reciter.isNotEmpty && f.contains(reciter)) {
      final words = clean.split(RegExp(r'\s+')).where((w) => w.length > 3);
      for (final w in words) {
        if (f.contains(w)) return true;
      }
    }

    return false;
  }

  String _detectReciterName(String fileName) {
    const knownReciters = [
      'محمد عمران',
      'نصر الدين طوبار',
      'نصرالدين طوبار',
      'كامل يوسف البهتيمي',
      'محمد الطوخي',
      'محمد الطوخى',
      'إسماعيل السمكري',
      'اسماعيل السمكرى',
      'محمد الهلباوي',
      'حسن قاسم',
      'سعيد حافظ',
      'سلامة الريدي',
      'سلامة الريدى',
      'ممدوح عبد الجليل',
      'عبد السميع بيومي',
    ];

    for (final r in knownReciters) {
      if (fileName.contains(r)) {
        return r.replaceAll('ى', 'ي').replaceAll('نصرالدين', 'نصر الدين');
      }
    }
    return 'كبار المبتهلين';
  }
}
