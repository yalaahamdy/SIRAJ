import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/cairo_radio_station.dart';
import 'package:siraj/modules/quran/domain/sharawy_item.dart';
import 'package:siraj/modules/quran/services/cairo_radio_audio_service.dart';
import 'package:siraj/modules/quran/services/sharawy_audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharawyAudioService Audio Engine Tests (§14, §20, §32)', () {
    late MockRadioPlayerAdapter mockAdapter;
    late SharawyAudioService service;

    const sampleItem = SharawyItem(
      id: 'sharawy_0001',
      cleanTitle: 'مقدمات التفسير - الدرس 1',
      fullTitle: 'مقدمات التفسير - الدرس 1',
      surahNumber: 0,
      surahName: 'المقدمات',
      verseRange: 'الدرس 1',
      scholar: 'الشيخ محمد متولي الشعراوي',
      duration: '40:40',
      durationSeconds: 2440.0,
      url: 'https://archive.org/download/000_Intro1.mp3',
      filename: '000_Intro1.mp3',
      sizeBytes: 7322200,
    );

    setUp(() {
      mockAdapter = MockRadioPlayerAdapter();
      service = SharawyAudioService(player: mockAdapter);
    });

    tearDown(() async {
      await service.dispose();
    });

    test('Initializes in idle state', () {
      expect(service.status, equals(SharawyAudioStatus.idle));
      expect(service.currentItem, isNull);
      expect(service.playbackRate, equals(1.0));
    });

    test('Plays item and invokes onPlaybackStarted callback', () async {
      bool playbackStartedCalled = false;
      service.onPlaybackStarted = () {
        playbackStartedCalled = true;
      };

      await service.playItem(sampleItem);

      expect(service.status, equals(SharawyAudioStatus.playing));
      expect(service.currentItem, equals(sampleItem));
      expect(mockAdapter.playedUrls.last, equals(sampleItem.url));
      expect(playbackStartedCalled, isTrue);
    });

    test('Pause and resume update status and player state', () async {
      await service.playItem(sampleItem);
      expect(service.status, equals(SharawyAudioStatus.playing));

      await service.pause();
      expect(service.status, equals(SharawyAudioStatus.paused));
      expect(mockAdapter.isPaused, isTrue);

      await service.resume();
      expect(service.status, equals(SharawyAudioStatus.playing));
    });

    test('Skip forward (+10s) and skip backward (-10s)', () async {
      await service.playItem(sampleItem);
      expect(service.currentPosition, equals(Duration.zero));

      await service.skipForward(const Duration(seconds: 10));
      expect(service.currentPosition, equals(const Duration(seconds: 10)));

      await service.skipForward(const Duration(seconds: 20));
      expect(service.currentPosition, equals(const Duration(seconds: 30)));

      await service.skipBackward(const Duration(seconds: 10));
      expect(service.currentPosition, equals(const Duration(seconds: 20)));

      // Does not skip below zero
      await service.skipBackward(const Duration(seconds: 50));
      expect(service.currentPosition, equals(Duration.zero));
    });

    test('Setting playback rate updates rate across engine', () async {
      await service.setPlaybackRate(1.5);
      expect(service.playbackRate, equals(1.5));
      expect(mockAdapter.playbackRate, equals(1.5));
    });

    test('Sleep timer initializes with target time and cancels cleanly', () {
      service.setSleepTimer(RadioSleepTimerDuration.thirtyMinutes);

      expect(service.activeSleepDuration, equals(RadioSleepTimerDuration.thirtyMinutes));
      expect(service.sleepTargetTime, isNotNull);
      expect(service.sleepTimerRemaining, isNotNull);
      expect(service.sleepTimerRemaining!.inMinutes, equals(30));

      service.cancelSleepTimer();
      expect(service.activeSleepDuration, equals(RadioSleepTimerDuration.none));
      expect(service.sleepTargetTime, isNull);
      expect(service.sleepTimerRemaining, isNull);
    });

    test('forceSleepStop halts audio, mutes volume, resets status, and calls callback', () async {
      bool callbackFired = false;
      service.onSleepTimerCompleted = () {
        callbackFired = true;
      };

      await service.playItem(sampleItem);
      expect(service.status, equals(SharawyAudioStatus.playing));

      await service.forceSleepStop();

      expect(service.status, equals(SharawyAudioStatus.idle));
      expect(mockAdapter.isStopped, isTrue);
      expect(mockAdapter.setVolumes.last, equals(0.0));
      expect(callbackFired, isTrue);
    });
  });
}
