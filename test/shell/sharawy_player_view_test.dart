import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/sharawy_item.dart';
import 'package:siraj/modules/quran/services/cairo_radio_audio_service.dart';
import 'package:siraj/modules/quran/services/sharawy_audio_service.dart';
import 'package:siraj/modules/quran/store/sharawy_store.dart';
import 'package:siraj/shell/quran/widgets/sharawy_player_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SharawyPlayerView Widget Tests (§14, §20, §32)', () {
    late MockRadioPlayerAdapter mockAdapter;
    late SharawyAudioService audioService;
    late SharawyStore store;

    final sampleItems = [
      const SharawyItem(
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
      ),
      const SharawyItem(
        id: 'sharawy_0005',
        cleanTitle: 'سورة الفاتحة - الآية 1',
        fullTitle: 'سورة الفاتحة - الآية 1',
        surahNumber: 1,
        surahName: 'الفاتحة',
        verseRange: 'الآية 1',
        scholar: 'الشيخ محمد متولي الشعراوي',
        duration: '20:25',
        durationSeconds: 1225.0,
        url: 'https://archive.org/download/001_Al-Fatihah_001.mp3',
        filename: '001_Al-Fatihah_001.mp3',
        sizeBytes: 3675932,
      ),
      const SharawyItem(
        id: 'sharawy_0009',
        cleanTitle: 'سورة البقرة - الآيات 6-16',
        fullTitle: 'سورة البقرة - الآيات 6-16',
        surahNumber: 2,
        surahName: 'البقرة',
        verseRange: 'الآيات 6-16',
        scholar: 'الشيخ محمد متولي الشعراوي',
        duration: '40:03',
        durationSeconds: 2403.0,
        url: 'https://archive.org/download/002_Al-Baqarah(006_016).mp3',
        filename: '002_Al-Baqarah(006_016).mp3',
        sizeBytes: 7210800,
      ),
    ];

    setUp(() async {
      mockAdapter = MockRadioPlayerAdapter();
      audioService = SharawyAudioService(player: mockAdapter);
      store = SharawyStore();
      await store.load(initialItems: sampleItems);
    });

    tearDown(() async {
      await audioService.dispose();
    });

    testWidgets('Renders hero card, search input, chips, and episode list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SharawyPlayerView(
              audioService: audioService,
              sharawyStore: store,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Hero identity card
      expect(find.text('فضيلة الشيخ محمد متولي الشعراوي'), findsOneWidget);
      expect(find.text('إمام الدعاة • خواطر التفسير'), findsOneWidget);

      // Search hint
      expect(find.text('ابحث في خواطر وتفسير الشيخ الشعراوي...'), findsOneWidget);

      // Categories
      expect(find.text('الكل'), findsOneWidget);
      expect(find.text('المفضلة'), findsOneWidget);
      expect(find.text('التنزيلات'), findsOneWidget);

      // Episodes list
      expect(find.text('مقدمات التفسير - الدرس 1'), findsOneWidget);
      expect(find.text('سورة الفاتحة - الآية 1'), findsOneWidget);
    });

    testWidgets('Tapping an episode starts audio playback and reveals player controls', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SharawyPlayerView(
              audioService: audioService,
              sharawyStore: store,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on the first episode
      await tester.tap(find.text('مقدمات التفسير - الدرس 1'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(audioService.currentItem?.id, equals('sharawy_0001'));

      // Player transport buttons should appear
      expect(find.byIcon(Icons.replay_10_rounded), findsOneWidget);
      expect(find.byIcon(Icons.forward_10_rounded), findsOneWidget);
      expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
    });

    testWidgets('Zero overflow with large text scale 1.5x', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.5),
              ),
              child: child!,
            );
          },
          home: Scaffold(
            body: SharawyPlayerView(
              audioService: audioService,
              sharawyStore: store,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
