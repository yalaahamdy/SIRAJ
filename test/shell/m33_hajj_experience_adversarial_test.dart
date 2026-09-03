import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/domain/journey_type.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: M33 Hajj Experience Adversarial Suite (§126)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
      AppRouter.defaultHajjModule = hajjModule;
    });

    Widget createTestApp({required String initialRoute}) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: initialRoute,
      );
    }

    test('Adversarial 1: Invalid step request fails safely with Failure result', () {
      final res = hajjModule.getStep('non_existent_fake_step');
      expect(res.isFailure, isTrue);
    });

    test('Adversarial 2: Unmounted store fails closed safely without crashing', () {
      final unmountedMod = HajjModule(storageRegistry: registry);
      final res = unmountedMod.getStepsForJourney(JourneyType.umrah);
      expect(res.isFailure, isTrue);
    });

    test('Adversarial 3: Corrupt JSON in storage recovers safely to default state', () async {
      final store = registry.getStoreForModule('mod_hajj');
      await store.setString('hajj_user_progress', '{corrupted_invalid_json');

      final progRes = await hajjModule.getUserProgress();
      expect(progRes.isFailure, isTrue);
    });

    testWidgets('Adversarial 4: Invalid deep link /hajj/fake_route renders safe error screen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj/fake_route'));
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.text('الرابط المطلوب للحج والعمرة غير صالح.'), findsOneWidget);
      expect(find.text('العودة للحج والعمرة'), findsOneWidget);
    });

    testWidgets('Adversarial 5: Invalid step deep link /hajj/step/unknown renders safe error screen', (tester) async {
      await tester.pumpWidget(createTestApp(initialRoute: '/hajj/step/unknown_step_123'));
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.text('الرابط المطلوب للحج والعمرة غير صالح.'), findsOneWidget);
    });

    test('Adversarial 6: Canonical shield ensures user progress changes do not mutate canonical steps', () async {
      final before = hajjModule.getStep('step_umrah_ihram').valueOrNull!;
      await hajjModule.markStepCompleted('step_umrah_ihram');
      await hajjModule.saveUserNote('step_umrah_ihram', 'ملاحظة تجريبية');

      final after = hajjModule.getStep('step_umrah_ihram').valueOrNull!;
      expect(after.title, equals(before.title));
      expect(after.description, equals(before.description));
    });
  });
}
