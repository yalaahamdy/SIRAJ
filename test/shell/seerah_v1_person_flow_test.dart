import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/person_detail_screen.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Person Flow & Sourced Relationships Suite (§26..§32, §107)', () {
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

    testWidgets('Person Flow 1: Displays canonical person info, dates, and sourced relationships', (tester) async {
      final person = seerahModule.getAllPersons().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          PersonDetailScreen(
            person: person,
            module: seerahModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(person.canonicalName), findsWidgets);
      expect(find.text('الصديق'), findsOneWidget);
      expect(find.textContaining('صحابي جليل وخليفة راشد'), findsOneWidget);
      expect(find.textContaining('الميلاد:'), findsOneWidget);
      expect(find.textContaining('الوفاة:'), findsOneWidget);
    });
  });
}
