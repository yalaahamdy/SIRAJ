import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/adhkar/domain/dhikr_occasion.dart';
import 'package:siraj/modules/adhkar/services/dhikr_occasion_engine.dart';
import 'package:siraj/shell/adhkar/occasion_adhkar_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 12: Occasion Engine & Category Flow Suite (§4..§7, §116, §119)', () {
    late MemoryStorageRegistry storage;
    late AdhkarModule module;

    setUp(() {
      storage = MemoryStorageRegistry();
      module = AdhkarModule(storageRegistry: storage);
      final package = CanonicalAdhkarFixture.createValidTestPackage();
      module.mountPackage(package);
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

    test('Occasion 1: DhikrOccasionEngine returns correct occasion according to time of day', () {
      const engine = DhikrOccasionEngine();
      final morningTime = DateTime.utc(2026, 9, 1, 7, 30);
      final eveningTime = DateTime.utc(2026, 9, 1, 17, 30);
      final sleepTime = DateTime.utc(2026, 9, 1, 23, 0);

      expect(engine.resolveCurrentOccasion(customTime: morningTime), DhikrOccasion.morning);
      expect(engine.resolveCurrentOccasion(customTime: eveningTime), DhikrOccasion.evening);
      expect(engine.resolveCurrentOccasion(customTime: sleepTime), DhikrOccasion.sleep);
    });

    testWidgets('Occasion 2: Occasion screen displays items and labels for morning adhkar', (tester) async {
      await tester.pumpWidget(createTestApp(OccasionAdhkarScreen(occasion: DhikrOccasion.morning, module: module)));
      await tester.pumpAndSettle();

      expect(find.text(DhikrOccasion.morning.labelArabic), findsWidgets);
    });
  });
}
