import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/shell/companion/federated_search_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 14: Unified Search Screen Suite (§3..§5, §93)', () {
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

    testWidgets('Search Screen 1: Renders FederatedSearchScreen with clear search bar and initial state', (tester) async {
      await tester.pumpWidget(createTestApp(FederatedSearchScreen(module: companionModule)));
      await tester.pumpAndSettle();

      expect(find.byType(FederatedSearchScreen), findsOneWidget);
      expect(find.text('البحث الشامل الموحد'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.textContaining('اكتب كلمة للبحث'), findsOneWidget);
    });
  });
}
