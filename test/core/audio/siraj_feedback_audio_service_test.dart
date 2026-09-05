import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/audio/siraj_feedback_audio_service.dart';
import 'package:siraj/core/storage/memory_storage.dart';

class MockFeedbackAudioPlayerAdapter implements FeedbackAudioPlayerAdapter {
  final List<String> playedAssets = [];
  final List<double> playedVolumes = [];
  bool stopped = false;
  bool disposed = false;

  @override
  Future<void> playAsset(String assetPath, {double volume = 1.0}) async {
    playedAssets.add(assetPath);
    playedVolumes.add(volume);
  }

  @override
  Future<void> stop() async {
    stopped = true;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
  }

  void reset() {
    playedAssets.clear();
    playedVolumes.clear();
    stopped = false;
    disposed = false;
  }
}

void main() {
  group('Siraj Feedback Audio Service Suite', () {
    late MockFeedbackAudioPlayerAdapter mockAdapter;
    late SirajFeedbackAudioService audioService;
    late MemoryStorageRegistry storage;

    setUp(() {
      mockAdapter = MockFeedbackAudioPlayerAdapter();
      storage = MemoryStorageRegistry();
      audioService = SirajFeedbackAudioService(
        player: mockAdapter,
        storageRegistry: storage,
        isEnabled: true,
      );
      SirajFeedbackAudioService.setMockInstance(audioService);
    });

    test('All specific domain audio triggers invoke the adapter with correct assets and volumes', () async {
      // 1. Tap
      await audioService.playTap();
      expect(mockAdapter.playedAssets.last, equals(SirajAudioEffects.tap));
      expect(mockAdapter.playedVolumes.last, equals(0.6));

      // 2. Tasbih
      await audioService.playTasbih();
      expect(mockAdapter.playedAssets.last, equals(SirajAudioEffects.tasbih));
      expect(mockAdapter.playedVolumes.last, equals(0.9));

      // 3. Completion
      await audioService.playCompletion();
      expect(mockAdapter.playedAssets.last, equals(SirajAudioEffects.completion));
      expect(mockAdapter.playedVolumes.last, equals(0.85));

      // 4. Page Flip
      await audioService.playPageFlip();
      expect(mockAdapter.playedAssets.last, equals(SirajAudioEffects.pageFlip));
      expect(mockAdapter.playedVolumes.last, equals(0.7));

      // 5. Bookmark
      await audioService.playBookmark();
      expect(mockAdapter.playedAssets.last, equals(SirajAudioEffects.bookmark));
      expect(mockAdapter.playedVolumes.last, equals(0.75));

      // 6. Recitation Success
      await audioService.playSuccess();
      expect(mockAdapter.playedAssets.last, equals(SirajAudioEffects.recitationSuccess));
      expect(mockAdapter.playedVolumes.last, equals(0.85));

      expect(mockAdapter.playedAssets.length, equals(6));
    });

    test('Muting sound effects disables playback completely', () async {
      await audioService.setSoundEnabled(false);
      expect(audioService.isEnabled, isFalse);

      await audioService.playTasbih();
      await audioService.playCompletion();
      await audioService.playPageFlip();

      expect(mockAdapter.playedAssets, isEmpty);

      // Re-enable
      await audioService.setSoundEnabled(true);
      expect(audioService.isEnabled, isTrue);

      await audioService.playTasbih();
      expect(mockAdapter.playedAssets.length, equals(1));
    });

    test('When Quran is actively reciting, feedback audio is suppressed to prevent disturbance', () async {
      audioService.isQuranPlaying = () => true;

      await audioService.playTasbih();
      await audioService.playTap();
      expect(mockAdapter.playedAssets, isEmpty);

      // When Quran recitation pauses/stops
      audioService.isQuranPlaying = () => false;

      await audioService.playTasbih();
      expect(mockAdapter.playedAssets.length, equals(1));
    });

    test('Volume clamping and custom volume levels work accurately', () async {
      audioService.setVolume(0.5);
      expect(audioService.volume, equals(0.5));

      // Clamped above 1.0
      audioService.setVolume(1.8);
      expect(audioService.volume, equals(1.0));

      // Clamped below 0.0
      audioService.setVolume(-0.4);
      expect(audioService.volume, equals(0.0));
    });

    test('Storage persistence loads and saves sound settings', () async {
      // Toggle off and save
      await audioService.setSoundEnabled(false);

      // Re-create service with same storage
      final newService = SirajFeedbackAudioService(
        player: mockAdapter,
        storageRegistry: storage,
      );
      await newService.initStorage(storage);

      expect(newService.isEnabled, isFalse);
    });

    test('Dispose delegates to player adapter', () async {
      await audioService.dispose();
      expect(mockAdapter.disposed, isTrue);
    });
  });
}
