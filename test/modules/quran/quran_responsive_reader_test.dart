import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/modules/quran/recitation/services/quran_recitation_recorder.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/theme/app_theme.dart';

class _MockAudioRecorderAdapter implements AudioRecorderAdapter {
  @override
  Future<bool> hasPermission() async => true;
  @override
  Future<bool> isRecording() async => false;
  @override
  Future<void> start({required String path}) async {}
  @override
  Future<String?> stop() async => '/mock/recitation.m4a';
  @override
  Future<void> pause() async {}
  @override
  Future<void> resume() async {}
  @override
  void dispose() {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranModule quranModule;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    quranModule = QuranModule(storageRegistry: MemoryStorageRegistry());
    quranModule.mountPackage(package);
  });

  group('M02 Quran Reader Responsive & Zero Overflow Tests', () {
    final viewports = [
      const Size(320, 568), // Compact phone
      const Size(360, 800), // Standard Android
      const Size(412, 915), // Flagship Android
      const Size(768, 1024), // Tablet portrait
      const Size(1024, 768), // Tablet landscape
    ];

    for (final size in viewports) {
      testWidgets('Zero overflow on viewport ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(),
            home: QuranReaderScreen(
              quranModule: quranModule,
              initialSurahNumber: 1,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.textContaining('سورة الفاتحة'), findsWidgets);
      });
    }

    testWidgets('Recitation recording bar has zero overflow on 320px compact phone', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockRecorder = QuranRecitationRecorder(adapter: _MockAudioRecorderAdapter());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
            recorder: mockRecorder,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open Recitation Hub
      final micButton = find.byTooltip('التسميع والحفظ');
      expect(micButton, findsOneWidget);
      await tester.tap(micButton);
      await tester.pumpAndSettle();

      // Tap start recitation
      final startBtn = find.text('ابدأ التسميع الآن');
      expect(startBtn, findsOneWidget);
      await tester.tap(startBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('إيقاف وحفظ'), findsOneWidget);

      // Stop recording to check completed bar
      await tester.tap(find.text('إيقاف وحفظ'));
      await tester.pumpAndSettle();

      // Check zero overflow and rich audio playback controls on completed bar on 320px
      expect(tester.takeException(), isNull);
      expect(find.text('إنهاء'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);
      expect(find.byTooltip('ترجيع 5 ثوانٍ'), findsOneWidget);
      expect(find.byTooltip('إعادة التسجيل'), findsOneWidget);
    });
  });
}
