import 'dart:async';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../domain/quran_reciter.dart';

/// Result report for importing an offline recitation ZIP package.
class QuranZipImportResult {
  final bool isSuccess;
  final int importedVersesCount;
  final int totalBytes;
  final String? errorMessage;
  final String? targetDirectory;

  const QuranZipImportResult({
    required this.isSuccess,
    this.importedVersesCount = 0,
    this.totalBytes = 0,
    this.errorMessage,
    this.targetDirectory,
  });
}

/// Service for managing offline Quranic recitation MP3 audio files:
/// - Extracting and importing user-provided ZIP packages (from 001001.mp3 to 114006.mp3)
/// - Downloading full Surahs on-demand for any chosen reciter
/// - Resolving local playback paths to ensure seamless offline listening without internet.
class QuranOfflineAudioService {
  static QuranOfflineAudioService? _instance;
  static QuranOfflineAudioService get instance => _instance ??= QuranOfflineAudioService();

  String? _baseStoragePath;
  bool _isInitialized = false;

  QuranOfflineAudioService();

  /// Initializes the base offline storage directory on device.
  Future<void> init({String? overrideBasePath}) async {
    if (overrideBasePath != null) {
      _baseStoragePath = overrideBasePath;
      QuranReciter.customOfflineAudioBasePath = _baseStoragePath;
      _isInitialized = true;
      return;
    }

    if (_isInitialized && _baseStoragePath != null) return;

    try {
      final docDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${docDir.path}${Platform.pathSeparator}siraj_quran_audio');
      if (!audioDir.existsSync()) {
        await audioDir.create(recursive: true);
      }
      _baseStoragePath = audioDir.path;
      QuranReciter.customOfflineAudioBasePath = _baseStoragePath;
      _isInitialized = true;
    } catch (e) {
      // Fallback for test/mock environments where path_provider channel is not registered
      try {
        final tempDir = Directory('${Directory.systemTemp.path}${Platform.pathSeparator}siraj_quran_audio');
        if (!tempDir.existsSync()) {
          tempDir.createSync(recursive: true);
        }
        _baseStoragePath = tempDir.path;
        QuranReciter.customOfflineAudioBasePath = _baseStoragePath;
        _isInitialized = true;
      } catch (_) {}
    }
  }

  String? get baseStoragePath => _baseStoragePath;

