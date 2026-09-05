import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/cairo_radio_station.dart';
import 'package:siraj/modules/quran/domain/tawasheeh_item.dart';
import 'package:siraj/modules/quran/services/cairo_radio_audio_service.dart';

class MockRadioPlayerAdapter implements RadioAudioPlayerAdapter {
  final List<String> playedUrls = [];
  final List<double> setVolumes = [];
  final List<Duration> seekPositions = [];
  bool isPaused = false;
  bool isStopped = false;
  bool isDisposed = false;
  bool shouldThrowOnFirstUrl = false;

  final _playerStateController = StreamController<PlayerState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration>.broadcast();

  @override
  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;

  @override
  Stream<Duration> get onPositionChanged => _positionController.stream;

  @override
  Stream<Duration> get onDurationChanged => _durationController.stream;

  @override
  Future<void> playUrl(String url) async {
    if (shouldThrowOnFirstUrl && playedUrls.isEmpty) {
      playedUrls.add(url);
      throw Exception('Simulated network connection failure on primary URL');
    }
    playedUrls.add(url);
    isPaused = false;
    isStopped = false;
    _playerStateController.add(PlayerState.playing);
  }

  @override
  Future<void> pause() async {
    isPaused = true;
    _playerStateController.add(PlayerState.paused);
  }

  @override
  Future<void> stop() async {
    isStopped = true;
    _playerStateController.add(PlayerState.stopped);
  }

  @override
  Future<void> seek(Duration position) async {
    seekPositions.add(position);
    _positionController.add(position);
  }

  double playbackRate = 1.0;

  @override
  Future<void> setVolume(double volume) async {
    setVolumes.add(volume);
  }

  @override
  Future<void> setPlaybackRate(double rate) async {
    playbackRate = rate;
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await _playerStateController.close();
    await _positionController.close();
    await _durationController.close();
  }
}

void main() {
  group('Cairo Quran Radio Audio Service Test Suite (§14, §20)', () {
    late MockRadioPlayerAdapter mockAdapter;
    late CairoRadioAudioService radioService;

    setUp(() {
      mockAdapter = MockRadioPlayerAdapter();
      radioService = CairoRadioAudioService(player: mockAdapter);
    });

    tearDown(() async {
      await radioService.dispose();
    });

    test('Plays primary stream URL and transitions to playing state', () async {
      bool playbackStartedCalled = false;
      radioService.onPlaybackStarted = () {
        playbackStartedCalled = true;
      };

      await radioService.play();

      expect(mockAdapter.playedUrls, contains(CairoRadioStation.cairoQuranRadio.primaryStreamUrl));
      expect(radioService.status, equals(CairoRadioStatus.playing));
      expect(radioService.isPlaying, isTrue);
      expect(playbackStartedCalled, isTrue);
    });

    test('Pauses and stops live radio stream cleanly', () async {
      await radioService.play();
      expect(radioService.isPlaying, isTrue);

      await radioService.pause();
      expect(radioService.status, equals(CairoRadioStatus.paused));
      expect(mockAdapter.isPaused, isTrue);

      await radioService.stop();
      expect(radioService.status, equals(CairoRadioStatus.idle));
      expect(mockAdapter.isStopped, isTrue);
    });

    test('Automatic fallback to backup stream URL if primary stream fails', () async {
      mockAdapter.shouldThrowOnFirstUrl = true;

      await radioService.play();

      // Should have attempted primary URL first, then fell back to backup URL
      expect(mockAdapter.playedUrls.length, greaterThanOrEqualTo(2));
      expect(mockAdapter.playedUrls.first, equals(CairoRadioStation.cairoQuranRadio.primaryStreamUrl));
      expect(mockAdapter.playedUrls[1], equals(CairoRadioStation.cairoQuranRadio.backupStreamUrls.first));
      expect(radioService.status, equals(CairoRadioStatus.playing));
    });

    test('Volume control and mute toggle work accurately', () async {
      await radioService.setVolume(0.7);
      expect(radioService.volume, equals(0.7));
      expect(mockAdapter.setVolumes.last, equals(0.7));

      // Mute
      await radioService.toggleMute();
      expect(radioService.isMuted, isTrue);
      expect(radioService.volume, equals(0.0));
      expect(mockAdapter.setVolumes.last, equals(0.0));

      // Unmute restores previous volume
      await radioService.toggleMute();
      expect(radioService.isMuted, isFalse);
      expect(radioService.volume, equals(0.7));
      expect(mockAdapter.setVolumes.last, equals(0.7));
    });

    test('Sleep timer configuration and cancellation work deterministically', () {
      radioService.setSleepTimer(RadioSleepTimerDuration.thirtyMinutes);
      expect(radioService.activeSleepDuration, equals(RadioSleepTimerDuration.thirtyMinutes));
      expect(radioService.sleepTimerRemaining, isNotNull);
      expect(radioService.sleepTimerRemaining!.inMinutes, equals(30));

      // Cancel
      radioService.cancelSleepTimer();
      expect(radioService.activeSleepDuration, equals(RadioSleepTimerDuration.none));
      expect(radioService.sleepTimerRemaining, isNull);
    });

    test('Plays historic Tawasheeh item and updates mode and metadata', () async {
      const item1 = TawasheehItem(
        id: 't1',
        cleanTitle: 'إلهي إن يكن ذنبي عظيما',
        fullTitle: 'إلهي إن يكن ذنبي عظيما - الشيخ محمد عمران',
        reciter: 'محمد عمران',
        duration: '03:59',
        durationSeconds: 239.0,
        url: 'https://archive.org/download/2071215/test1.mp3',
      );
      const item2 = TawasheehItem(
        id: 't2',
        cleanTitle: 'يا مالك الملك',
        fullTitle: 'يا مالك الملك - الشيخ نصر الدين طوبار',
        reciter: 'نصر الدين طوبار',
        duration: '05:30',
        durationSeconds: 330.0,
        url: 'https://archive.org/download/2071215/test2.mp3',
      );

      final playlist = [item1, item2];
      await radioService.playTawasheeh(item1, playlist: playlist);

      expect(radioService.mode, equals(CairoRadioMode.tawasheeh));
      expect(radioService.currentTawasheeh?.id, equals('t1'));
      expect(radioService.status, equals(CairoRadioStatus.playing));
      expect(mockAdapter.playedUrls.last, equals(item1.url));

      // Advance to next Tawasheeh
      await radioService.nextTawasheeh();
      expect(radioService.currentTawasheeh?.id, equals('t2'));
      expect(mockAdapter.playedUrls.last, equals(item2.url));

      // Return to previous Tawasheeh
      await radioService.previousTawasheeh();
      expect(radioService.currentTawasheeh?.id, equals('t1'));
      expect(mockAdapter.playedUrls.last, equals(item1.url));

      // Seek position
      await radioService.seek(const Duration(seconds: 45));
      expect(mockAdapter.seekPositions.last, equals(const Duration(seconds: 45)));

      // Shuffle & Repeat toggle
      expect(radioService.isShuffle, isFalse);
      radioService.toggleShuffle();
      expect(radioService.isShuffle, isTrue);

      expect(radioService.isRepeat, isFalse);
      radioService.toggleRepeat();
      expect(radioService.isRepeat, isTrue);

      // Playback speed control
      expect(radioService.playbackSpeed, equals(1.0));
      await radioService.setPlaybackSpeed(1.5);
      expect(radioService.playbackSpeed, equals(1.5));
      expect(mockAdapter.playbackRate, equals(1.5));
    });
  });
}
