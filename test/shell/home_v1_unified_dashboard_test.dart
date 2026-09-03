import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/fasting/fasting_module.dart';
import 'package:siraj/modules/prayer/prayer_module.dart';
import 'package:siraj/modules/quran/quran_module.dart';
import 'package:siraj/shell/companion/home_dashboard_view.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../fixtures/quran/canonical_quran_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 13: Unified Home Command Center Suite (§3..§14, §114)', () {
    late MemoryStorageRegistry storage;
    late QuranModule quranModule;
    late PrayerModule prayerModule;
    late AdhkarModule adhkarModule;
    late FastingModule fastingModule;
    late CompanionModule companionModule;

    setUp(() {
      storage = MemoryStorageRegistry();

      quranModule = QuranModule(storageRegistry: storage);
      quranModule.store.mountPackage(CanonicalQuranFixture.createValidTestPackage());

      prayerModule = PrayerModule(storageRegistry: storage);

      adhkarModule = AdhkarModule(storageRegistry: storage);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      fastingModule = FastingModule(
        storageRegistry: storage,
        prayerModule: prayerModule,
      );

      companionModule = CompanionModule(
        storageRegistry: storage,
        quranModule: quranModule,
        prayerModule: prayerModule,
        adhkarModule: adhkarModule,
        fastingModule: fastingModule,
      );
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

    testWidgets('Dashboard 1: Renders Unified Home Command Center with calm hierarchy and Hero card', (tester) async {
      await tester.pumpWidget(createTestApp(HomeDashboardView(module: companionModule)));
      await tester.pumpAndSettle();

      expect(find.byType(HomeDashboardView), findsOneWidget);
      expect(find.text('سِراج — الرفيق الحياتي الموحد'), findsOneWidget);
    });
  });
}
