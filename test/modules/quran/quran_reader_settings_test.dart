import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/quran_reader_modes.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/shell/quran/widgets/reader_settings_sheet.dart';
import 'package:siraj/shell/theme/app_theme.dart';

void main() {
  group('M02 Quran Reader Settings Sheet Tests', () {
    testWidgets('ReaderSettingsSheet renders all mode choices and toggles', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      QuranTypographyConfig currentConfig = const QuranTypographyConfig();

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return ReaderSettingsSheet(
                  config: currentConfig,
                  onConfigChanged: (newConfig) {
                    setState(() => currentConfig = newConfig);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('إعدادات المصحف وتجربة القراءة'), findsOneWidget);
      expect(find.text('المصحف'), findsOneWidget);
      expect(find.text('الترجمة'), findsOneWidget);
      expect(find.text('الدراسة والتفسير'), findsOneWidget);
      expect(find.text('الخشوع والتركيز'), findsOneWidget);
      expect(find.text('ورق المصحف'), findsOneWidget);
      expect(find.text('أحكام التجويد الملونة'), findsOneWidget);
      expect(find.text('التمرير التلقائي أثناء التلاوة (Auto-Scroll)'), findsOneWidget);

      // Select Translation Mode chip
      await tester.tap(find.text('الترجمة'));
      await tester.pumpAndSettle();
      expect(currentConfig.readerMode, equals(QuranReaderMode.translation));

      // Select Sepia Mushaf Theme
      await tester.tap(find.text('ورق المصحف'));
      await tester.pumpAndSettle();
      expect(currentConfig.themeMode, equals(QuranReaderThemeMode.sepia));
    });
  });
}
