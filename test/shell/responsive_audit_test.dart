import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/shell/learning/learning_home_screen.dart';
import 'package:siraj/shell/learning/learning_path_screen.dart';
import 'package:siraj/shell/learning/widgets/academy_stats_banner.dart';
import 'package:siraj/shell/learning/widgets/continue_learning_card.dart';
import 'package:siraj/shell/seed/data/canonical_learning_data.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('Comprehensive Small Screen Responsive Audit (320x568)', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(CanonicalLearningData.getPackage());
    });

    Widget createTestApp(Widget child, {double textScale = 1.0}) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(320, 568),
            textScaler: TextScaler.linear(textScale),
          ),
          child: child,
        ),
      );
    }

    testWidgets('AcademyStatsBanner does not overflow on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestApp(
        const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: AcademyStatsBanner(
              grandTracksCount: 12,
              coursesCount: 49,
              lessonsCount: 302,
              quizzesCount: 118,
              overallMastery: 85.0,
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final err = tester.takeException();
      if (err is FlutterError) {
        print('FULL ERROR: ${err.diagnostics.map((d) => d.toString()).join('\n')}');
      }
      expect(err, isNull);

    });

    testWidgets('LearningHomeScreen tab 0, 1, 2, 3 on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(createTestApp(LearningHomeScreen(module: learningModule)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Tab 1: المسارات التخصصية
      await tester.tap(find.textContaining('المسارات').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Tab 2: فهرس المقررات
      await tester.tap(find.textContaining('المقررات').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Tab 3: رحلتي وإنجازاتي
      await tester.tap(find.textContaining('رحلتي').first);
      await tester.pumpAndSettle();
      final tabErr = tester.takeException();
      if (tabErr is FlutterError) {
        print('TAB3 ERROR: ${tabErr.diagnostics.map((d) => d.toString()).join('\n')}');
      }
      expect(tabErr, isNull);

    });

    testWidgets('LearningPathScreen on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final path = CanonicalLearningData.getPackage().paths.first;
      await tester.pumpWidget(createTestApp(LearningPathScreen(path: path, module: learningModule)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
