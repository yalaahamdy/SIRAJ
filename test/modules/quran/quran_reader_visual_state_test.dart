import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/services/quran_audio_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/modules/quran/store/canonical_quran_package.dart';
import 'package:siraj/modules/quran/store/canonical_quran_store.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/widgets/ayah_action_toolbar.dart';
import 'package:siraj/shell/quran/widgets/quran_mini_player.dart';
import 'package:siraj/shell/quran/widgets/quran_mushaf_flow_view.dart';
import 'package:siraj/shell/quran/widgets/surah_header_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranModule quranModule;
  late MockAudioPlayerAdapter mockPlayer;
  late CanonicalQuranPackage package;

  setUpAll(() async {
    package = await CanonicalQuranLoader.loadPackage();
  });

  setUp(() {
    mockPlayer = MockAudioPlayerAdapter();
    final store = ReadOnlyCanonicalQuranStore();
    store.mountPackage(package);
    final audioService = QuranAudioService(store: store, player: mockPlayer);

    quranModule = QuranModule(
      storageRegistry: MemoryStorageRegistry(),
      storeInstance: store,
      audioServiceInstance: audioService,
    );
  });

  group('M02.1 Complete Visual Reader State Tests (§1, §4, §17)', () {
    testWidgets('Reader displays header and continuous mushaf flow without permanent bottom bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header card exists
      expect(find.byType(SurahHeaderCard), findsOneWidget);

      // Mushaf flow view exists
      expect(find.byType(QuranMushafFlowView), findsOneWidget);

      // No mini-toolbar or mini-player initially
      expect(find.byType(AyahActionToolbar), findsNothing);
      expect(find.byType(QuranMiniPlayer), findsNothing);
    });

    testWidgets('Audio playback reveals floating MiniPlayer and dismissing it removes it', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Trigger audio playback
      await quranModule.audioService.playAyah(1, 1);
      await tester.pumpAndSettle();

      // MiniPlayer is now visible
      expect(find.byType(QuranMiniPlayer), findsOneWidget);

      // Stop audio
      await quranModule.audioService.stop();
      await tester.pumpAndSettle();

      // MiniPlayer disappears
      expect(find.byType(QuranMiniPlayer), findsNothing);
    });
  });
}
