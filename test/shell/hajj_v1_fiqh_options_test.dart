import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/modules/hajj/domain/fiqh_option.dart';
import 'package:siraj/shell/hajj/widgets/fiqh_options_box.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Fiqh Options Disclosure Suite (§38..§43, §122)', () {
    Widget createTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(body: child),
        ),
      );
    }

    testWidgets('Fiqh Options 1: Renders multiple schools and opinions without merging', (tester) async {
      const options = [
        FiqhOption(
          schoolOrScholar: 'الجمهور (مالك، الشافعي، أحمد)',
          positionArabic: 'يشترط الطهارة من الحدثين لصحة الطواف بالبيت.',
          evidenceSummary: 'حديث: الطواف بالبيت صلاة إلا أن الله أحل فيه الكلام.',
        ),
        FiqhOption(
          schoolOrScholar: 'الحنفية',
          positionArabic: 'الطهارة واجبة في الطواف وليست شرط صحة، فيجبر بدم أو صدقة.',
          evidenceSummary: 'الآية: وليطوفوا بالبيت العتيق، والأمر مطلق.',
        ),
      ];

      await tester.pumpWidget(createTestApp(const FiqhOptionsBox(options: options)));
      await tester.pumpAndSettle();

      expect(find.text('الخيارات والأقوال الفقهية المعتبرة (§9):'), findsOneWidget);
      expect(find.textContaining('الجمهور', findRichText: true), findsOneWidget);
      expect(find.textContaining('يشترط الطهارة من الحدثين', findRichText: true), findsOneWidget);
      expect(find.textContaining('الحنفية', findRichText: true), findsOneWidget);
      expect(find.textContaining('الطهارة واجبة في الطواف وليست شرط صحة', findRichText: true), findsOneWidget);
    });

    testWidgets('Fiqh Options 2: Renders empty SizedBox if no options exist', (tester) async {
      await tester.pumpWidget(createTestApp(const FiqhOptionsBox(options: [])));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsNothing);
    });
  });
}
