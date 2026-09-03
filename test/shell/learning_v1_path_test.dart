import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/learning/learning_path_screen.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Learning Path & Courses Suite (§32, §33, §120)', () {
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

    testWidgets('Learning Path 1: Displays Path modules and structured lessons', (tester) async {
      final path = learningModule.getAllPaths().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          LearningPathScreen(
            path: path,
            module: learningModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(path.title), findsWidgets);
      expect(find.textContaining('مقرر فقه الطهارة والوضوء'), findsOneWidget);
      expect(find.textContaining('الوحدة الأولى: أحكام الوضوء'), findsOneWidget);
      expect(find.textContaining('فرائض الوضوء وأركانه الأساسية'), findsOneWidget);
    });
  });
}
