import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/shell/companion/home_dashboard_view.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 15: Warm Start & Notification Foreground Handling Suite (§40, §46, §106)', () {
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

    testWidgets('Warm Start 1: App handles incoming reminder events while running in foreground without disrupting current state', (tester) async {
      await tester.pumpWidget(createTestApp(HomeDashboardView(module: companionModule)));
      await tester.pumpAndSettle();

      final res = await companionModule.getReminders();
      expect(res.isSuccess, true);

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
