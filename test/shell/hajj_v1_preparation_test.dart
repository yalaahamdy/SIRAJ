import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/preparation_checklist_screen.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Preparation Checklist Suite (§9..§13, §98, §124)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      );
    }

    testWidgets('Preparation 1: Displays items by category and toggles checkbox', (tester) async {
      await tester.pumpWidget(createTestApp(PreparationChecklistScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(find.text('حقيبة واستعداد الحاج والمعتمر'), findsOneWidget);
      expect(find.text('لباس الإحرام (إزار ورداء وحزام) وسجادة صلاة'), findsOneWidget);
      expect(find.text('0 من 4 بند'), findsOneWidget);

      // Check an item
      await tester.tap(find.text('لباس الإحرام (إزار ورداء وحزام) وسجادة صلاة'));
      await tester.pumpAndSettle();

      expect(find.text('1 من 4 بند'), findsOneWidget);

      final prog = (await hajjModule.getUserProgress()).valueOrNull!;
      expect(prog.checkedPreparationItemIds.contains('prep_ihram_clothes'), isTrue);
    });

    testWidgets('Preparation 2: Reset dialog clears all checked items locally', (tester) async {
      await hajjModule.togglePreparationItem('prep_ihram_clothes');

      await tester.pumpWidget(createTestApp(PreparationChecklistScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(find.text('1 من 4 بند'), findsOneWidget);

      // Tap Reset action
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(find.text('إعادة ضبط قائمة التجهيز'), findsOneWidget);

      // Confirm
      await tester.tap(find.text('إعادة الضبط'));
      await tester.pumpAndSettle();

      expect(find.text('0 من 4 بند'), findsOneWidget);
      final prog = (await hajjModule.getUserProgress()).valueOrNull!;
      expect(prog.checkedPreparationItemIds.isEmpty, isTrue);
    });
  });
}
