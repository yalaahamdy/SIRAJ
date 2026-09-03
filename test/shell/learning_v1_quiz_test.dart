import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/learning/quiz_screen.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Quiz & Assessment Suite (§40..§43, §120)', () {
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

    testWidgets('Quiz 1: Answering questions and submitting returns score and sourced explanations', (tester) async {
      final quiz = learningModule.getQuizByLesson('lsn_wudu_pillars').valueOrNull!;

      await tester.pumpWidget(
        createTestApp(
          QuizScreen(
            quiz: quiz,
            module: learningModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(quiz.title), findsOneWidget);
      expect(find.textContaining('كم عدد فرائض الوضوء'), findsOneWidget);

      // Select Option 'أربعة أركان' (index 0)
      final correctOption = find.text('أربعة أركان منصوصة في آية المائدة');
      expect(correctOption, findsOneWidget);

      await tester.tap(correctOption);
      await tester.pumpAndSettle();

      // Submit
      final submitBtn = find.text('إنهاء الاختبار وتأكيد الإجابات');
      expect(submitBtn, findsOneWidget);

      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('تم اجتياز الاختبار بنجاح'), findsOneWidget);
      expect(find.textContaining('100%'), findsOneWidget);
      expect(find.textContaining('الفرائض المنصوصة في الآية أربعة'), findsOneWidget);
    });
  });
}
