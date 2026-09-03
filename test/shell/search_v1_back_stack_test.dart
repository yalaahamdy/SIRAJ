import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/shell/companion/federated_search_screen.dart';
import 'package:siraj/shell/companion/home_dashboard_view.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Search Back-Stack & Navigation Return Suite (§37..§40, §93)', () {
    late MemoryStorageRegistry storage;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: storage);
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

    testWidgets('Back Stack 1: Navigating to search from Home and returning restores Home view seamlessly', (tester) async {
      await tester.pumpWidget(createTestApp(HomeDashboardView(module: companionModule)));
      await tester.pumpAndSettle();

      // Tap search icon
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(FederatedSearchScreen), findsOneWidget);

      // Pop back
      Navigator.pop(tester.element(find.byType(FederatedSearchScreen)));
      await tester.pumpAndSettle();

      expect(find.byType(HomeDashboardView), findsOneWidget);
    });
  });
}
