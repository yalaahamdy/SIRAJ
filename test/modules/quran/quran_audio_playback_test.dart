import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/services/quran_audio_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ReadOnlyCanonicalQuranStore store;
  late MockAudioPlayerAdapter playerAdapter;
  late QuranAudioService audioService;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    store = ReadOnlyCanonicalQuranStore();
    store.mountPackage(package);
  });

  setUp(() {
    playerAdapter = MockAudioPlayerAdapter();
    audioService = QuranAudioService(store: store, player: playerAdapter);
  });

  tearDown(() {
    audioService.dispose();
  });

  group('M02 Quran Audio Recitation Tests', () {
    test('playAyah initiates recitation and emits playing status', () async {
      final res = await audioService.playAyah(1, 1);
      expect(res.isSuccess, isTrue);
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.playing));
      expect(audioService.currentReport.surahNumber, equals(1));
      expect(audioService.currentReport.ayahNumber, equals(1));
      expect(playerAdapter.isPlaying, isTrue);
    });

    test('pause and resume toggle playback appropriately', () async {
      await audioService.playAyah(1, 2);
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.playing));

      await audioService.pause();
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.paused));
      expect(playerAdapter.isPaused, isTrue);

      await audioService.resume();
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.playing));
      expect(playerAdapter.isPlaying, isTrue);
    });

    test('playRange executes sequential playback and loops until repeat count finishes', () async {
      final res = await audioService.playRange(1, 1, 3, repeatCount: 2);
      expect(res.isSuccess, isTrue);
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.playing));
      expect(audioService.currentReport.ayahNumber, equals(1));
      expect(audioService.currentReport.repeatMode, equals(AudioRepeatMode.range));

      // Advance to Ayah 2
      await audioService.nextAyah();
      expect(audioService.currentReport.ayahNumber, equals(2));

      // Advance to Ayah 3 (end of range, iteration 1)
      await audioService.nextAyah();
      expect(audioService.currentReport.ayahNumber, equals(3));

      // Advance from end of range -> triggers iteration 2 starting back at Ayah 1
      await audioService.nextAyah();
      expect(audioService.currentReport.ayahNumber, equals(1));
      expect(audioService.currentReport.currentIteration, equals(2));
    });

    test('stop terminates playback and resets active range', () async {
      await audioService.playRange(1, 2, 4);
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.playing));

      await audioService.stop();
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.stopped));
      expect(playerAdapter.isPlaying, isFalse);
    });

    test('handles missing audio transparently without crashing', () async {
      playerAdapter.simulateMissingAudio = true;
      final res = await audioService.playAyah(1, 1);
      expect(res.isFailure, isTrue);
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.missingAudio));
      expect(audioService.currentReport.statusMessageArabic, contains('غير متوفر'));
    });
  });
}
