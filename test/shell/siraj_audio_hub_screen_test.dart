import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/domain/tawasheeh_item.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/modules/quran/store/tawasheeh_store.dart';
import 'package:siraj/shell/audio/siraj_audio_hub_screen.dart';
import 'package:siraj/shell/quran/widgets/cairo_radio_live_view.dart';
import 'package:siraj/shell/quran/widgets/quran_audio_radio_tab.dart';
import 'package:siraj/shell/quran/widgets/sharawy_player_view.dart';
import 'package:siraj/shell/quran/widgets/tawasheeh_player_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SirajAudioHubScreen — Independent Audio Studio Hub Tests', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() async {
      storage = MemoryStorageRegistry();
      final package = await CanonicalQuranLoader.loadPackage();
      quranModule = QuranModule(storageRegistry: storage);
      quranModule.mountPackage(package);
    });

    testWidgets('Renders AppBar and all 4 audio hub tabs', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: SirajAudioHubScreen(
              quranModule: quranModule,
              onOpenSurah: (surah, {targetAyah, targetPage}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Screen Title
      expect(find.text('الصوتيات'), findsOneWidget);

      // Verify all 4 tab headers
      expect(find.text('إذاعة القاهرة'), findsOneWidget);
      expect(find.text('التواشيح'), findsOneWidget);
      expect(find.text('خواطر الشعراوي'), findsOneWidget);
      expect(find.text('التلاوة'), findsOneWidget);

      // By default, first tab (إذاعة القاهرة) is active
      expect(find.byType(CairoRadioLiveView), findsOneWidget);
    });

    testWidgets('Switching tabs displays respective audio subviews', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: SirajAudioHubScreen(
              quranModule: quranModule,
              onOpenSurah: (surah, {targetAyah, targetPage}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Switch to Tab 1: التواشيح
      await tester.tap(find.text('التواشيح'));
      await tester.pumpAndSettle();
      expect(find.byType(TawasheehPlayerView), findsOneWidget);

      // Switch to Tab 2: خواطر الشعراوي
      await tester.tap(find.text('خواطر الشعراوي'));
      await tester.pumpAndSettle();
      expect(find.byType(SharawyPlayerView), findsOneWidget);

      // Switch to Tab 3: التلاوة
      await tester.tap(find.text('التلاوة'));
      await tester.pumpAndSettle();
      expect(find.byType(QuranAudioRadioTab), findsOneWidget);
    });

    testWidgets('Programmatic switching via switchToTab works seamlessly', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final hubKey = GlobalKey<SirajAudioHubScreenState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: SirajAudioHubScreen(
              key: hubKey,
              quranModule: quranModule,
              onOpenSurah: (surah, {targetAyah, targetPage}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CairoRadioLiveView), findsOneWidget);

      // Programmatically switch to Tab 2 (خواطر الشعراوي)
      hubKey.currentState?.switchToTab(2);
      await tester.pumpAndSettle();

      expect(find.byType(SharawyPlayerView), findsOneWidget);
    });

    testWidgets('Honors initialTabIndex constructor parameter', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: SirajAudioHubScreen(
              initialTabIndex: 1, // التواشيح
              quranModule: quranModule,
              onOpenSurah: (surah, {targetAyah, targetPage}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TawasheehPlayerView), findsOneWidget);
    });

    testWidgets('Displays Tawasheeh items when store is loaded', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final customStore = TawasheehStore();
      await customStore.load(
        initialItems: const [
          TawasheehItem(
            id: 'sample_01',
            cleanTitle: 'ابتهال نادر',
            fullTitle: 'ابتهال نادر للشيخ سيد النقشبندي',
            reciter: 'سيد النقشبندي',
            duration: '05:00',
            durationSeconds: 300,
            url: 'https://example.com/test.mp3',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: SirajAudioHubScreen(
              initialTabIndex: 1,
              tawasheehStore: customStore,
              quranModule: quranModule,
              onOpenSurah: (surah, {targetAyah, targetPage}) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TawasheehPlayerView), findsOneWidget);
      expect(customStore.isLoaded, isTrue);
      expect(customStore.allItems.isNotEmpty, isTrue);
    });
  });
}
