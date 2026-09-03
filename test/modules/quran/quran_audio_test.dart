import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/services/quran_audio_service.dart';
import 'package:siraj/shell/seed/default_canonical_seed_provider.dart';

void main() {
  late QuranModule quranModule;

  setUp(() {
    final storage = MemoryStorageRegistry();
    quranModule = QuranModule(storageRegistry: storage);
    final package = DefaultCanonicalSeedProvider.getQuranSeedPackage();
    quranModule.mountPackage(package);
  });

  group('Quran Audio Recitation Service Suite (§14, §15)', () {
    test('Playback transitions through play, pause, resume, and stop correctly', () async {
      final playerAdapter = MockAudioPlayerAdapter();
      final audioService = QuranAudioService(
        store: quranModule.store,
        player: playerAdapter,
      );

      // 1. Play Ayah 1:1
      final playRes = await audioService.playAyah(1, 1);
      expect(playRes.isSuccess, isTrue);
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.playing));
      expect(audioService.currentReport.surahNumber, equals(1));
      expect(audioService.currentReport.ayahNumber, equals(1));

      // 2. Pause
      await audioService.pause();
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.paused));

      // 3. Resume
      await audioService.resume();
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.playing));

      // 4. Stop
      await audioService.stop();
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.stopped));

      audioService.dispose();
    });

    test('Next and previous ayah transitions step smoothly across verse boundaries', () async {
      final playerAdapter = MockAudioPlayerAdapter();
      final audioService = QuranAudioService(
        store: quranModule.store,
        player: playerAdapter,
      );

      // Start at 1:6
      await audioService.playAyah(1, 6);
      expect(audioService.currentReport.ayahNumber, equals(6));

      // Next -> 1:7
      await audioService.nextAyah();
      expect(audioService.currentReport.surahNumber, equals(1));
      expect(audioService.currentReport.ayahNumber, equals(7));

      // Next -> Transitions to Surah 2, Ayah 1 (boundary crossing)
      await audioService.nextAyah();
      expect(audioService.currentReport.surahNumber, equals(2));
      expect(audioService.currentReport.ayahNumber, equals(1));

      // Previous -> Transitions back to Surah 1, Ayah 7
      await audioService.previousAyah();
      expect(audioService.currentReport.surahNumber, equals(1));
      expect(audioService.currentReport.ayahNumber, equals(7));

      audioService.dispose();
    });

    test('Missing audio handles gracefully with missingAudio status and honest Arabic disclosure', () async {
      final missingAdapter = MockAudioPlayerAdapter(simulateMissingAudio: true);
      final audioService = QuranAudioService(
        store: quranModule.store,
        player: missingAdapter,
      );

      final res = await audioService.playAyah(1, 1);
      expect(res.isFailure, isTrue);
      expect(audioService.currentReport.status, equals(AudioPlaybackStatus.missingAudio));
      expect(
        audioService.currentReport.statusMessageArabic,
        equals('الملف الصوتي للآية غير متوفر حالياً'),
      );

      audioService.dispose();
    });
  });
}
