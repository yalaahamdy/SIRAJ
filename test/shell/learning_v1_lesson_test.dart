import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/learning/lesson_screen.dart';
import 'package:siraj/shell/learning/widgets/evidence_citation_box.dart';
import 'package:siraj/shell/learning/widgets/lesson_section_view.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Lesson Experience & Structure Suite (§34..§39, §120)', () {
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

    testWidgets('Lesson 1: Renders Objectives, Content Sections, Evidence Citation, and Quiz trigger', (tester) async {
      final lesson = learningModule.getLesson('lsn_wudu_pillars').valueOrNull!;

      await tester.pumpWidget(
        createTestApp(
          LessonScreen(
            lesson: lesson,
            module: learningModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(lesson.title), findsOneWidget);
      expect(find.text('أهداف الدرس المعرفية:'), findsOneWidget);
      expect(find.byType(LessonSectionView), findsNWidgets(lesson.sections.length));
      expect(find.byType(EvidenceCitationBox), findsWidgets);

      await tester.scrollUntilVisible(find.text('خوض اختبار استيعاب الدرس'), 100);
      expect(find.text('خوض اختبار استيعاب الدرس'), findsOneWidget);
    });
  });
}
