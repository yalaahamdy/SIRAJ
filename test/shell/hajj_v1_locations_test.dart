import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/sacred_locations_screen.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Sacred Locations Suite (§50..§52, §107)', () {
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

    testWidgets('Sacred Locations 1: Displays canonical locations with descriptions and context', (tester) async {
      await tester.pumpWidget(createTestApp(SacredLocationsScreen(module: hajjModule)));
      await tester.pumpAndSettle();

      expect(find.text('المشاعر والمواقع المقدسة'), findsOneWidget);
      expect(find.text('المسجد الحرام والكعبة المشرفة'), findsOneWidget);
      expect(find.text('الصفا والمروة (المسعى)'), findsOneWidget);
      expect(find.text('مشعر مِنَى'), findsOneWidget);

      // Scroll down for Arafat, Muzdalifah, and Jamarat
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      expect(find.text('مشعر عرفات (وجبل الرحمة ومسجد نمرة)'), findsOneWidget);
      expect(find.text('مشعر مزدلفة (المشعر الحرام)'), findsOneWidget);
    });
  });
}
