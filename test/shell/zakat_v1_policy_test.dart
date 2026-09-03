import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/zakat/domain/zakat_policy.dart';
import 'package:siraj/modules/zakat/zakat_module.dart';
import 'package:siraj/shell/zakat/zakat_policy_screen.dart';

void main() {
  group('SIRAJ v1.0 — Sprint 9: Zakat Policy Selection & Disclosure Suite (§11..§15, §134)', () {
    late MemoryStorageRegistry registry;
    late ZakatModule zakatModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      zakatModule = ZakatModule(storageRegistry: registry);
    });

    Widget createTestApp(Widget child) {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ar', 'SA')],
        locale: const Locale('ar', 'SA'),
        home: child,
      );
    }

    testWidgets('Policy 1: Renders policy disclosure and available canonical options', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatPolicyScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      expect(find.text('السياسات الفقهية لحساب الزكاة'), findsOneWidget);
      expect(find.textContaining('السياسة المحددة للحساب'), findsOneWidget);
      expect(find.text(ZakatPolicy.goldStandard.nameArabic), findsOneWidget);
      expect(find.text(ZakatPolicy.silverStandard.nameArabic), findsOneWidget);
      expect(find.textContaining('مجمع الفقه الإسلامي الدولي'), findsWidgets);
    });

    testWidgets('Policy 2: Selecting silver policy updates active policy in module', (tester) async {
      await tester.pumpWidget(createTestApp(ZakatPolicyScreen(module: zakatModule)));
      await tester.pumpAndSettle();

      await tester.tap(find.text(ZakatPolicy.silverStandard.nameArabic));
      await tester.pumpAndSettle();

      final active = await zakatModule.getActivePolicy();
      expect(active.policyId, ZakatPolicy.silverStandard.policyId);
    });
  });
}
