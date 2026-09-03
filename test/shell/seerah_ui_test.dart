import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/event_detail_screen.dart';
import 'package:siraj/shell/seerah/seerah_home_screen.dart';
import '../fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('L4 Seerah Shell UI & Interaction Tests (§36, §37)', () {
    late MemoryStorageRegistry registry;
    late SeerahModule seerahModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: registry);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
    });

    testWidgets('SeerahHomeScreen renders tabs, timeline hero card, and event list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: SeerahHomeScreen(module: seerahModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('السيرة النبوية والتاريخ الإسلامي'), findsOneWidget);
      expect(find.text('الأحداث والوقائع'), findsOneWidget);
      expect(find.text('الشخصيات'), findsOneWidget);
      expect(find.text('الأماكن والمواقع'), findsOneWidget);
      expect(find.text('غزوة بدر الكبرى (يوم الفرقان)'), findsOneWidget);
      expect(find.text('مصدر أصيل مباشر'), findsOneWidget);
    });

    testWidgets('Tapping event card navigates to EventDetailScreen and displays variants and lessons', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: SeerahHomeScreen(module: seerahModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('غزوة بدر الكبرى (يوم الفرقان)'));
      await tester.pumpAndSettle();

      expect(find.byType(EventDetailScreen), findsOneWidget);
      expect(find.text('رواية: موسى بن عقبة'), findsOneWidget);
      expect(find.text('العبرة والمقصد: التوكل والأخذ بالأسباب'), findsOneWidget);
    });
  });
}
