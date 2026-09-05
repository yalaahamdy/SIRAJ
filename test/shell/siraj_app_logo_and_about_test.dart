import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/shell/widgets/siraj_about_dialog.dart';
import 'package:siraj/shell/widgets/siraj_app_logo.dart';

void main() {
  group('SIRAJ v1.0 — Visual Identity & App Logo Integration Suite', () {
    Widget createTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: Center(child: child)),
      );
    }

    testWidgets('Logo 1: SirajAppLogo renders container with configured dimensions and border', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SirajAppLogo(
            size: 64,
            showBorder: true,
            showShadow: true,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SirajAppLogo), findsOneWidget);
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(SirajAppLogo),
        matching: find.byType(Container),
      ));
      expect(container.constraints?.maxWidth, 64);
      expect(container.constraints?.maxHeight, 64);
    });

    testWidgets('About 1: SirajAboutDialog renders brand identity, version, and security badges', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showSirajAboutDialog(context),
              child: const Text('افتح نافذة سِراج'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap button to open about dialog
      await tester.tap(find.text('افتح نافذة سِراج'));
      await tester.pumpAndSettle();

      // Verify dialog contents
      expect(find.byType(SirajAboutDialog), findsOneWidget);
      expect(find.text('سِراج — SIRAJ'), findsOneWidget);
      expect(find.text('الإصدار 1.0.0 (النسخة المستقرة المعيارية)'), findsOneWidget);
      expect(find.text('أوفلاين 100%'), findsOneWidget);
      expect(find.text('انعدام التتبع'), findsOneWidget);
      expect(find.text('أدلة موثقة'), findsOneWidget);

      // Verify closing dialog
      await tester.tap(find.text('إغلاق'));
      await tester.pumpAndSettle();

      expect(find.byType(SirajAboutDialog), findsNothing);
    });
  });
}
