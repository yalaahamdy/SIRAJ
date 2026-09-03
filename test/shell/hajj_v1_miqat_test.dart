import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/miqat_guide_screen.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Miqat Guide Suite (§14..§19, §123)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
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
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      );
    }

    testWidgets('Miqat 1: Displays all 5 canonical Miqats with distances and regions', (tester) async {
      await tester.pumpWidget(createTestApp(MiqatGuideScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(find.text('دليل المواقيت المكانية الخمسة'), findsOneWidget);
      expect(find.text('ذو الحليفة'), findsOneWidget);
      expect(find.text('الجحفة'), findsOneWidget);
      expect(find.text('قرن المنازل'), findsOneWidget);

      // Scroll down for yalamlam and dhat irq
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('يلملم'), findsOneWidget);
      expect(find.text('ذات عِرق'), findsOneWidget);
    });

    testWidgets('Miqat 2: Computes and displays closest Miqat on demand with user location', (tester) async {
      // Near Medina (24.4, 39.5)
      await tester.pumpWidget(
        createTestApp(
          MiqatGuideScreen(
            module: hajjModule,
            userLatitude: 24.4,
            userLongitude: 39.5,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('أقرب ميقات لموقعك الجغرافي الحالي:'), findsOneWidget);
      expect(find.textContaining('ذو الحليفة'), findsWidgets);
    });
  });
}
