import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Deep Linking Suite (§57, §58, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
      AppRouter.defaultSeerahModule = seerahModule;
    });

    Widget createTestApp(String initialRoute) {
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

    testWidgets('Deep Link 1: /seerah/timeline opens TimelineScreen directly', (tester) async {
      await tester.pumpWidget(createTestApp('/seerah/timeline'));
      await tester.pumpAndSettle();

      expect(find.text('المخطط الزمني للسيرة النبوية'), findsOneWidget);
    });

    testWidgets('Deep Link 2: /seerah/event/evt_badr_major opens EventDetailScreen directly', (tester) async {
      await tester.pumpWidget(createTestApp('/seerah/event/evt_badr_major'));
      await tester.pumpAndSettle();

      expect(find.textContaining('غزوة بدر الكبرى'), findsWidgets);
    });

    testWidgets('Deep Link 3: /seerah/person/person_abu_bakr opens PersonDetailScreen directly', (tester) async {
      await tester.pumpWidget(createTestApp('/seerah/person/person_abu_bakr'));
      await tester.pumpAndSettle();

      expect(find.textContaining('أبو بكر الصديق'), findsWidgets);
    });

    testWidgets('Deep Link 4: /seerah/place/place_badr opens PlaceDetailScreen directly', (tester) async {
      await tester.pumpWidget(createTestApp('/seerah/place/place_badr'));
      await tester.pumpAndSettle();

      expect(find.textContaining('بدر'), findsWidgets);
    });

    testWidgets('Deep Link 5: /seerah/invalid_path routes safely to Error Fallback', (tester) async {
      await tester.pumpWidget(createTestApp('/seerah/invalid_path_unknown'));
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.textContaining('الرابط المطلوب للسيرة والتاريخ الإسلامي غير صالح'), findsOneWidget);
      expect(find.text('العودة للسيرة'), findsOneWidget);
    });
  });
}
