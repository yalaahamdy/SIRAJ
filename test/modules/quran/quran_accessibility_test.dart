import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/ayah_key.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';
import 'package:siraj/shell/theme/app_theme.dart';

void main() {
  group('Quran Accessibility, RTL, and Responsive Layout Suite (§16, §17)', () {
    const sampleAyah = Ayah(
      key: AyahKey(surahNumber: 1, ayahNumber: 1),
      textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      textSimple: 'بسم الله الرحمن الرحيم',
      juzNumber: 1,
      hizbNumber: 1,
      rubNumber: 1,
      pageNumber: 1,
      manzilNumber: 1,
      hasSajdah: false,
      integrityHash: 'sha256:dummyhash',
    );

    testWidgets('AyahView renders without layout overflow at 200% text scale factor', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
            child: const Scaffold(
              body: AyahView(
                ayah: sampleAyah,
                showTranslation: true,
                translationText: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
                showTajweed: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure no exceptions or overflows occurred
      expect(tester.takeException(), isNull);
      expect(find.textContaining(sampleAyah.textUthmani, findRichText: true), findsOneWidget);
    });

    testWidgets('AyahView renders correctly under Dark Theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          home: const Scaffold(
            body: AyahView(
              ayah: sampleAyah,
              showTranslation: true,
              translationText: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
              showTajweed: true,
              tajweedRules: [
                {'start': 0, 'end': 4, 'rule': 'hamzat_wasl'},
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('AyahView adapts smoothly to narrow (320px) screens', (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AyahView(
              ayah: sampleAyah,
              fontSize: 18.0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
