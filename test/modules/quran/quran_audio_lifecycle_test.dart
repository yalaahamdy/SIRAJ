import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/services/quran_audio_service.dart';
import 'package:siraj/shell/quran/widgets/quran_mini_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M02.1 Quran Audio Lifecycle & MiniPlayer Tests (§17, §18)', () {
    testWidgets('QuranMiniPlayer renders only when audio is active and triggers playback controls', (tester) async {
      bool playPauseCalled = false;
      bool nextCalled = false;
      bool previousCalled = false;
      bool stopCalled = false;

      const activeReport = AudioPlaybackReport(
        status: AudioPlaybackStatus.playing,
        surahNumber: 1,
        ayahNumber: 2,
        reciterName: 'مشاري راشد العفاسي',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMiniPlayer(
              report: activeReport,
              surahNameArabic: 'الفاتحة',
              onPlayPause: () => playPauseCalled = true,
              onNext: () => nextCalled = true,
              onPrevious: () => previousCalled = true,
              onStop: () => stopCalled = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Mini-player elements visible
      expect(find.text('سورة الفاتحة • الآية 2'), findsOneWidget);
      expect(find.text('مشاري راشد العفاسي'), findsOneWidget);

      // Play/Pause button
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.pause_rounded));
      expect(playPauseCalled, isTrue);

      // Next / Previous
      await tester.tap(find.byIcon(Icons.skip_next_rounded));
      expect(nextCalled, isTrue);

      await tester.tap(find.byIcon(Icons.skip_previous_rounded));
      expect(previousCalled, isTrue);

      // Stop
      await tester.tap(find.byIcon(Icons.close_rounded));
      expect(stopCalled, isTrue);
    });
  });
}
