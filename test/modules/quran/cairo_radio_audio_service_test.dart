import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/cairo_radio_station.dart';
import 'package:siraj/modules/quran/services/cairo_radio_audio_service.dart';

class MockRadioPlayerAdapter implements RadioAudioPlayerAdapter {
  final List<String> playedUrls = [];
  final List<double> setVolumes = [];
  bool isPaused = false;
  bool isStopped = false;
  bool isDisposed = false;
  bool shouldThrowOnFirstUrl = false;

  final _playerStateController = StreamController<PlayerState>.broadcast();

  @override
  Stream<PlayerState> get onPlayerStateChanged => _playerStateController.stream;

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
  Future<void> setVolume(double volume) async {
    setVolumes.add(volume);
  }

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await _playerStateController.close();
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
  });
}
