import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/seerah/seerah_module.dart';
import 'package:siraj/shell/seerah/event_detail_screen.dart';
import 'package:siraj/shell/seerah/widgets/moral_lesson_card.dart';
import 'package:siraj/shell/seerah/widgets/narrative_variant_box.dart';
import '../../test/fixtures/seerah/synthetic_seerah_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 7: Seerah Event Flow & Segregation Suite (§12..§16, §107)', () {
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

    testWidgets('Event Flow 1: Event detail strictly segregates historical fact, variants, and moral lessons', (tester) async {
      final event = seerahModule.getAllEvents().valueOrNull!.first;

      await tester.pumpWidget(
        createTestApp(
          EventDetailScreen(
            event: event,
            module: seerahModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title & Evidence Level
      expect(find.text(event.title), findsWidgets);
      expect(find.text('مصدر أصيل مباشر'), findsOneWidget);
      expect(find.textContaining('17 رمضان 2 هـ'), findsOneWidget);

      // Narrative Variants
      expect(find.byType(NarrativeVariantBox), findsOneWidget);
      expect(find.textContaining('موسى بن عقبة'), findsWidgets);

      // Scroll down to see Moral Lessons and local user notes
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();

      // Moral Lesson
      expect(find.byType(MoralLessonCard), findsOneWidget);
      expect(find.text('استنباط تربوي'), findsOneWidget);
      expect(find.textContaining('التوكل والأخذ بالأسباب'), findsOneWidget);
    });
  });
}
