import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/recitation/domain/quran_recitation_session.dart';
import 'package:siraj/modules/quran/recitation/domain/recitation_playback_policy.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_recorder.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_session_store.dart';

void main() {
  late Directory tempDir;
  late MockAudioRecorderAdapter mockAdapter;
  late QuranRecitationRecorder recorder;
  late MemoryStorageRegistry storageRegistry;
  late QuranRecitationSessionStore sessionStore;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('siraj_recitation_test_');
    mockAdapter = MockAudioRecorderAdapter(permissionGranted: true);
    recorder = QuranRecitationRecorder(
      adapter: mockAdapter,
      customDirectory: tempDir,
    );
    storageRegistry = MemoryStorageRegistry();
    sessionStore = QuranRecitationSessionStore(storageRegistry: storageRegistry);
  });

  tearDown(() {
    try {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    } catch (_) {}
  });

  group('M02.2 Quran Record Recitation Subsystem Tests (§3, §14, §18)', () {
    test('Verifies microphone permission check correctly', () async {
      expect(await recorder.checkPermission(), isTrue);

      mockAdapter.permissionGranted = false;
      expect(await recorder.checkPermission(), isFalse);
    });

    test('Throws StateError if attempting to record without permission', () async {
      mockAdapter.permissionGranted = false;

      expect(
        () => recorder.startRecording(surahNumber: 1, startAyah: 1, endAyah: 7),
        throwsA(isA<StateError>()),
      );
    });

    test('Starts and stops audio recording generating valid deterministic file', () async {
      final path = await recorder.startRecording(
        surahNumber: 1,
        startAyah: 1,
        endAyah: 7,
      );

      expect(path, contains('rec_1_1_7_'));
      expect(path, endsWith('.m4a'));
      expect(await recorder.isRecording(), isTrue);

      final stoppedPath = await recorder.stopRecording();
      expect(stoppedPath, equals(path));
      expect(await recorder.isRecording(), isFalse);

      // Verify file was written to disk
      final file = File(stoppedPath!);
      expect(file.existsSync(), isTrue);
    });

    test('Pauses and resumes active audio recording without losing state', () async {
      await recorder.startRecording(
        surahNumber: 2,
        startAyah: 1,
        endAyah: 5,
      );

      await recorder.pauseRecording();
      expect(mockAdapter.isPaused, isTrue);

      await recorder.resumeRecording();
      expect(mockAdapter.isPaused, isFalse);

      await recorder.stopRecording();
    });

    test('Deletes recording file safely from local storage', () async {
      final path = await recorder.startRecording(
        surahNumber: 112,
        startAyah: 1,
        endAyah: 4,
      );
      await recorder.stopRecording();

      final file = File(path);
      expect(file.existsSync(), isTrue);

      final deleted = await recorder.deleteRecording(path);
      expect(deleted, isTrue);
      expect(file.existsSync(), isFalse);
    });

    test('Enforces storage quota awareness keeping at most maxRetainedRecordings (§18)', () async {
      // Simulate creating 22 older files in the directory
      final now = DateTime.now();
      for (int i = 0; i < 22; i++) {
        final f = File('${tempDir.path}/rec_dummy_$i.m4a');
        f.createSync();
        f.setLastModifiedSync(now.subtract(Duration(minutes: 50 - i)));
      }

      var currentFiles = tempDir.listSync().whereType<File>().toList();
      expect(currentFiles.length, equals(22));

      // Starting a new recording should trigger quota enforcement
      await recorder.startRecording(surahNumber: 1, startAyah: 1, endAyah: 7);
      await recorder.stopRecording();

      final retainedFiles = tempDir.listSync().whereType<File>().toList();
      // Should not exceed maximum allowed recordings (20)
      expect(retainedFiles.length, lessThanOrEqualTo(QuranRecitationRecorder.maxRetainedRecordings));
    });

    test('Saves and retrieves recitation session in isolated local storage store', () async {
      final session = QuranRecitationSession(
        sessionId: 'sess_test_123',
        surahNumber: 1,
        surahNameArabic: 'الفاتحة',
        startAyah: 1,
        endAyah: 7,
        mode: RecitationMode.recordAndReplay,
        startedAt: DateTime.now().subtract(const Duration(minutes: 1)),
        endedAt: DateTime.now(),
        audioPath: '${tempDir.path}/rec_sample.m4a',
        totalWords: 29,
        recognizedWordsCount: 29,
        duration: const Duration(seconds: 45),
        status: RecitationSessionStatus.completed,
      );

      await sessionStore.saveLastSession(session);

      final retrieved = await sessionStore.getLastSession();
      expect(retrieved, isNotNull);
      expect(retrieved!.sessionId, equals('sess_test_123'));
      expect(retrieved.surahNumber, equals(1));
      expect(retrieved.mode, equals(RecitationMode.recordAndReplay));
      expect(retrieved.duration.inSeconds, equals(45));

      // Clear session
      await sessionStore.clearLastSession();
      expect(await sessionStore.getLastSession(), isNull);
    });
  });
}
