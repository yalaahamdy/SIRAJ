import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/notifications/siraj_media_notification_service.dart';

void main() {
  group('SirajMediaNotificationService Test Suite (§14, §20, §32)', () {
    late SirajMediaNotificationService service;

    setUp(() {
      service = SirajMediaNotificationService();
    });

    tearDown(() async {
      await service.cancelMediaNotification();
    });

    test('Shows media notification for Cairo Radio and tracks state accurately', () async {
      await service.showMediaNotification(
        title: 'إذاعة القرآن الكريم من القاهرة',
        subtitle: 'البث الحي 98.2 FM',
        isPlaying: true,
        type: SirajMediaType.cairoRadio,
      );

      expect(service.isShowing, isTrue);
      expect(service.lastTitle, equals('إذاعة القرآن الكريم من القاهرة'));
      expect(service.lastSubtitle, equals('البث الحي 98.2 FM'));
      expect(service.lastIsPlaying, isTrue);
      expect(service.lastType, equals(SirajMediaType.cairoRadio));
    });

    test('Shows media notification for Tawasheeh and Quran recitation', () async {
      await service.showMediaNotification(
        title: 'ابتهال: يا مالك الملك',
        subtitle: 'الشيخ نصر الدين طوبار',
        isPlaying: false,
        type: SirajMediaType.tawasheeh,
        hasNext: true,
        hasPrevious: true,
      );

      expect(service.isShowing, isTrue);
      expect(service.lastTitle, equals('ابتهال: يا مالك الملك'));
      expect(service.lastIsPlaying, isFalse);
      expect(service.lastType, equals(SirajMediaType.tawasheeh));

      // Update to Quran recitation
      await service.showMediaNotification(
        title: 'سورة الفاتحة — الآية 1',
        subtitle: 'الشيخ عبد الباسط عبد الصمد',
        isPlaying: true,
        type: SirajMediaType.quranRecitation,
      );

      expect(service.lastTitle, equals('سورة الفاتحة — الآية 1'));
      expect(service.lastType, equals(SirajMediaType.quranRecitation));
    });

    test('Dispatches transport control actions to registered callbacks cleanly', () {
      bool playPauseCalled = false;
      bool nextCalled = false;
      bool previousCalled = false;
      bool stopCalled = false;

      service.onPlayPause = () => playPauseCalled = true;
      service.onNext = () => nextCalled = true;
      service.onPrevious = () => previousCalled = true;
      service.onStop = () => stopCalled = true;

      service.handleAction(SirajMediaNotificationService.actionPlayPause);
      expect(playPauseCalled, isTrue);

      service.handleAction(SirajMediaNotificationService.actionNext);
      expect(nextCalled, isTrue);

      service.handleAction(SirajMediaNotificationService.actionPrevious);
      expect(previousCalled, isTrue);

      service.handleAction(SirajMediaNotificationService.actionStop);
      expect(stopCalled, isTrue);
      expect(service.isShowing, isFalse);
    });

    test('Dispatches actions to registered delegate with priority over global callbacks', () {
      final mockDelegate = _TestDelegate();
      service.registerDelegate(SirajMediaType.sharawyKhawatir, mockDelegate);

      bool globalPlayPauseCalled = false;
      service.onPlayPause = () => globalPlayPauseCalled = true;

      // Simulate notification shown for Sharawy
      service.showMediaNotification(
        title: 'خواطر الشيخ الشعراوي',
        subtitle: 'تفسير سورة البقرة',
        isPlaying: true,
        type: SirajMediaType.sharawyKhawatir,
        position: const Duration(minutes: 5),
        duration: const Duration(minutes: 30),
      );

      service.handleAction(SirajMediaNotificationService.actionPlayPause);
      expect(mockDelegate.playPauseCount, equals(1));
      expect(globalPlayPauseCalled, isFalse); // Delegate took precedence

      service.handleAction(SirajMediaNotificationService.actionSkipForward);
      expect(mockDelegate.skipForwardCount, equals(1));

      service.handleAction(SirajMediaNotificationService.actionSkipBackward);
      expect(mockDelegate.skipBackwardCount, equals(1));

      service.handleAction(SirajMediaNotificationService.actionNext);
      expect(mockDelegate.nextCount, equals(1));

      service.handleAction(SirajMediaNotificationService.actionPrevious);
      expect(mockDelegate.prevCount, equals(1));

      service.handleAction(SirajMediaNotificationService.actionStop);
      expect(mockDelegate.stopCount, equals(1));
      expect(service.isShowing, isFalse);
    });

    test('Cancels media notification and resets state', () async {
      await service.showMediaNotification(
        title: 'إذاعة القرآن الكريم',
        subtitle: 'مباشر',
        isPlaying: true,
        type: SirajMediaType.cairoRadio,
      );
      expect(service.isShowing, isTrue);

      await service.cancelMediaNotification();
      expect(service.isShowing, isFalse);
      expect(service.lastTitle, isNull);
      expect(service.lastSubtitle, isNull);
      expect(service.lastIsPlaying, isNull);
    });
  });
}

class _TestDelegate implements SirajMediaNotificationDelegate {
  int playPauseCount = 0;
  int nextCount = 0;
  int prevCount = 0;
  int skipForwardCount = 0;
  int skipBackwardCount = 0;
  int stopCount = 0;

  @override
  void onPlayPause() => playPauseCount++;

  @override
  void onNext() => nextCount++;

  @override
  void onPrevious() => prevCount++;

  @override
  void onSkipForward() => skipForwardCount++;

  @override
  void onSkipBackward() => skipBackwardCount++;

  @override
  void onStop() => stopCount++;
}
