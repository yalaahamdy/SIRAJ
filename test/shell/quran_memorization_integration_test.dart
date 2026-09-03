import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/quran/widgets/ayah_action_bottom_sheet.dart';
import 'package:siraj/shell/quran/widgets/ayah_view.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran -> Memorization Integration Suite (§56, §57, §88, §114)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);
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
        onGenerateRoute: AppRouter.generateRoute,
        home: child,
      );
    }

    testWidgets('Ayah Action Sheet offers Memorization linking with exact AyahKey', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          QuranReaderScreen(
            quranModule: quranModule,
            initialSurahNumber: 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap on first Ayah to open contextual action sheet
      final firstAyahView = find.byType(AyahView).first;
      await tester.tap(firstAyahView);
      await tester.pumpAndSettle();

      // Bottom sheet appears with memorization action
      expect(find.byType(AyahActionBottomSheet), findsOneWidget);
      expect(find.text('إضافة إلى خطة التحفيظ والتكرار المتباعد'), findsOneWidget);
      expect(find.text('نسخ نص الآية مع التوثيق'), findsOneWidget);
      expect(find.text('مشاركة مرجع الآية الشريفة'), findsOneWidget);
    });
  });
}
