import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/seerah_home_screen.dart';
import 'package:siraj/shell/seerah/widgets/event_card.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Home Hub Suite (§4, §5, §107)', () {
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

    testWidgets('Seerah Home 1: Displays Events, Persons, Places tabs and Timeline button', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          SeerahHomeScreen(module: seerahModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('السيرة النبوية والتاريخ الإسلامي'), findsOneWidget);
      expect(find.text('الأحداث والوقائع'), findsOneWidget);
      expect(find.text('الشخصيات'), findsOneWidget);
      expect(find.text('الأماكن والمواقع'), findsOneWidget);

      // Events tab content
      expect(find.byType(EventCard), findsOneWidget);
      expect(find.textContaining('غزوة بدر الكبرى'), findsOneWidget);

      // Switch to Persons Tab
      await tester.tap(find.text('الشخصيات'));
      await tester.pumpAndSettle();

      expect(find.textContaining('أبو بكر الصديق'), findsOneWidget);

      // Switch to Places Tab
      await tester.tap(find.text('الأماكن والمواقع'));
      await tester.pumpAndSettle();

      expect(find.textContaining('بدر'), findsWidgets);
    });

    testWidgets('Seerah Home 2: Displays Continue Seerah card when last viewed event exists', (tester) async {
      await seerahModule.markEventViewed('evt_badr_major');

      await tester.pumpWidget(
        createTestApp(
          SeerahHomeScreen(module: seerahModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('متابعة قراءة السيرة'), findsOneWidget);
      expect(find.textContaining('غزوة بدر الكبرى'), findsWidgets);
    });
  });
}
