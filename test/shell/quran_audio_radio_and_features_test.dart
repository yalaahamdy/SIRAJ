import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/quran_reciter.dart';
import 'package:siraj/modules/quran/domain/surah.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/services/quran_audio_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/quran/surah_list_screen.dart';
import 'package:siraj/shell/quran/widgets/quran_audio_radio_tab.dart';
import 'package:siraj/shell/quran/widgets/quran_settings_tab.dart';
import 'package:siraj/shell/quran/widgets/surah_header_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranModule quranModule;
  late List<Surah> surahs;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    quranModule = QuranModule(
      storageRegistry: MemoryStorageRegistry(),
    );
    quranModule.mountPackage(package);
    surahs = quranModule.getAllSurahs().valueOrNull ?? [];
  });

  group('Quran Audio Radio & Recitation Features Tests', () {
    test('Default reciter is Sheikh Abdul Basit Abdul Samad with local path candidate', () {
      expect(kDefaultAbdulBasitReciter.nameArabic, contains('عبد الباسط عبد الصمد'));
      expect(kDefaultAbdulBasitReciter.isDefault, isTrue);

      final audioService = QuranAudioService(store: quranModule.store);
      expect(audioService.activeReciter.nameArabic, contains('عبد الباسط عبد الصمد'));

      // Check candidate URIs resolution for Surah 1 Ayah 1
      final uris = kDefaultAbdulBasitReciter.resolveCandidateUris(1, 1);
      expect(uris.any((u) => u.contains('001001.mp3')), isTrue);
      expect(uris.any((u) => u.contains('عبد الباسط عبد الصمد')), isTrue);
    });

    test('QuranAudioService supports speed adjustment up to 2.0x', () async {
      final mockAdapter = MockAudioPlayerAdapter();
      final audioService = QuranAudioService(
        store: quranModule.store,
        player: mockAdapter,
      );

      expect(audioService.playbackSpeed, equals(1.0));
      await audioService.setPlaybackSpeed(1.5);
      expect(audioService.playbackSpeed, equals(1.5));
      expect(mockAdapter.playbackRate, equals(1.5));

      await audioService.setPlaybackSpeed(2.0);
      expect(audioService.playbackSpeed, equals(2.0));
      expect(mockAdapter.playbackRate, equals(2.0));
    });

    testWidgets('SurahHeaderCard renders with full width (double.infinity)', (tester) async {
      final fatihah = surahs.first;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SurahHeaderCard(surah: fatihah),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining(fatihah.nameArabic), findsOneWidget);
      expect(find.byType(SurahHeaderCard), findsOneWidget);

      final containerFinder = find.descendant(
        of: find.byType(SurahHeaderCard),
        matching: find.byType(Container),
      ).first;
      final container = tester.widget<Container>(containerFinder);
      final constraints = container.constraints;
      expect(constraints?.minWidth == double.infinity || container.margin?.horizontal == 0, isTrue);
    });

    testWidgets('SurahListScreen includes the new Radio and Recitation sub-tab', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SurahListScreen(
            quranModule: quranModule,
            onOpenSurah: (s, {targetAyah, targetPage}) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check the 4 tabs exist
      expect(find.text('السور'), findsOneWidget);
      expect(find.text('التلاوة'), findsOneWidget);
      expect(find.text('الأجزاء'), findsOneWidget);
      expect(find.text('الإعدادات'), findsOneWidget);

      // Switch to Radio tab
      await tester.tap(find.text('التلاوة'));
      await tester.pumpAndSettle();

      expect(find.byType(QuranAudioRadioTab), findsOneWidget);
      expect(find.text(kDefaultAbdulBasitReciter.nameArabic), findsWidgets);

      // Switch to Settings tab
      await tester.tap(find.text('الإعدادات'));
      await tester.pumpAndSettle();

      expect(find.byType(QuranSettingsTab), findsOneWidget);
      expect(find.text('وضع القراءة'), findsOneWidget);
      expect(find.text('السمة البصرية للمصحف'), findsOneWidget);
    });
  });
}
