import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/shell/quran/controllers/ayah_selection_controller.dart';
import 'package:siraj/shell/quran/widgets/ayah_action_toolbar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M02.1 Quran Minimal Toolbar Tests (§5, §6)', () {
    testWidgets('Toolbar displays strictly the 4 core actions: Play, Tafsir, Bookmark, More', (tester) async {
      final controller = AyahSelectionController();
      controller.selectAyah(1, 5);

      bool moreTapped = false;
      bool playTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AyahActionToolbar(
              controller: controller,
              onPlay: () => playTapped = true,
              onTafsir: () {},
              onBookmark: () {},
              onMore: () => moreTapped = true,
              onClose: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Exactly the 4 minimal actions are displayed
      expect(find.text('تلاوة'), findsOneWidget);
      expect(find.text('تفسير'), findsOneWidget);
      expect(find.text('فاصل'), findsOneWidget);
      expect(find.text('المزيد'), findsOneWidget);

      // Verify that verbose actions (like 'بيان معاني الكلمات' or 'تحفيظ') are NOT on the mini-toolbar
      expect(find.text('بيان معاني الكلمات'), findsNothing);
      expect(find.text('تحفيظ'), findsNothing);

      // Test actions
      await tester.tap(find.text('تلاوة'));
      expect(playTapped, isTrue);

      await tester.tap(find.text('المزيد'));
      expect(moreTapped, isTrue);
    });

    testWidgets('Mini-toolbar fits within 320px viewport without overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final controller = AyahSelectionController();
      controller.selectAyah(2, 255);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AyahActionToolbar(
              controller: controller,
              onPlay: () {},
              onTafsir: () {},
              onBookmark: () {},
              onMore: () {},
              onClose: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
