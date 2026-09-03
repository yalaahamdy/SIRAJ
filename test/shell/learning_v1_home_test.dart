import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/learning/learning_home_screen.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Learning Home Suite (§31..§33, §120)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
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
        home: child,
      );
    }

    testWidgets('Learning Home 1: Displays Paths, mastery overview, and goals button', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          LearningHomeScreen(module: learningModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المنصة التعليمية والمناهج'), findsOneWidget);
      expect(find.text('المسارات التعليمية المعتمدة'), findsOneWidget);
      expect(find.textContaining('مسار الفقه التأسيسي للمسلم'), findsOneWidget);
      expect(find.byIcon(Icons.flag_outlined), findsOneWidget);
    });
  });
}
