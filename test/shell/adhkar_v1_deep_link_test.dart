import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import 'package:siraj/shell/adhkar/occasion_adhkar_screen.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Deep Linking Suite (§39, §40, §95)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      module.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());
      AppRouter.defaultAdhkarModule = module;
    });

    tearDown(() {
      AppRouter.defaultAdhkarModule = null;
    });

    Widget createTestApp(String initialRoute) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: initialRoute,
        onGenerateRoute: AppRouter.generateRoute,
      );
    }

    testWidgets('Deep Link 1: /adhkar routes to AdhkarHomeScreen', (tester) async {
      await tester.pumpWidget(createTestApp('/adhkar'));
      await tester.pumpAndSettle();

      expect(find.byType(AdhkarHomeScreen), findsOneWidget);
    });

    testWidgets('Deep Link 2: /adhkar/occasion/morning routes to OccasionAdhkarScreen', (tester) async {
      await tester.pumpWidget(createTestApp('/adhkar/occasion/morning'));
      await tester.pumpAndSettle();

      expect(find.byType(OccasionAdhkarScreen), findsOneWidget);
    });

    testWidgets('Deep Link 3: /adhkar/dhikr_morning_001 routes to DhikrDetailScreen', (tester) async {
      await tester.pumpWidget(createTestApp('/adhkar/dhikr_morning_001'));
      await tester.pumpAndSettle();

      expect(find.byType(DhikrDetailScreen), findsOneWidget);
    });

    testWidgets('Deep Link 4: Invalid deep link /adhkar/non_existent_item shows safe error page', (tester) async {
      await tester.pumpWidget(createTestApp('/adhkar/non_existent_item'));
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.text('العودة للأذكار'), findsOneWidget);
    });
  });
}
