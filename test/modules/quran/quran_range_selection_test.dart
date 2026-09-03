import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/shell/quran/controllers/ayah_selection_controller.dart';
import 'package:siraj/shell/quran/widgets/range_selection_dialog.dart';
import 'package:siraj/shell/theme/app_theme.dart';

void main() {
  group('M02 Quran Multi-Ayah Range Selection Tests', () {
    testWidgets('RangeSelectionDialog renders properly and triggers onSelectRange', (tester) async {
      int? capturedStart;
      int? capturedEnd;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => RangeSelectionDialog(
                      surahNumber: 1,
                      surahNameArabic: 'الفاتحة',
                      initialAyah: 2,
                      totalAyahs: 7,
                      onSelectRange: (start, end) {
                        capturedStart = start;
                        capturedEnd = end;
                      },
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.textContaining('تحديد نطاق آيات'), findsOneWidget);
      expect(find.text('تحديد في القارئ'), findsOneWidget);

      // Confirm selection
      await tester.tap(find.text('تحديد في القارئ'));
      await tester.pumpAndSettle();

      expect(capturedStart, equals(2));
      expect(capturedEnd, equals(6));
    });

    test('AyahSelectionController tracks range correctly', () {
      final controller = AyahSelectionController();
      controller.selectRange(1, 3, 6);

      expect(controller.hasSelection, isTrue);
      expect(controller.isRangeSelection, isTrue);
      expect(controller.selectedAyahs, containsAll([3, 4, 5, 6]));
      expect(controller.selectedAyahs.contains(2), isFalse);
      expect(controller.selectedAyahs.contains(7), isFalse);
    });
  });
}
