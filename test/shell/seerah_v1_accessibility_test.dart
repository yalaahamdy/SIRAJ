import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/event_detail_screen.dart';
import 'package:siraj/shell/seerah/seerah_home_screen.dart';
import 'package:siraj/shell/seerah/timeline_screen.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Accessibility Suite (§81..§85, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    Widget createAccessibleApp(Widget child, {double textScale = 1.5}) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: child,
        ),
      );
    }

    testWidgets('Accessibility 1: Seerah screens render cleanly without overflow at 1.5x font scale', (tester) async {
      await tester.pumpWidget(
        createAccessibleApp(
          SeerahHomeScreen(module: seerahModule),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('السيرة النبوية والتاريخ الإسلامي'), findsOneWidget);

      await tester.pumpWidget(
        createAccessibleApp(
          TimelineScreen(module: seerahModule),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المخطط الزمني للسيرة النبوية'), findsOneWidget);

      final event = seerahModule.getAllEvents().valueOrNull!.first;
      await tester.pumpWidget(
        createAccessibleApp(
          EventDetailScreen(event: event, module: seerahModule),
          textScale: 1.5,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(event.title), findsWidgets);
    });
  });
}
