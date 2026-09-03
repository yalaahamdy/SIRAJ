import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Display Fidelity Forensic Suite (§10, §11, §89)', () {
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

    testWidgets('Display Fidelity: Canonical Arabic Dhikr text reaches Text widget bit-for-bit without mutation', (tester) async {
      final itemsRes = module.getAllItems();
      expect(itemsRes.isSuccess, isTrue);
      final item = itemsRes.valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          DhikrDetailScreen(
            item: item,
            module: module,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify exact canonical text is rendered in Text widget
      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      final renderedCanonicalText = textWidgets.firstWhere((t) => t.data == item.textArabic);

      expect(renderedCanonicalText.data, equals(item.textArabic));
      expect(renderedCanonicalText.data!.runes.toList(), equals(item.textArabic.runes.toList()));
    });
  });
}
