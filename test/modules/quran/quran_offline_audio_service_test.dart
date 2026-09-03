import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/quran_reciter.dart';
import 'package:siraj/modules/quran/services/quran_offline_audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late QuranOfflineAudioService service;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('siraj_audio_test_');
    service = QuranOfflineAudioService();
    await service.init(overrideBasePath: tempDir.path);
  });

  tearDown(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('QuranOfflineAudioService & ZIP Import Tests', () {
    test('extracts and imports valid ZIP file containing verse MP3s', () async {
      // Create a test ZIP archive containing 001001.mp3 and 001002.mp3
      final archive = Archive();
      final sampleAudioBytes = List<int>.generate(2048, (i) => i % 256);

      archive.addFile(ArchiveFile('001001.mp3', sampleAudioBytes.length, sampleAudioBytes));
      archive.addFile(ArchiveFile('subfolder/001002.mp3', sampleAudioBytes.length, sampleAudioBytes));
      archive.addFile(ArchiveFile('readme.txt', 12, 'Not an audio'.codeUnits));

      final zipData = ZipEncoder().encode(archive);
      final zipFile = File('${tempDir.path}${Platform.pathSeparator}test_recitation.zip');
      await zipFile.writeAsBytes(zipData);

      final reciterId = 'husary';
      final result = await service.importZipFile(
        reciterId: reciterId,
        zipFilePath: zipFile.path,
      );

      expect(result.isSuccess, isTrue);
      expect(result.importedVersesCount, equals(2));

      final count = await service.getTotalDownloadedFilesCount(reciterId);
      expect(count, equals(2));

      // Check that QuranReciter resolves to this extracted local file
      const reciter = QuranReciter(
        id: 'husary',
        nameArabic: 'الشيخ محمود خليل الحصري',
        subTitle: 'المصحف المرتل',
        remoteBaseUrl: 'https://everyayah.com/data/Husary_128kbps',
      );

      final uris = reciter.resolveCandidateUris(1, 1);
      expect(uris.first, contains('husary'));
      expect(uris.first, contains('001001.mp3'));
      expect(File(uris.first).existsSync(), isTrue);

      // Verify deletion
      await service.deleteReciterAudio(reciterId);
      final countAfterDelete = await service.getTotalDownloadedFilesCount(reciterId);
      expect(countAfterDelete, equals(0));
    });

    test('returns failure when ZIP does not contain any MP3 files', () async {
      final archive = Archive();
      archive.addFile(ArchiveFile('document.pdf', 10, 'Some text'.codeUnits));

      final zipData = ZipEncoder().encode(archive);
      final zipFile = File('${tempDir.path}${Platform.pathSeparator}invalid.zip');
      await zipFile.writeAsBytes(zipData);

      final result = await service.importZipFile(
        reciterId: 'minshawi',
        zipFilePath: zipFile.path,
      );

      expect(result.isSuccess, isFalse);
      expect(result.importedVersesCount, equals(0));
    });
  });
}
