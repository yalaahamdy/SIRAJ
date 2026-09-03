import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/shell/v1_app_shell.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: 5-Tab Navigation & Universal Return Suite (§50..§55, §114)', () {
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

    testWidgets('Navigation 1: Switching tabs preserves shell navigation stack and returns home cleanly', (tester) async {
      await tester.pumpWidget(createTestApp(V1AppShell(storageRegistry: MemoryStorageRegistry())));
      await tester.pumpAndSettle();

      // Home
      expect(find.text('الرئيسية'), findsWidgets);

      // Tap Prayer Tab
      await tester.tap(find.text('الصلاة'));
      await tester.pumpAndSettle();
      expect(find.text('مواقيت الصلاة'), findsWidgets);

      // Tap Back to Home
      await tester.tap(find.text('الرئيسية'));
      await tester.pumpAndSettle();
      expect(find.text('سِراج — الرفيق الحياتي الموحد'), findsOneWidget);
    });
  });
}
