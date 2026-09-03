import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/core/time/clock.dart';
import 'package:siraj/modules/quran/domain/ayah.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';
import '../../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('M2 Forensic Display Fidelity Pipeline Tests (§13, §14)', () {
    late QuranModule quranModule;

    setUp(() {
      final storage = MemoryStorageRegistry();
      final clock = TestClock(DateTime.utc(2026, 8, 31, 12, 0));
      quranModule = QuranModule(storageRegistry: storage, clock: clock);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);
    });

    testWidgets('Display Fidelity: Canonical text reaches Text widget with 100% character and code unit equality', (tester) async {
      // 1. Retrieve canonical Ayah from store
      final ayahRes = quranModule.readerService.getAyah(1, 1);
      expect(ayahRes.isSuccess, isTrue);
      final canonicalAyah = ayahRes.valueOrNull!;

      // 2. Render AyahView widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AyahView(ayah: canonicalAyah),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 3. Find the rendered Text widget containing the Quranic verse
      final textFinder = find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == canonicalAyah.textUthmani,
      );

      expect(textFinder, findsOneWidget, reason: 'Text widget must contain exact canonical Uthmani text');

      final renderedTextWidget = tester.widget<Text>(textFinder);
      final renderedString = renderedTextWidget.data!;

      // 4. Character-by-character forensic comparison
      expect(renderedString.length, equals(canonicalAyah.textUthmani.length));
      expect(renderedString, equals(canonicalAyah.textUthmani));

      // 5. Code-units forensic comparison
      final canonicalCodeUnits = canonicalAyah.textUthmani.codeUnits;
      final renderedCodeUnits = renderedString.codeUnits;
      expect(renderedCodeUnits, equals(canonicalCodeUnits));

      // 6. Directionality and typography check
      expect(renderedTextWidget.textDirection, equals(TextDirection.rtl));
      expect(renderedTextWidget.style?.fontFamily, equals('Amiri'));
    });

    test('Pipeline Invariance: QuranReaderService does not modify Ayah during retrieval', () {
      final ayahsRes = quranModule.readerService.getSurahAyahs(1);
      expect(ayahsRes.isSuccess, isTrue);

      final ayahs = ayahsRes.valueOrNull!;
      for (final ayah in ayahs) {
        // Hash recalculation must match internal integrity hash
        expect(ayah.verifyIntegrity(), isTrue);
        expect(Ayah.computeHash(ayah.textUthmani), equals(ayah.integrityHash));
      }
    });
  });
}
