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
  group('SIRAJ v1.0 — Sprint 7: Seerah Responsive Form Factors Suite (§86, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    Widget createResponsiveApp(Widget child, Size size) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: MediaQuery(
          data: MediaQueryData(size: size),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: child,
          ),
        ),
      );
    }

    testWidgets('Responsive 1: Small Phone (360x640) renders Seerah cleanly', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          SeerahHomeScreen(module: seerahModule),
          const Size(360, 640),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('السيرة النبوية والتاريخ الإسلامي'), findsOneWidget);

      await tester.pumpWidget(
        createResponsiveApp(
          TimelineScreen(module: seerahModule),
          const Size(360, 640),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المخطط الزمني للسيرة النبوية'), findsOneWidget);

      final event = seerahModule.getAllEvents().valueOrNull!.first;
      await tester.pumpWidget(
        createResponsiveApp(
          EventDetailScreen(event: event, module: seerahModule),
          const Size(360, 640),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(event.title), findsWidgets);
    });

    testWidgets('Responsive 2: Large Phone (412x915) renders cleanly', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          SeerahHomeScreen(module: seerahModule),
          const Size(412, 915),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('السيرة النبوية والتاريخ الإسلامي'), findsOneWidget);
    });

    testWidgets('Responsive 3: Tablet/Desktop (1024x768) renders cleanly', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        createResponsiveApp(
          TimelineScreen(module: seerahModule),
          const Size(1024, 768),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('المخطط الزمني للسيرة النبوية'), findsOneWidget);
    });
  });
}
