import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/learning/learning_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/modules/quran/services/cairo_radio_audio_service.dart';
import 'package:siraj/shell/audio/siraj_audio_hub_screen.dart';
import 'package:siraj/shell/companion/home_dashboard_view.dart';
import 'package:siraj/shell/learning/learning_home_screen.dart';
import 'package:siraj/shell/learning/learning_path_screen.dart';
import 'package:siraj/shell/learning/lesson_screen.dart';
import 'package:siraj/shell/learning/quiz_screen.dart';
import 'package:siraj/shell/quran/widgets/cairo_radio_live_view.dart';
import 'package:siraj/shell/quran/widgets/tawasheeh_player_view.dart';
import 'package:siraj/shell/seed/data/canonical_learning_data.dart';
import '../../test/fixtures/learning/synthetic_learning_fixtures.dart';

void main() {
  group('Small Screen (320x568) Layout & Render Test', () {
    late MemoryStorageRegistry storage;
    late LearningModule learningModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      learningModule = LearningModule(storageRegistry: storage);
      learningModule.mountPackage(CanonicalLearningData.getPackage());
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

    testWidgets('HomeDashboardView on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final companionModule = CompanionModule(storageRegistry: storage);
      await tester.pumpWidget(createTestApp(HomeDashboardView(module: companionModule)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('CairoRadioLiveView on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final radioService = CairoRadioAudioService.instance;
      await tester.pumpWidget(createTestApp(Scaffold(body: CairoRadioLiveView(radioService: radioService))));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('SirajAudioHubScreen on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quranModule = QuranModule(storageRegistry: storage);
      await tester.pumpWidget(createTestApp(SirajAudioHubScreen(
        quranModule: quranModule,
        onOpenSurah: (_, {targetAyah, targetPage}) {},
      )));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });


    testWidgets('QuizScreen on 320px width', (tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final quiz = CanonicalLearningData.getPackage().quizzes.first;
      await tester.pumpWidget(createTestApp(QuizScreen(quiz: quiz, module: learningModule)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
