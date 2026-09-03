import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranModule quranModule;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    quranModule = QuranModule(
      storageRegistry: MemoryStorageRegistry(),
    );
    quranModule.mountPackage(package);
  });

  group('M02.1 Quran Immersive Mode Tests (§4, §20, §21)', () {
    testWidgets('Focus / Immersive mode removes AppBar and gives full screen to Quran text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Normal mode has AppBar
      expect(find.byType(AppBar), findsOneWidget);

      // Open settings and switch to Focus mode
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pumpAndSettle();

      final chipFinder = find.text('الخشوع والتركيز');
      await tester.ensureVisible(chipFinder);
      await tester.tap(chipFinder);
      await tester.pumpAndSettle();

      // Close settings sheet
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // In focus mode, AppBar is hidden for 100% immersive reading
      expect(find.byType(AppBar), findsNothing);

      // Floating exit button is visible
      final exitBtnFinder = find.text('إنهاء وضع الخشوع');
      expect(exitBtnFinder, findsOneWidget);

      // Tapping exit button restores normal mode with AppBar
      await tester.tap(exitBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
