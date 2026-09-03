import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/knowledge/domain/canonical_knowledge_package.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../../test/fixtures/knowledge/synthetic_knowledge_fixtures.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 6: Knowledge & Learning Adversarial Suite (§119)', () {
    late MemoryStorageRegistry storage;
    late KnowledgeModule knowledgeModule;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      knowledgeModule = KnowledgeModule(storageRegistry: storage);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      learningModule = LearningModule(storageRegistry: storage, knowledgeModule: knowledgeModule);
      learningModule.mountPackage(SyntheticLearningFixtures.createPackage());
    });

    test('Adversarial 1: Package with invalid signature is rejected (fail-closed)', () {
      final invalidPkg = CanonicalKnowledgePackage.create(
        packageId: 'pkg_tampered',
        sources: [],
        hadiths: [],
        fiqhTopics: [],
        knowledgeItems: [],
        relations: [],
        learningPaths: [],
        signerIdentity: '',
        signature: '',
        publishedAt: DateTime.utc(2026, 8, 31),
      );

      final unmountedModule = KnowledgeModule(storageRegistry: storage);
      final res = unmountedModule.mountPackage(invalidPkg);
      expect(res.isSuccess, isFalse);
    });

    test('Adversarial 2: User notes cannot mutate canonical lesson content', () async {
      await learningModule.saveUserNote('lsn_wudu_pillars', 'ملاحظة تحاول تغيير المتن');

      final lesson = learningModule.getLesson('lsn_wudu_pillars').valueOrNull!;
      expect(lesson.sections.first.content, contains('الصَّلَاةِ'));
      expect(lesson.sections.first.content, isNot(contains('ملاحظة تحاول')));
    });

    test('Adversarial 3: Cross-Module Shield — Learning operations never mutate Quran store', () async {
      await learningModule.markLessonCompleted('lsn_wudu_pillars', 1);
      await learningModule.saveUserNote('lsn_wudu_pillars', 'note');

      final quranRes = await storage.getStoreForModule('mod_quran').getString('user_learning_progress');
      expect(quranRes.valueOrNull, isNull);
    });

    testWidgets('Adversarial 4: Invalid deep link /knowledge/unknown loads safe fallback error page', (tester) async {
      AppRouter.defaultKnowledgeModule = knowledgeModule;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/knowledge/invalid_subroute_path',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.textContaining('الرابط المطلوب لمنصة المعرفة والحديث غير صالح'), findsOneWidget);
      expect(find.text('العودة للمعارف'), findsOneWidget);
    });

    testWidgets('Adversarial 5: Invalid deep link /learning/unknown loads safe fallback error page', (tester) async {
      AppRouter.defaultLearningModule = learningModule;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: '/learning/invalid_subroute_path',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.textContaining('الرابط المطلوب للمنصة والمناهج التعليمية غير صالح'), findsOneWidget);
      expect(find.text('العودة للمناهج'), findsOneWidget);
    });
  });
}
