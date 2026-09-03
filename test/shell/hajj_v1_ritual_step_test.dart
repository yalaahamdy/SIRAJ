import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/hajj/hajj_module.dart';
import 'package:siraj/shell/hajj/ritual_step_detail_screen.dart';
import 'package:siraj/shell/hajj/widgets/fiqh_options_box.dart';
import '../fixtures/hajj/synthetic_hajj_fixtures.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 8: Ritual Step Detail Suite (§28..§32, §62, §63, §107)', () {
    late MemoryStorageRegistry registry;
    late HajjModule hajjModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      hajjModule = HajjModule(storageRegistry: registry);
      hajjModule.mountPackage(SyntheticHajjFixtures.createPackage());
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
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: child,
        ),
      );
    }

    testWidgets('Ritual Step 1: Displays Title, Phase, Requirement, Description, and Sources', (tester) async {
      final step = hajjModule.getStep('step_umrah_tawaf').valueOrNull!;

      await tester.pumpWidget(
        createTestApp(
          RitualStepDetailScreen(
            step: step,
            module: hajjModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('طواف العمرة (سبعة أشواط)'), findsWidgets);
      expect(find.text('ركن / واجب'), findsOneWidget);
      expect(find.text('الصفة والبيان الإرشادي (§8):'), findsOneWidget);
      expect(find.byType(FiqhOptionsBox), findsOneWidget);
      expect(find.text('التوثيق والمصادر المعتمدة (§41, §42):'), findsOneWidget);
    });

    testWidgets('Ritual Step 2: Saves and loads local personal notes securely', (tester) async {
      final step = hajjModule.getStep('step_umrah_tawaf').valueOrNull!;

      await tester.pumpWidget(
        createTestApp(
          RitualStepDetailScreen(
            step: step,
            module: hajjModule,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Scroll to personal note
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('ملاحظاتك وتذكيراتك الشخصية:'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'البدء من محاذاة الحجر الأسود');
      await tester.tap(find.text('حفظ الملاحظة'));
      await tester.pumpAndSettle();

      final prog = (await hajjModule.getUserProgress()).valueOrNull!;
      expect(prog.userNotes[step.stepId], equals('البدء من محاذاة الحجر الأسود'));
    });
  });
}
