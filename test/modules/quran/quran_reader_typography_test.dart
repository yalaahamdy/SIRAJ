import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/modules/quran/domain/quran_reader_modes.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';

void main() {
  group('M02 Quran Typography & Calligraphy Tests', () {
    test('Arabic-Indic numerals converter generates authentic Quranic numbers', () {
      expect(AyahView.toArabicIndic(1), equals('١'));
      expect(AyahView.toArabicIndic(7), equals('٧'));
      expect(AyahView.toArabicIndic(286), equals('٢٨٦'));
      expect(AyahView.toArabicIndic(6236), equals('٦٢٣٦'));
    });

    test('QuranTypographyConfig provides distinct typography from standard UI font', () {
      const configAmiri = QuranTypographyConfig(
        fontFamily: QuranFontFamily.amiri,
        fontSize: 26.0,
        lineHeight: 2.3,
      );

      final style = configAmiri.buildQuranTextStyle();
      expect(style.fontFamily, equals('Amiri'));
      expect(style.fontSize, equals(26.0));
      expect(style.height, equals(2.3));
      expect(style.letterSpacing, equals(0.2));

      const configScheherazade = QuranTypographyConfig(
        fontFamily: QuranFontFamily.scheherazade,
      );
      final styleScheh = configScheherazade.buildQuranTextStyle();
      expect(styleScheh.fontFamily, equals('ScheherazadeNew'));
    });

    test('Theme presets resolve authentic background and text palettes', () {
      const lightConfig = QuranTypographyConfig(themeMode: QuranReaderThemeMode.light);
      expect(lightConfig.resolveTextColor(), equals(const Color(0xFF1B242C)));

      const darkConfig = QuranTypographyConfig(themeMode: QuranReaderThemeMode.dark);
      expect(darkConfig.resolveTextColor(), equals(const Color(0xFFE8EAED)));

      const sepiaConfig = QuranTypographyConfig(themeMode: QuranReaderThemeMode.sepia);
      expect(sepiaConfig.resolveTextColor(), equals(const Color(0xFF2C2216)));
    });

    test('Ayah marker style scales harmoniously with Quran font size', () {
      const configSmall = QuranTypographyConfig(fontSize: 20.0);
      expect(configSmall.buildAyahMarkerStyle().fontSize, equals(15.0));

      const configLarge = QuranTypographyConfig(fontSize: 32.0);
      expect(configLarge.buildAyahMarkerStyle().fontSize, equals(24.0));
    });
  });
}
