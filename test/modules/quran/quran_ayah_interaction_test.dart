import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/store/canonical_quran_loader.dart';
import 'package:siraj/shell/quran/controllers/ayah_selection_controller.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/widgets/quran_mushaf_flow_view.dart';
import 'package:siraj/shell/theme/app_theme.dart';

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

  group('M02 Ayah Interaction System Tests', () {
    test('AyahSelectionController handles single selection and clear', () {
      final controller = AyahSelectionController();
      expect(controller.hasSelection, isFalse);
      expect(controller.state, equals(AyahSelectionState.none));

      controller.selectAyah(1, 2);
      expect(controller.hasSelection, isTrue);
      expect(controller.selectedAyah, equals(2));
      expect(controller.state, equals(AyahSelectionState.selected));
      expect(controller.isAyahSelected(2), isTrue);
      expect(controller.isAyahSelected(1), isFalse);

      // Tapping again deselects
      controller.selectAyah(1, 2);
      expect(controller.hasSelection, isFalse);
      expect(controller.state, equals(AyahSelectionState.none));
    });

    test('AyahSelectionController handles range selection', () {
      final controller = AyahSelectionController();
      controller.selectRange(2, 5, 9);
      expect(controller.hasSelection, isTrue);
      expect(controller.isRangeSelection, isTrue);
      expect(controller.rangeStart, equals(5));
      expect(controller.rangeEnd, equals(9));
      expect(controller.selectedAyahs.length, equals(5));
      expect(controller.isAyahSelected(5), isTrue);
      expect(controller.isAyahSelected(7), isTrue);
      expect(controller.isAyahSelected(9), isTrue);
      expect(controller.isAyahSelected(10), isFalse);

      controller.clearSelection();
      expect(controller.hasSelection, isFalse);
    });

    testWidgets('Single tap on Ayah activates selection and shows Action Toolbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Action toolbar should not be initially visible
      expect(find.text('تلاوة'), findsNothing);
      expect(find.text('تفسير'), findsNothing);

      // Tap on Ayah 2 in flow
      final quranTextFinder = find.descendant(
        of: find.byType(QuranMushafFlowView),
        matching: find.byType(Text),
      );
      final textWidget = tester.firstWidget<Text>(quranTextFinder);
      final rootSpan = textWidget.textSpan as TextSpan;
      final ayah2Span = rootSpan.children![2] as TextSpan;
      (ayah2Span.recognizer as TapGestureRecognizer).onTap?.call();
      await tester.pumpAndSettle();

      // Floating action toolbar is now displayed
      expect(find.text('تلاوة'), findsOneWidget);
      expect(find.text('تفسير'), findsOneWidget);
      expect(find.text('نسخ'), findsOneWidget);
      expect(find.text('مشاركة'), findsOneWidget);
      expect(find.text('الآية 2'), findsOneWidget);

      // Close button dismisses toolbar
      final closeBtn = find.byTooltip('إغلاق التحديد');
      expect(closeBtn, findsOneWidget);
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();

      expect(find.text('تلاوة'), findsNothing);
    });

    testWidgets('Opening action sheet displays comprehensive actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final quranTextFinder = find.descendant(
        of: find.byType(QuranMushafFlowView),
        matching: find.byType(Text),
      );
      final textWidget = tester.firstWidget<Text>(quranTextFinder);
      final rootSpan = textWidget.textSpan as TextSpan;
      final ayah1Span = rootSpan.children![0] as TextSpan;
      (ayah1Span.recognizer as TapGestureRecognizer).onTap?.call();
      await tester.pumpAndSettle();

      // Open bottom sheet via "المزيد"
      await tester.tap(find.text('المزيد'));
      await tester.pumpAndSettle();

      // Bottom sheet actions
      expect(find.text('تلاوة الآية الشريفة'), findsOneWidget);
      expect(find.text('التفسير الميسر المعتمد'), findsOneWidget);
      expect(find.text('تحديد نطاق آيات (Select Range)'), findsOneWidget);
      expect(find.text('نسخ نص الآية مع التوثيق'), findsOneWidget);
      expect(find.text('مشاركة مرجع الآية الشريفة'), findsOneWidget);
    });
  });
}
