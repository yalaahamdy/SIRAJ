import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/knowledge/knowledge_home_screen.dart';
import 'package:siraj/shell/learning/learning_home_screen.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Knowledge & Learning Responsive Form Factors Suite (§76..§80, §120)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    Widget createResponsiveApp(Widget child, Size size) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: child,
          ),
        ),
      );
    }

    testWidgets('Responsive 1: Small Phone (360x640) renders Knowledge and Learning cleanly', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          KnowledgeHomeScreen(module: knowledgeModule),
          const Size(360, 640),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المعرفة والحديث الشريف'), findsOneWidget);

      await tester.pumpWidget(
        createResponsiveApp(
          LearningHomeScreen(module: learningModule),
          const Size(360, 640),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المنصة التعليمية والمناهج'), findsOneWidget);
    });

    testWidgets('Responsive 2: Large Phone (412x915) renders cleanly', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          KnowledgeHomeScreen(module: knowledgeModule),
          const Size(412, 915),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المعرفة والحديث الشريف'), findsOneWidget);
    });

    testWidgets('Responsive 3: Tablet/Desktop (1024x768) renders cleanly', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          LearningHomeScreen(module: learningModule),
          const Size(1024, 768),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المنصة التعليمية والمناهج'), findsOneWidget);
    });
  });
}
