import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Search Engine & Filters Suite (§33..§38, §94)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
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

    testWidgets('Search Flow 1: Typing search query shows matching canonical results', (tester) async {
      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'اصبحنا');
      await tester.pumpAndSettle();

      expect(find.textContaining('أَصْبَحْنَا'), findsWidgets);
    });

    testWidgets('Search Flow 2: Non-matching query renders empty state cleanly', (tester) async {
      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'نص_غير_موجود_في_الأذكار_xyz');
      await tester.pumpAndSettle();

      expect(find.text('لا توجد نتائج مطابقة للبحث'), findsOneWidget);
    });
  });
}
