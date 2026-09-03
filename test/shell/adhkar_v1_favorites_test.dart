import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/shell/adhkar/adhkar_home_screen.dart';
import 'package:siraj/shell/adhkar/dhikr_detail_screen.dart';
import '../fixtures/adhkar/canonical_adhkar_fixture.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 3: Adhkar Favorites Suite (§29..§32, §93)', () {
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

    testWidgets('Favorites Flow: Adding Dhikr to favorites makes it visible in Favorites Tab', (tester) async {
      final itemsRes = module.getAllItems();
      final item = itemsRes.valueOrNull!.first;

      // 1. Open Dhikr detail and toggle favorite
      await tester.pumpWidget(createTestApp(DhikrDetailScreen(item: item, module: module)));
      await tester.pumpAndSettle();

      final favButton = find.byTooltip('إضافة إلى المفضلة');
      expect(favButton, findsOneWidget);
      await tester.tap(favButton);
      await tester.pumpAndSettle();

      // Verify favorite is saved in module
      final isFavRes = await module.isFavorite(item.id);
      expect(isFavRes.isSuccess, isTrue);
      expect(isFavRes.valueOrNull, isTrue);

      // 2. Open AdhkarHomeScreen and switch to Favorites Tab
      await tester.pumpWidget(createTestApp(AdhkarHomeScreen(module: module)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('المفضلة'));
      await tester.pumpAndSettle();

      // Favorite item is listed
      expect(find.text(item.textArabic), findsOneWidget);
    });
  });
}
