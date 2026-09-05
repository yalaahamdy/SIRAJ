import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/tawasheeh_item.dart';
import 'package:siraj/modules/quran/services/cairo_radio_audio_service.dart';
import 'package:siraj/modules/quran/services/tawasheeh_offline_audio_service.dart';
import 'package:siraj/modules/quran/store/tawasheeh_store.dart';
import 'package:siraj/shell/quran/widgets/cairo_radio_live_view.dart';
import 'package:siraj/shell/quran/widgets/tawasheeh_player_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final sampleItems = [
    const TawasheehItem(
      id: 'tawasheeh_001',
      cleanTitle: 'ابتهال: إلهى . إن يكن ذنبى عظيما',
      fullTitle: 'إبتهال 270214 // إلهى . إن يكن ذنبى عظيما // محمد عمران',
      reciter: 'محمد عمران',
      duration: '03:59',
      durationSeconds: 239.39,
      url: 'https://archive.org/download/2071215/sample1.mp3',
    ),
    const TawasheehItem(
      id: 'tawasheeh_002',
      cleanTitle: 'يا مالك الملك ورب الأرباب',
      fullTitle: 'يا مالك الملك - الشيخ نصر الدين طوبار',
      reciter: 'نصر الدين طوبار',
      duration: '06:12',
      durationSeconds: 372.0,
      url: 'https://archive.org/download/2071215/sample2.mp3',
    ),
  ];

  group('Cairo Radio & Tawasheeh Live View UI Tests (§14, §20)', () {
    late CairoRadioAudioService radioService;
    late TawasheehStore tawasheehStore;

    setUp(() async {
      await TawasheehOfflineAudioService.instance.init(
        overrideBasePath: Directory.systemTemp.path,
      );
      radioService = CairoRadioAudioService();
      tawasheehStore = TawasheehStore();
      await tawasheehStore.load(initialItems: sampleItems);
    });

    tearDown(() async {
      await radioService.dispose();
    });

    testWidgets('Renders mode switcher and defaults to Live Radio view', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CairoRadioLiveView(
              radioService: radioService,
              tawasheehStore: tawasheehStore,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      // Check mode switcher exists
      expect(find.text('إذاعة القاهرة (FM 98.2)'), findsOneWidget);
      expect(find.text('تواشيح كبار المبتهلين (2)'), findsOneWidget);

      // Check Live Radio Hero elements exist
      expect(find.text('FM 98.2 MHz'), findsOneWidget);
      expect(find.text('إذاعة القرآن الكريم من القاهرة'), findsOneWidget);
      expect(find.text('مؤقت النوم (إيقاف تلقائي للبث)'), findsOneWidget);
    });

    testWidgets('Switches to Tawasheeh mode and renders player and recordings catalog', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CairoRadioLiveView(
              radioService: radioService,
              tawasheehStore: tawasheehStore,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      // Tap on Tawasheeh tab
      await tester.tap(find.text('تواشيح كبار المبتهلين (2)'));
      await tester.pump(const Duration(milliseconds: 300));

      // Expect TawasheehPlayerView to be rendered
      expect(find.byType(TawasheehPlayerView), findsOneWidget);
      expect(find.text('ابتهالات وتواشيح نادرة'), findsOneWidget);
      expect(find.text('عرض 2 تسجيلاً نادراً'), findsOneWidget);
      expect(find.text('ابتهال: إلهى . إن يكن ذنبى عظيما'), findsOneWidget);
      expect(find.text('يا مالك الملك ورب الأرباب'), findsOneWidget);

      // Tap on first recording to trigger playback
      await tester.tap(find.text('ابتهال: إلهى . إن يكن ذنبى عظيما'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(radioService.currentTawasheeh?.id, equals('tawasheeh_001'));
      expect(radioService.isPlaying, isTrue);
    });
  });
}
