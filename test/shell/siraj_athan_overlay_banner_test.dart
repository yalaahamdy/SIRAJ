import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/prayer/domain/athan_sound_option.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/services/athan_audio_service.dart';
import 'package:siraj/shell/prayer/widgets/siraj_athan_overlay_banner.dart';
import 'package:siraj/shell/prayer/screens/siraj_athan_full_screen_view.dart';

void main() {
  group('SirajAthanOverlayBanner Widget Tests (§17, §32)', () {
    late AthanAudioService mockAudioService;

    setUp(() {
      mockAudioService = AthanAudioService.mock();
    });

    testWidgets('Renders prayer title, time, and location in overlay banner', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirajAthanOverlayBanner(
              prayerType: PrayerType.maghrib,
              prayerTime: DateTime(2026, 9, 8, 18, 15),
              locationName: 'القاهرة، مصر',
              audioService: mockAudioService,
              onDismiss: () {},
            ),
          ),
        ),
      );

      expect(find.textContaining('صلاة المغرب'), findsOneWidget);
      expect(find.textContaining('القاهرة، مصر'), findsOneWidget);
      expect(find.text('إيقاف'), findsOneWidget);
      expect(find.text('تأجيل 5د'), findsOneWidget);
      expect(find.text('الشاشة كاملة'), findsOneWidget);
    });

    testWidgets('Tapping stop halts audio playback and dismisses banner', (tester) async {
      await mockAudioService.playAthan(soundOption: AthanSoundOption.abdulbasit);
      expect(mockAudioService.isPlaying, isTrue);

      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirajAthanOverlayBanner(
              prayerType: PrayerType.fajr,
              prayerTime: DateTime(2026, 9, 8, 4, 30),
              locationName: 'مكة المكرمة',
              audioService: mockAudioService,
              onDismiss: () {
                dismissed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('إيقاف'));
      await tester.pump();

      expect(mockAudioService.isPlaying, isFalse);
      expect(dismissed, isTrue);
    });

    testWidgets('Tapping snooze invokes onSnooze and dismisses banner', (tester) async {
      bool snoozeCalled = false;
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirajAthanOverlayBanner(
              prayerType: PrayerType.isha,
              prayerTime: DateTime(2026, 9, 8, 20, 0),
              locationName: 'الإسكندرية، مصر',
              audioService: mockAudioService,
              onDismiss: () => dismissed = true,
              onSnooze: () => snoozeCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('تأجيل 5د'));
      await tester.pump();

      expect(snoozeCalled, isTrue);
      expect(dismissed, isTrue);
    });

    testWidgets('Tapping full screen button navigates to SirajAthanFullScreenView', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SirajAthanOverlayBanner(
              prayerType: PrayerType.dhuhr,
              prayerTime: DateTime(2026, 9, 8, 12, 0),
              locationName: 'المدينة المنورة',
              audioService: mockAudioService,
              onDismiss: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('الشاشة كاملة'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(SirajAthanFullScreenView), findsOneWidget);
      expect(find.text('صلاة الظهر'), findsOneWidget);
    });
  });
}
