import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/timeline_screen.dart';
import 'package:siraj/shell/seerah/widgets/event_card.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Timeline Suite (§6..§11, §107)', () {
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

    testWidgets('Timeline 1: Renders sequenced periods and historical events through SeerahTimelineEngine', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          TimelineScreen(module: seerahModule),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('المخطط الزمني للسيرة النبوية'), findsOneWidget);
      expect(find.textContaining('العهد المدني'), findsOneWidget);
      expect(find.byType(EventCard), findsOneWidget);
      expect(find.textContaining('غزوة بدر الكبرى'), findsOneWidget);
    });
  });
}
