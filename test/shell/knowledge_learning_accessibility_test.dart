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
  group('SIRAJ v1.0 — Sprint 6: Knowledge & Learning Accessibility Suite (§72..§75, §120)', () {
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

    Widget createAccessibleApp(Widget child, {double textScale = 1.5}) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: child,
        ),
      );
    }

    testWidgets('Accessibility 1: Knowledge & Learning Screens render without overflow at 1.5x font scale', (tester) async {
      await tester.pumpWidget(
        createAccessibleApp(
          KnowledgeHomeScreen(module: knowledgeModule),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المعرفة والحديث الشريف'), findsOneWidget);

      await tester.pumpWidget(
        createAccessibleApp(
          LearningHomeScreen(module: learningModule),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المنصة التعليمية والمناهج'), findsOneWidget);
    });
  });
}