  /// Resolves the dedicated local directory for a specific reciter.
  Future<Directory> getReciterDirectory(String reciterId) async {
    await init();
    final path = '$_baseStoragePath${Platform.pathSeparator}$reciterId';
    final dir = Directory(path);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Checks if a specific verse MP3 file exists locally for a reciter.
  Future<String?> getLocalAyahFilePath(String reciterId, int surahNumber, int ayahNumber) async {
    await init();
    final sPad = surahNumber.toString().padLeft(3, '0');
    final aPad = ayahNumber.toString().padLeft(3, '0');
    final fileName = '$sPad$aPad.mp3';

    final reciterDir = '$_baseStoragePath${Platform.pathSeparator}$reciterId';
    final candidatePath = '$reciterDir${Platform.pathSeparator}$fileName';

    final file = File(candidatePath);
    if (file.existsSync() && file.lengthSync() > 1024) {
      return candidatePath;
    }
    return null;
  }

  /// Lets the user pick a ZIP file from device storage and imports it for the reciter.
  Future<QuranZipImportResult?> pickAndImportZip({required String reciterId}) async {
    await init();
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        dialogTitle: 'اختر ملف ZIP يحتوي على تلاوات الشيخ',
      );

      if (files.isEmpty || files.first.path == null) {
        return null;
      }

      final zipFilePath = files.first.path!;
      return await importZipFile(reciterId: reciterId, zipFilePath: zipFilePath);
    } catch (e) {
      return QuranZipImportResult(
        isSuccess: false,
        errorMessage: 'تعذر اختيار أو قراءة ملف ZIP: $e',
      );
    }
  }

  /// Extracts and imports all verse MP3 files from a ZIP archive with zero-RAM streaming.
  Future<QuranZipImportResult> importZipFile({
    required String reciterId,
    required String zipFilePath,
    void Function(int extractedCount)? onProgress,
  }) async {
    await init();
    final targetDir = await getReciterDirectory(reciterId);

    try {
      final zipFile = File(zipFilePath);
      if (!zipFile.existsSync()) {
        return const QuranZipImportResult(
          isSuccess: false,
          errorMessage: 'ملف ZIP المحدد غير موجود على الجهاز.',
        );
      }

      final input = InputFileStream(zipFilePath);
      final archive = ZipDecoder().decodeStream(input);

      int importedCount = 0;
      int totalBytes = 0;

      for (final file in archive) {
        if (file.isFile) {
          final normalizedName = normalizeVerseFileName(file.name);

          if (normalizedName != null && normalizedName.toLowerCase().endsWith('.mp3')) {
            final destPath = '${targetDir.path}${Platform.pathSeparator}$normalizedName';
            final output = OutputFileStream(destPath);
            try {
              file.writeContent(output);
              importedCount++;
              totalBytes += file.size;
              onProgress?.call(importedCount);
            } catch (_) {
            } finally {
              await output.close();
            }
            // Release decompressed memory buffer immediately to prevent heap exhaustion
            file.clear();
          }
        }
      }

      await input.close();

      if (importedCount == 0) {
        return const QuranZipImportResult(
          isSuccess: false,
          errorMessage: 'لم يتم العثور على أي ملفات صوتية بصيغة .mp3 داخل ملف الـ ZIP.',
        );
      }

      return QuranZipImportResult(
        isSuccess: true,
        importedVersesCount: importedCount,
        totalBytes: totalBytes,
        targetDirectory: targetDir.path,
      );
    } catch (e) {
      return QuranZipImportResult(
        isSuccess: false,
        errorMessage: 'حدث خطأ أثناء فك ضغط ملف ZIP: $e',
      );
    }
  }

  /// Downloads all Ayahs of a given Surah from the reciter CDN and saves them locally.
  Future<void> downloadSurahAudio({
    required QuranReciter reciter,
    required int surahNumber,
    required int ayahCount,
    required void Function(int currentAyah, int totalAyahs) onProgress,
    required void Function(String error) onError,
    bool Function()? isCancelled,
  }) async {
    await init();
    final targetDir = await getReciterDirectory(reciter.id);
    final baseUrl = reciter.remoteBaseUrl;

    if (baseUrl == null || baseUrl.isEmpty) {
      onError('لا يتوفر رابط بث شبكي لهذا القارئ للتحميل منه.');
      return;
    }

    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 15);

    final sPad = surahNumber.toString().padLeft(3, '0');

    for (int ayah = 1; ayah <= ayahCount; ayah++) {
      if (isCancelled?.call() == true) {
        client.close(force: true);
        return;
      }

      final aPad = ayah.toString().padLeft(3, '0');
      final fileName = '$sPad$aPad.mp3';
      final destFile = File('${targetDir.path}${Platform.pathSeparator}$fileName');

      // If file already downloaded and valid, report and continue
      if (destFile.existsSync() && destFile.lengthSync() > 1024) {
        onProgress(ayah, ayahCount);
        continue;
      }

      final url = '$baseUrl/$fileName';

      try {
        final request = await client.getUrl(Uri.parse(url));
        final response = await request.close();

        if (response.statusCode == 200) {
          final fileSink = destFile.openWrite();
          await response.pipe(fileSink);
          await fileSink.close();
          onProgress(ayah, ayahCount);
        } else {
          onError('فشل تحميل الآية $ayah (رمز الاستجابة ${response.statusCode})');
          client.close(force: true);
          return;
        }
      } catch (e) {
        onError('خطأ أثناء تحميل الآية $ayah: $e');
        client.close(force: true);
        return;
      }
    }

    client.close();
  }

  /// Checks if all verses in a Surah are downloaded locally.
  Future<bool> isSurahDownloaded(String reciterId, int surahNumber, int ayahCount) async {
    await init();
    final downloadedCount = await getDownloadedAyahsCount(reciterId, surahNumber, ayahCount);
    return downloadedCount == ayahCount && ayahCount > 0;
  }

  /// Returns the count of downloaded verses for a given Surah.
  Future<int> getDownloadedAyahsCount(String reciterId, int surahNumber, int ayahCount) async {
    await init();
    final targetDir = await getReciterDirectory(reciterId);
    final sPad = surahNumber.toString().padLeft(3, '0');

    int count = 0;
    for (int a = 1; a <= ayahCount; a++) {
      final aPad = a.toString().padLeft(3, '0');
      final file = File('${targetDir.path}${Platform.pathSeparator}$sPad$aPad.mp3');
      if (file.existsSync() && file.lengthSync() > 1024) {
        count++;
      }
    }
    return count;
  }

  /// Returns the total count of downloaded MP3 files for a reciter.
  Future<int> getTotalDownloadedFilesCount(String reciterId) async {
    await init();
    final targetDir = await getReciterDirectory(reciterId);
    if (!targetDir.existsSync()) return 0;

    final files = targetDir.listSync();
    return files.where((f) => f is File && f.path.toLowerCase().endsWith('.mp3')).length;
  }

  /// Deletes all offline audio files for a given reciter.
  Future<void> deleteReciterAudio(String reciterId) async {
    await init();
    final targetDir = await getReciterDirectory(reciterId);
    if (targetDir.existsSync()) {
      await targetDir.delete(recursive: true);
      await targetDir.create(recursive: true);
    }
  }

  /// Normalizes Quranic verse audio file names from various archive formats
  /// (e.g. 001001.mp3, 1_1.mp3, 001_001.mp3, 001/001.mp3) into standard 6-digit form 001001.mp3.
  static String? normalizeVerseFileName(String fullPathInArchive) {
    final cleanPath = fullPathInArchive.replaceAll('\\', '/');
    final segments = cleanPath.split('/').where((s) => s.trim().isNotEmpty).toList();
    if (segments.isEmpty) return null;

    final baseName = segments.last.trim();
    if (!baseName.toLowerCase().endsWith('.mp3')) return null;

    final nameWithoutExt = baseName.substring(0, baseName.length - 4).trim();

    // Pattern 1: Exactly 6 digits (e.g. 001001)
    if (RegExp(r'^\d{6}$').hasMatch(nameWithoutExt)) {
      return '$nameWithoutExt.mp3';
    }

    // Pattern 2: Separator between surah and ayah (e.g. 001_001, 1_1, 001-001, 1-1)
    final sepMatch = RegExp(r'^(\d{1,3})[\s\-_]+(\d{1,3})$').firstMatch(nameWithoutExt);
    if (sepMatch != null) {
      final s = int.tryParse(sepMatch.group(1)!);
      final a = int.tryParse(sepMatch.group(2)!);
      if (s != null && s >= 1 && s <= 114 && a != null && a >= 1) {
        final sPad = s.toString().padLeft(3, '0');
        final aPad = a.toString().padLeft(3, '0');
        return '$sPad$aPad.mp3';
      }
    }

    // Pattern 3: Subdirectory is surah, file is ayah (e.g. 001/001.mp3 or 1/1.mp3)
    if (segments.length >= 2) {
      final dirName = segments[segments.length - 2].trim();
      final s = int.tryParse(dirName.replaceAll(RegExp(r'[^\d]'), ''));
      final a = int.tryParse(nameWithoutExt.replaceAll(RegExp(r'[^\d]'), ''));
      if (s != null && s >= 1 && s <= 114 && a != null && a >= 1) {
        final sPad = s.toString().padLeft(3, '0');
        final aPad = a.toString().padLeft(3, '0');
        return '$sPad$aPad.mp3';
      }
    }

    // Fallback: preserve original base name
    return baseName;
  }
}
