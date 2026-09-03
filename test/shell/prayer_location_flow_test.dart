import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/shell/prayer/prayer_screen.dart';
import 'package:siraj/shell/prayer/widgets/location_selection_dialog.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 1: Location Flow & Privacy Suite (§10, §11, §39, §46)', () {
    late MemoryStorageRegistry storage;
    late PrayerModule prayerModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      prayerModule = PrayerModule(storageRegistry: storage);
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

    testWidgets('Location dialog opens with privacy disclosure and city presets', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(prayerModule: prayerModule),
        ),
      );
      await tester.pumpAndSettle();

      // Tap location button in AppBar
      await tester.tap(find.byIcon(Icons.location_on_outlined));
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.byType(LocationSelectionDialog), findsOneWidget);
      expect(find.text('تحديد الموقع الجغرافي'), findsOneWidget);
      expect(find.textContaining('حساب مواقيت الصلاة والقبلة يتم محلياً بالكامل'), findsOneWidget);
      expect(find.text('مكة المكرمة'), findsOneWidget);
      expect(find.text('القدس الشريف'), findsOneWidget);
    });

    testWidgets('Selecting a preset city updates location header and recalculates times', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          PrayerScreen(prayerModule: prayerModule),
        ),
      );
      await tester.pumpAndSettle();

      // Open location dialog
      await tester.tap(find.byIcon(Icons.location_on_outlined));
      await tester.pumpAndSettle();

      // Tap 'مكة المكرمة'
      await tester.tap(find.text('مكة المكرمة'));
      await tester.pumpAndSettle();

      // Dialog is dismissed and new coordinates are reflected
      expect(find.byType(LocationSelectionDialog), findsNothing);
      expect(find.textContaining('21.42°'), findsOneWidget);
    });
  });
}
