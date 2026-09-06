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
  Future<void> resume() async {
    isPaused = false;
    _playerStateController.add(PlayerState.playing);
  }

  @override
  Future<void> stop() async {
    isStopped = true;
    _playerStateController.add(PlayerState.stopped);
  }

  @override
  Future<void> seek(Duration position) async {
    _positionController.add(position);
  }

  @override
  Future<void> setVolume(double volume) async {
    setVolumes.add(volume);
  }

  @override
  Future<void> setPlaybackRate(double rate) async {}

  @override
  Future<void> dispose() async {
    isDisposed = true;
    await _playerStateController.close();
    await _positionController.close();
    await _durationController.close();
  }
}

void main() {
  group('Cairo Radio & Tawasheeh Sleep Timer Engine Tests (§14, §20)', () {
    late MockRadioPlayerAdapter mockAdapter;
    late CairoRadioAudioService radioService;

    setUp(() {
      mockAdapter = MockRadioPlayerAdapter();
      radioService = CairoRadioAudioService(player: mockAdapter);
    });

    tearDown(() async {
      await radioService.dispose();
    });

    test('Initializes and computes absolute target time accurately', () {
      final before = DateTime.now();
      radioService.setSleepTimer(RadioSleepTimerDuration.fifteenMinutes);
      final after = DateTime.now();

      expect(radioService.activeSleepDuration, equals(RadioSleepTimerDuration.fifteenMinutes));
      expect(radioService.sleepTimerRemaining, isNotNull);
      expect(radioService.sleepTimerRemaining!.inMinutes, equals(15));
      expect(radioService.sleepTargetTime, isNotNull);
      expect(radioService.sleepTargetTime!.isAfter(before.add(const Duration(minutes: 14, seconds: 50))), isTrue);
      expect(radioService.sleepTargetTime!.isBefore(after.add(const Duration(minutes: 15, seconds: 5))), isTrue);
    });

    test('Cancellation clears all state and streams null', () {
      radioService.setSleepTimer(RadioSleepTimerDuration.thirtyMinutes);
      expect(radioService.activeSleepDuration, equals(RadioSleepTimerDuration.thirtyMinutes));

      radioService.cancelSleepTimer();
      expect(radioService.activeSleepDuration, equals(RadioSleepTimerDuration.none));
      expect(radioService.sleepTimerRemaining, isNull);
      expect(radioService.sleepTargetTime, isNull);
    });

    test('forceSleepStop halts playback, mutes volume, resets status, and calls callback', () async {
      bool callbackFired = false;
      radioService.onSleepTimerCompleted = () {
        callbackFired = true;
      };

      await radioService.play();
      expect(radioService.status, equals(CairoRadioStatus.playing));

      await radioService.forceSleepStop();

      expect(radioService.status, equals(CairoRadioStatus.idle));
      expect(mockAdapter.isStopped, isTrue);
      expect(mockAdapter.setVolumes.last, equals(0.0));
      expect(callbackFired, isTrue);
    });

    test('checkSleepTimer triggers hard shutdown when target time has passed', () async {
      bool callbackFired = false;
      radioService.onSleepTimerCompleted = () {
        callbackFired = true;
      };

      await radioService.play();
      expect(radioService.status, equals(CairoRadioStatus.playing));

      // Configure a custom timer with a zero duration to simulate expiration
      radioService.setCustomSleepTimer(Duration.zero);

      // Trigger check
      await radioService.checkSleepTimer();

      expect(radioService.status, equals(CairoRadioStatus.idle));
      expect(radioService.activeSleepDuration, equals(RadioSleepTimerDuration.none));
      expect(radioService.sleepTimerRemaining, isNull);
      expect(mockAdapter.isStopped, isTrue);
      expect(mockAdapter.setVolumes.last, equals(0.0));
      expect(callbackFired, isTrue);
    });
  });
}
