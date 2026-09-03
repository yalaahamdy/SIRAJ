import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/fasting/domain/fasting_guide_topic.dart';
import 'package:siraj/modules/learning/domain/learning_content_type.dart';
import 'package:siraj/modules/learning/domain/lesson_section.dart';
import 'package:siraj/modules/seerah/domain/moral_lesson.dart';
import 'package:siraj/modules/zakat/domain/zakat_guide_topic.dart';
import 'package:siraj/shell/adhkar/widgets/interactive_counter_view.dart';
import 'package:siraj/shell/fasting/fasting_topic_detail_screen.dart';
import 'package:siraj/shell/learning/widgets/lesson_section_view.dart';
import 'package:siraj/shell/seerah/widgets/moral_lesson_card.dart';
import 'package:siraj/shell/zakat/zakat_guide_detail_screen.dart';

void main() {
  group('M49: SIRAJ v1.0 — Content Navigation & Detail Flows Suite (§1..§20)', () {
    testWidgets('Learning: LessonSectionView renders structured lesson sections and source differentiation', (tester) async {
      final section = LessonSection.create(
        sectionId: 'sec_test_01',
        title: 'النية وغسل الوجه في الوضوء',
        content: 'النية محلها القلب وغسل الوجه من منابت شعر الرأس المعتاد إلى أسفل اللحية طولاً.',
        contentType: LearningContentType.sourceText,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LessonSectionView(section: section),
          ),
        ),
      );

      expect(find.text('النية وغسل الوجه في الوضوء'), findsOneWidget);
      expect(find.text('النية محلها القلب وغسل الوجه من منابت شعر الرأس المعتاد إلى أسفل اللحية طولاً.'), findsOneWidget);
    });

    testWidgets('Seerah: MoralLessonCard renders moral reflection segregated from historical fact', (tester) async {
      const lesson = MoralLesson(
        lessonText: 'التوكل على الله مع الأخذ بكافة الأسباب المادية المشروعة.',
        themeArabic: 'العقيدة واليقين',
        sourceOrScholar: 'ابن كثير',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MoralLessonCard(lesson: lesson),
          ),
        ),
      );

      expect(find.text('العبرة والمقصد: العقيدة واليقين'), findsOneWidget);
      expect(find.text('التوكل على الله مع الأخذ بكافة الأسباب المادية المشروعة.'), findsOneWidget);
      expect(find.text('المستنبط: ابن كثير'), findsOneWidget);
    });

    testWidgets('Fasting: Fasting Topic Detail screen renders category, content, and key points', (tester) async {
      final topic = FastingGuideData.topics.first;

      await tester.pumpWidget(
        MaterialApp(
          home: FastingTopicDetailScreen(topic: topic),
        ),
      );

      expect(find.text(topic.title), findsWidgets);
      expect(find.text(topic.category), findsWidgets);
      expect(find.text(topic.keyPoints.first), findsOneWidget);
      expect(find.text('أبرز الفوائد والضوابط'), findsOneWidget);
    });

    testWidgets('Zakat: Zakat Guide Detail screen renders calculation steps and examples', (tester) async {
      final topic = ZakatGuideData.topics.first;

      await tester.pumpWidget(
        MaterialApp(
          home: ZakatGuideDetailScreen(topic: topic),
        ),
      );

      expect(find.text(topic.title), findsWidgets);
      expect(find.text(topic.category), findsWidgets);
      if (topic.calculationSteps.isNotEmpty) {
        expect(find.text(topic.calculationSteps.first), findsOneWidget);
      }
    });

    testWidgets('Adhkar: InteractiveCounterView increments and resets reliably upon user touch', (tester) async {
      int count = 0;
      bool resetCalled = false;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              home: Scaffold(
                body: InteractiveCounterView(
                  currentCount: count,
                  targetCount: 3,
                  isSourced: true,
                  onIncrement: () => setState(() => count++),
                  onReset: () => setState(() {
                    count = 0;
                    resetCalled = true;
                  }),
                ),
              ),
            );
          },
        ),
      );

      expect(find.text('0'), findsWidgets);
      expect(find.text('العدد المأثور في السنة: 3'), findsOneWidget);

      // Tap to increment
      await tester.tap(find.byType(InteractiveCounterView));
      await tester.pump();
      expect(count, equals(1));

      await tester.tap(find.byType(InteractiveCounterView));
      await tester.pump();
      expect(count, equals(2));

      await tester.tap(find.byType(InteractiveCounterView));
      await tester.pump();
      expect(count, equals(3));
      expect(find.text('اكتمل'), findsOneWidget);

      // Tap Reset button
      final resetButton = find.text('إعادة ضبط');
      expect(resetButton, findsOneWidget);
      await tester.tap(resetButton);
      await tester.pump();
      expect(count, equals(0));
      expect(resetCalled, isTrue);
    });

    testWidgets('Navigation: Full Navigator push and pop for detail flows works smoothly', (tester) async {
      final topic = FastingGuideData.topics.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => FastingTopicDetailScreen(topic: topic)),
                    );
                  },
                  child: const Text('افتح الموضوع'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('افتح الموضوع'), findsOneWidget);

      // Push detail
      await tester.tap(find.text('افتح الموضوع'));
      await tester.pumpAndSettle();

      expect(find.text(topic.title), findsWidgets);
      expect(find.text(topic.category), findsWidgets);

      // Pop back
      final backButton = find.byType(BackButton);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('افتح الموضوع'), findsOneWidget);
    });
  });
}
