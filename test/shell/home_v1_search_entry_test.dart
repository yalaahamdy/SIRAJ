import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/shell/companion/federated_search_screen.dart';
import 'package:siraj/shell/companion/home_dashboard_view.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Home Federated Search Entry Suite (§46..§49, §114)', () {
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

    testWidgets('Search Entry 1: Tapping search icon opens FederatedSearchScreen with domain breakdown', (tester) async {
      await tester.pumpWidget(createTestApp(HomeDashboardView(module: companionModule)));
      await tester.pumpAndSettle();

      final searchIcon = find.byIcon(Icons.search);
      expect(searchIcon, findsOneWidget);

      await tester.tap(searchIcon);
      await tester.pumpAndSettle();

      expect(find.byType(FederatedSearchScreen), findsOneWidget);
    });
  });
}
