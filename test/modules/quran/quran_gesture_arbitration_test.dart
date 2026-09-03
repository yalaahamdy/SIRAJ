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
  late List<Ayah> testAyahs;

  setUpAll(() async {
    final package = await CanonicalQuranLoader.loadPackage();
    testSurah = package.surahs.first;
    testAyahs = package.ayahs.take(2).toList();
  });

  group('M02.1 Quran Gesture Arbitration Tests (§22, §23)', () {
    testWidgets('Single tap triggers selection, double tap triggers audio toggle callback', (tester) async {
      int? singleTapAyah;
      int? doubleTapAyah;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: testAyahs,
              config: const QuranTypographyConfig(),
              onAyahTap: (a) => singleTapAyah = a.ayahNumber,
              onAyahDoubleTap: (a) => doubleTapAyah = a.ayahNumber,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.firstWidget<Text>(find.byType(Text));
      final rootSpan = textWidget.textSpan as TextSpan;
      final ayah1Span = rootSpan.children![0] as TextSpan;
      final recognizer = ayah1Span.recognizer as TapGestureRecognizer;

      // 1. Single tap
      recognizer.onTap?.call();
      expect(singleTapAyah, equals(1));

      // 2. Immediate second tap on same verse triggers double tap
      recognizer.onTap?.call();
      expect(doubleTapAyah, equals(1));
    });
  });
}
