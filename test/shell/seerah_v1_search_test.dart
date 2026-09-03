import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/seerah_home_screen.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Search Suite (§37..§45, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
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

    testWidgets('Seerah Search 1: Typing search query retrieves matching events, persons, and places with provenance tags', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          SeerahHomeScreen(module: seerahModule),
        ),
      );
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'بدر');
      await tester.pumpAndSettle();

      expect(find.textContaining('غزوة بدر الكبرى'), findsOneWidget);
      expect(find.textContaining('مصدر أصيل مباشر'), findsWidgets);
    });
  });
}
