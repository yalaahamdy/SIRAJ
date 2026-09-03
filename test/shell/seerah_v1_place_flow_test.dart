import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/place_detail_screen.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Place Flow & Certainty Suite (§33..§36, §107)', () {
    late MemoryStorageRegistry storage;
    late SeerahModule seerahModule;

    setUp(() {
      storage = MemoryStorageRegistry();
      seerahModule = SeerahModule(storageRegistry: storage);
      seerahModule.mountPackage(SyntheticSeerahFixtures.createPackage());
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

    testWidgets('Place Flow 1: Displays historical place, modern verified name, and certainty level', (tester) async {
      final place = seerahModule.getAllPlaces().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          PlaceDetailScreen(
            place: place,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(place.nameArabic), findsWidgets);
      expect(find.text(place.certainty.labelArabic), findsOneWidget);
      expect(find.textContaining('إقليم: ${place.region}'), findsOneWidget);
      expect(find.textContaining('الاسم المعاصر المحقق: ${place.modernName!}'), findsOneWidget);
      expect(find.textContaining('موضع ماء معروف بين مكة والمدينة'), findsOneWidget);
    });
  });
}
