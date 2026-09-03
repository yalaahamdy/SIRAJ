import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/domain/surah.dart';
import 'package:siraj/modules/quran/services/quran_typography_service.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/quran/widgets/quran_mushaf_flow_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Surah testSurah;
  late List<Ayah> shortAyahs;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    testSurah = package.surahs.first;
    shortAyahs = package.ayahs.take(3).toList();
  });

  group('M02.1 Quran Inline Mushaf Flow Tests (§2, §32)', () {
    testWidgets('Continuous Arabic flow renders all verses inside a single Text.rich span tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: shortAyahs,
              config: const QuranTypographyConfig(),
              onAyahTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final richTextFinder = find.byType(RichText);
      expect(richTextFinder, findsWidgets);

      final richTextWidget = tester.firstWidget<RichText>(richTextFinder);
      final fullText = richTextWidget.text.toPlainText();

      expect(fullText, contains(shortAyahs[0].textUthmani));
      expect(fullText, contains(shortAyahs[1].textUthmani));
      expect(fullText, contains(shortAyahs[2].textUthmani));

      expect(fullText, contains('﴿١﴾'));
      expect(fullText, contains('﴿٢﴾'));
      expect(fullText, contains('﴿٣﴾'));
    });

    testWidgets('Tapping on a verse within continuous flow triggers selection callback', (tester) async {
      int? tappedAyah;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: shortAyahs,
              config: const QuranTypographyConfig(),
              onAyahTap: (a) => tappedAyah = a.ayahNumber,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.firstWidget<Text>(find.byType(Text));
      final rootSpan = textWidget.textSpan as TextSpan;
      final ayah1Span = rootSpan.children![0] as TextSpan;
      (ayah1Span.recognizer as TapGestureRecognizer?)?.onTap?.call();

      expect(tappedAyah, equals(1));
    });

    testWidgets('Active playing verse receives distinct highlight background', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: shortAyahs,
              config: const QuranTypographyConfig(),
              playingAyahNumber: 2,
              onAyahTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.firstWidget<Text>(find.byType(Text));
      final rootSpan = textWidget.textSpan as TextSpan;

      // Children alternate: [ayah1_text, ayah1_marker, ayah2_text, ayah2_marker, ...]
      final ayah2TextSpan = rootSpan.children![2] as TextSpan;
      expect(ayah2TextSpan.style?.backgroundColor, isNotNull);
    });

    testWidgets('Selected verse highlights text but colors marker green without background highlight', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: shortAyahs,
              config: const QuranTypographyConfig(),
              selectedAyahNumber: 1,
              onAyahTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.firstWidget<Text>(find.byType(Text));
      final rootSpan = textWidget.textSpan as TextSpan;

      // Verse text receives highlight
      final ayah1TextSpan = rootSpan.children![0] as TextSpan;
      expect(ayah1TextSpan.style?.backgroundColor, isNotNull);

      // Ayah marker has NO highlight background and is colored GREEN
      final ayah1MarkerSpan = rootSpan.children![1] as TextSpan;
      expect(ayah1MarkerSpan.style?.backgroundColor, equals(Colors.transparent));
      expect(ayah1MarkerSpan.style?.color, equals(const Color(0xFF2E7D32)));
    });

    testWidgets('Renders ornamental page divider when verses span multiple pages', (tester) async {
      final multiPageAyahs = [
        Ayah.create(
          surahNumber: shortAyahs[0].surahNumber,
          ayahNumber: shortAyahs[0].ayahNumber,
          textUthmani: shortAyahs[0].textUthmani,
          textSimple: shortAyahs[0].textSimple,
          pageNumber: 2,
          juzNumber: 1,
          hizbNumber: 1,
          rubNumber: 1,
          manzilNumber: 1,
        ),
        Ayah.create(
          surahNumber: shortAyahs[1].surahNumber,
          ayahNumber: shortAyahs[1].ayahNumber,
          textUthmani: shortAyahs[1].textUthmani,
          textSimple: shortAyahs[1].textSimple,
          pageNumber: 3,
          juzNumber: 1,
          hizbNumber: 1,
          rubNumber: 1,
          manzilNumber: 1,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: multiPageAyahs,
              config: const QuranTypographyConfig(),
              onAyahTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('نهاية صفحة ٢'), findsOneWidget);
    });
  });
}
