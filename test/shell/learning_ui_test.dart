import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/learning/learning_home_screen.dart';
import 'package:siraj/shell/learning/learning_path_screen.dart';
import 'package:siraj/shell/learning/lesson_screen.dart';
import 'package:siraj/shell/learning/quiz_screen.dart';
import 'package:siraj/shell/learning/widgets/learning_progress_card.dart';
import 'package:siraj/shell/learning/widgets/lesson_section_view.dart';
import '../fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('L4 Learning Shell UI & Interaction Tests (§42, §45)', () {
    late MemoryStorageRegistry registry;
    late LearningModule learningModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: registry);
      final pkg = SyntheticLearningFixtures.createPackage();
      learningModule.mountPackage(pkg);
    });

    testWidgets('LearningHomeScreen renders progress card and paths', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LearningHomeScreen(module: learningModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المنصة التعليمية والمناهج'), findsOneWidget);
      expect(find.byType(LearningProgressCard), findsOneWidget);
      expect(find.text('مسار الفقه التأسيسي للمسلم'), findsOneWidget);
    });

    testWidgets('Tapping path navigates to LearningPathScreen and shows courses', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LearningHomeScreen(module: learningModule),
        ),
      );
      await tester.pumpAndSettle();

      final pathTile = find.text('مسار الفقه التأسيسي للمسلم');
      await tester.tap(pathTile);
      await tester.pumpAndSettle();

      expect(find.byType(LearningPathScreen), findsOneWidget);
      expect(find.text('مقرر فقه الطهارة والوضوء'), findsOneWidget);
      expect(find.text('فرائض الوضوء وأركانه الأساسية'), findsOneWidget);
    });

    testWidgets('Tapping lesson navigates to LessonScreen and renders sections and quiz button', (tester) async {
      final lesson = SyntheticLearningFixtures.createLesson();

      await tester.pumpWidget(
        MaterialApp(
          home: LessonScreen(lesson: lesson, module: learningModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('فرائض الوضوء وأركانه الأساسية'), findsOneWidget);
      expect(find.byType(LessonSectionView), findsNWidgets(2));

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('خوض اختبار استيعاب الدرس'), findsOneWidget);
    });

    testWidgets('Quiz flow: Taking quiz, selecting answer, and submitting shows feedback', (tester) async {
      final quiz = SyntheticLearningFixtures.createQuiz();

      await tester.pumpWidget(
        MaterialApp(
          home: QuizScreen(quiz: quiz, module: learningModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('اختبار استيعاب فرائض الوضوء'), findsOneWidget);
      expect(find.textContaining('كم عدد فرائض الوضوء'), findsOneWidget);

      final optionFinder = find.text('أربعة أركان منصوصة في آية المائدة');
      await tester.tap(optionFinder);
      await tester.pumpAndSettle();

      final submitBtn = find.text('إنهاء الاختبار وتأكيد الإجابات');
      await tester.tap(submitBtn);
      await tester.pumpAndSettle();

      expect(find.text('تم اجتياز الاختبار بنجاح'), findsOneWidget);
      expect(find.textContaining('البيان والتأصيل'), findsOneWidget);
    });
  });
}
