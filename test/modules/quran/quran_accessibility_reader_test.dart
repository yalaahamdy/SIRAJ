import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';
import 'package:siraj/shell/theme/app_theme.dart';

void main() {
  group('M02 Quran Reader Accessibility Tests', () {
    final testAyah = Ayah.create(
      surahNumber: 1,
      ayahNumber: 2,
      textUthmani: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ',
      textSimple: 'الحمد لله رب العالمين',
      juzNumber: 1,
      hizbNumber: 1,
      rubNumber: 1,
      pageNumber: 1,
      manzilNumber: 1,
      hasSajdah: false,
    );

    testWidgets('AyahView exposes meaningful accessibility semantics for screen readers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: AyahView(
              ayah: testAyah,
              config: const QuranTypographyConfig(fontSize: 24.0),
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(AyahView));
      expect(semantics.label, contains('سورة 1، الآية 2'));
      expect(semantics.label, contains('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ'));
    });

    testWidgets('AyahView gracefully scales with high font sizes (up to 38pt)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SingleChildScrollView(
              child: AyahView(
                ayah: testAyah,
                config: const QuranTypographyConfig(fontSize: 38.0, lineHeight: 2.5),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.textContaining('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ'), findsOneWidget);
    });
  });
}
