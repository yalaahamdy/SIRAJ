import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/prayer/domain/athan_sound_option.dart';
import 'package:siraj/modules/prayer/domain/prayer_type.dart';
import 'package:siraj/modules/prayer/services/athan_audio_service.dart';
import 'package:siraj/shell/prayer/screens/siraj_athan_full_screen_view.dart';

void main() {
  group('SirajAthanFullScreenView Widget Tests (§17, §32)', () {
    late AthanAudioService mockAudioService;

    setUp(() {
      mockAudioService = AthanAudioService.mock();
    });

    testWidgets('Renders all spiritual UI elements, title, and duaa correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SirajAthanFullScreenView(
            prayerType: PrayerType.fajr,
            prayerTime: DateTime(2026, 9, 6, 4, 30),
            locationName: 'القاهرة، مصر',
            audioService: mockAudioService,
          ),
        ),
      );

      // Verify title, location, tribute, and Du'aa
      expect(find.text('صلاة الفجر'), findsOneWidget);
      expect(find.text('القاهرة، مصر'), findsOneWidget);
      expect(find.textContaining('الشيخ عبد الباسط عبد الصمد'), findsOneWidget);
      expect(find.text('دعاء ما بعد الأذان'), findsOneWidget);
      expect(find.textContaining('اللَّهُمَّ رَبَّ هَذِهِ الدَّعْوَةِ التَّامَّةِ'), findsOneWidget);

      // Verify action buttons
      expect(find.text('إيقاف الأذان'), findsOneWidget);
      expect(find.text('أديت الصلاة'), findsOneWidget);
    });

    testWidgets('Tapping stop athan button halts audio playback', (tester) async {
      await mockAudioService.playAthan(soundOption: AthanSoundOption.abdulbasit);
      expect(mockAudioService.isPlaying, isTrue);

      await tester.pumpWidget(
        MaterialApp(
          home: SirajAthanFullScreenView(
            prayerType: PrayerType.dhuhr,
            prayerTime: DateTime(2026, 9, 6, 12, 0),
            locationName: 'مكة المكرمة',
            audioService: mockAudioService,
          ),
        ),
      );

      await tester.tap(find.text('إيقاف الأذان'));
      await tester.pump();

      expect(mockAudioService.isPlaying, isFalse);
    });

    testWidgets('Tapping prayed button invokes onMarkPrayed callback and stops athan', (tester) async {
      bool markPrayedCalled = false;
      await mockAudioService.playAthan(soundOption: AthanSoundOption.abdulbasit);

      await tester.pumpWidget(
        MaterialApp(
          home: SirajAthanFullScreenView(
            prayerType: PrayerType.maghrib,
            prayerTime: DateTime(2026, 9, 6, 18, 15),
            locationName: 'المدينة المنورة',
            audioService: mockAudioService,
            onMarkPrayed: () {
              markPrayedCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('أديت الصلاة'));
      await tester.pump();

      expect(mockAudioService.isPlaying, isFalse);
      expect(markPrayedCalled, isTrue);
    });
  });
}
