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
    testAyahs = [package.ayahs.first, package.ayahs[6]]; // Ayah 1 and Ayah 7
  });

  group('M02.1 Ayah Marker Layout & Integration Tests (§3)', () {
    testWidgets('Ayah markers use authentic Arabic-Indic numerals and ornate brackets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: testAyahs,
              config: const QuranTypographyConfig(),
              onAyahTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textWidget = tester.firstWidget<Text>(find.byType(Text));
      final fullText = textWidget.textSpan!.toPlainText();

      // Check Ayah 1 marker (١)
      expect(fullText, contains('﴿١﴾'));
      // Check Ayah 7 marker (٧)
      expect(fullText, contains('﴿٧﴾'));
    });

    testWidgets('Ayah marker renders without layout overflow on constrained viewport (320px)', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: QuranMushafFlowView(
              surah: testSurah,
              ayahs: testAyahs,
              config: const QuranTypographyConfig(fontSize: 28.0),
              onAyahTap: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
