import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/services/quran_audio_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranModule quranModule;
  late MockAudioPlayerAdapter mockPlayer;

  late CanonicalQuranPackage package;

  setUpAll(() async {
    package = await CanonicalQuranLoader.loadPackage();
  });

  setUp(() {
    mockPlayer = MockAudioPlayerAdapter();
    final store = ReadOnlyCanonicalQuranStore();
    store.mountPackage(package);
    final audioService = QuranAudioService(store: store, player: mockPlayer);

    quranModule = QuranModule(
      storageRegistry: MemoryStorageRegistry(),
      storeInstance: store,
      audioServiceInstance: audioService,
    );
  });

  group('M02.1 Quran Audio Runtime Tests (§14, §17, §19)', () {
    test('Actual playback transitions smoothly between play, pause, resume, and stop', () async {
      final reports = <AudioPlaybackReport>[];
      final sub = quranModule.audioService.reportStream.listen(reports.add);

      // 1. Play Surah 1 Ayah 1
      final playRes = await quranModule.audioService.playAyah(1, 1);
      expect(playRes.isSuccess, isTrue);
      expect(mockPlayer.isPlaying, isTrue);
      expect(quranModule.audioService.currentReport.status, equals(AudioPlaybackStatus.playing));
      expect(quranModule.audioService.currentReport.ayahNumber, equals(1));

      // 2. Pause
      await quranModule.audioService.pause();
      expect(mockPlayer.isPaused, isTrue);
      expect(quranModule.audioService.currentReport.status, equals(AudioPlaybackStatus.paused));

      // 3. Resume
      await quranModule.audioService.resume();
      expect(mockPlayer.isPlaying, isTrue);
      expect(quranModule.audioService.currentReport.status, equals(AudioPlaybackStatus.playing));

      // 4. Stop
      await quranModule.audioService.stop();
      expect(mockPlayer.isPlaying, isFalse);
      expect(quranModule.audioService.currentReport.status, equals(AudioPlaybackStatus.stopped));

      await sub.cancel();
    });

    test('Missing audio triggers honest Arabic disclosure without fake playback or crash', () async {
      mockPlayer.simulateMissingAudio = true;

      final res = await quranModule.audioService.playAyah(1, 1);
      expect(res.isFailure, isTrue);
      expect(quranModule.audioService.currentReport.status, equals(AudioPlaybackStatus.missingAudio));
      expect(
        quranModule.audioService.currentReport.statusMessageArabic,
        contains('الملف الصوتي للآية غير متوفر حالياً'),
      );
    });
  });
}
