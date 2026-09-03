import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/quran/quran_reader_screen.dart';
import 'package:siraj/shell/routing/app_router.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 2: Quran Deep Linking Suite (§63, §64, §87)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      quranModule = QuranModule(storageRegistry: storage);
      final package = CanonicalQuranFixture.createValidTestPackage();
      quranModule.mountPackage(package);
      AppRouter.defaultQuranModule = quranModule;
    });

    tearDown(() {
      AppRouter.defaultQuranModule = null;
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

    testWidgets('Deep Link 1: /quran/1:1 routes directly to Surah 1 in Reader', (tester) async {
      await tester.pumpWidget(createTestApp('/quran/1:1'));
      await tester.pumpAndSettle();

      expect(find.byType(QuranReaderScreen), findsOneWidget);
      expect(find.text('سورة الفاتحة'), findsWidgets);
    });

    testWidgets('Deep Link 2: /quran/114 routes directly to Surah 114 (An-Nas)', (tester) async {
      await tester.pumpWidget(createTestApp('/quran/114'));
      await tester.pumpAndSettle();

      expect(find.byType(QuranReaderScreen), findsOneWidget);
      expect(find.text('سورة الناس'), findsWidgets);
    });

    testWidgets('Deep Link 3: Invalid route /quran/999:999 shows safe error page without crash', (tester) async {
      await tester.pumpWidget(createTestApp('/quran/999:999'));
      await tester.pumpAndSettle();

      expect(find.text('رابط غير صالح'), findsOneWidget);
      expect(find.textContaining('الرابط القرآني المطلوب غير صالح'), findsOneWidget);
      expect(find.text('العودة'), findsOneWidget);
    });
  });
}
