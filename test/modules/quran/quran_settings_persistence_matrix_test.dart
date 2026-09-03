import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/domain/quran_reader_modes.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/shell/quran/controllers/quran_reader_settings_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M02.1 Quran Reader Settings State & Persistence Matrix Tests (§9, §10, §11, §12, §13)', () {
    late MemoryKeyValueStore memoryStore;

    setUp(() {
      memoryStore = MemoryKeyValueStore('mod_quran');
    });

    test('Single source of truth preserves all other fields when changing one field', () {
      final controller = QuranReaderSettingsController(store: memoryStore);

      // 1. Initial baseline
      expect(controller.state.fontFamily, equals(QuranFontFamily.amiri));
      expect(controller.state.fontSize, equals(24.0));
      expect(controller.state.themeMode, equals(QuranReaderThemeMode.light));

      // 2. Change font family only
      controller.setFontFamily(QuranFontFamily.scheherazade);
      expect(controller.state.fontFamily, equals(QuranFontFamily.scheherazade));
      expect(controller.state.fontSize, equals(24.0), reason: 'fontSize must remain unchanged');
      expect(controller.state.themeMode, equals(QuranReaderThemeMode.light), reason: 'themeMode must remain unchanged');

      // 3. Change font size only
      controller.setFontSize(32.0);
      expect(controller.state.fontSize, equals(32.0));
      expect(controller.state.fontFamily, equals(QuranFontFamily.scheherazade), reason: 'fontFamily must not reset');
      expect(controller.state.themeMode, equals(QuranReaderThemeMode.light), reason: 'themeMode must remain unchanged');

      // 4. Change theme mode only
      controller.setThemeMode(QuranReaderThemeMode.sepia);
      expect(controller.state.themeMode, equals(QuranReaderThemeMode.sepia));
      expect(controller.state.fontFamily, equals(QuranFontFamily.scheherazade));
      expect(controller.state.fontSize, equals(32.0));

      // 5. Change translation toggle only
      controller.setShowTranslation(true);
      expect(controller.state.showTranslation, isTrue);
      expect(controller.state.themeMode, equals(QuranReaderThemeMode.sepia));
      expect(controller.state.fontFamily, equals(QuranFontFamily.scheherazade));
      expect(controller.state.fontSize, equals(32.0));
    });

    test('Settings survive controller re-creation and reload from persistence store', () async {
      final controller1 = QuranReaderSettingsController(store: memoryStore);

      // Customize multiple parameters
      controller1.setFontSize(30.0);
      controller1.setThemeMode(QuranReaderThemeMode.dark);
      controller1.setReaderMode(QuranReaderMode.focus);
      controller1.setAutoScroll(false);

      // Allow async persist to complete
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Instantiate a new controller pointing to the same store (simulating app restart)
      final controller2 = QuranReaderSettingsController(store: memoryStore);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller2.state.fontSize, equals(30.0));
      expect(controller2.state.themeMode, equals(QuranReaderThemeMode.dark));
      expect(controller2.state.readerMode, equals(QuranReaderMode.focus));
      expect(controller2.state.autoScroll, isFalse);
    });

    test('Settings matrix transitions work across all themes, fonts, and modes', () {
      final controller = QuranReaderSettingsController(store: memoryStore);

      for (final font in QuranFontFamily.values) {
        for (final theme in QuranReaderThemeMode.values) {
          for (final mode in QuranReaderMode.values) {
            controller.setFontFamily(font);
            controller.setThemeMode(theme);
            controller.setReaderMode(mode);

            expect(controller.state.fontFamily, equals(font));
            expect(controller.state.themeMode, equals(theme));
            expect(controller.state.readerMode, equals(mode));
          }
        }
      }
    });
  });
}
