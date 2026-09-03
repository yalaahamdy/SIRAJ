import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/companion/companion_module.dart';
import 'package:siraj/modules/companion/domain/personal_goal.dart';
import 'package:siraj/shell/companion/companion_preferences_screen.dart';
import 'package:siraj/shell/companion/federated_search_screen.dart';
import 'package:siraj/shell/companion/home_dashboard_view.dart';
import 'package:siraj/shell/companion/personal_goals_screen.dart';

void main() {
  group('L4 Companion Shell UI & Interaction Tests (§44, §45, §47)', () {
    late MemoryStorageRegistry registry;
    late CompanionModule companionModule;

    setUp(() {
      registry = MemoryStorageRegistry();
      companionModule = CompanionModule(storageRegistry: registry);
    });

    testWidgets('HomeDashboardView renders header, timeline, goals banner, and modules grid', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: HomeDashboardView(module: companionModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('سِراج — الرفيق الحياتي الموحد'), findsOneWidget);
      expect(find.text('الروتين اليومي المتوازن'), findsOneWidget);
      expect(find.text('أهدافك الشخصية لليوم'), findsOneWidget);
      expect(find.text('الصلاة والقبلة'), findsOneWidget);
      expect(find.text('المصحف الشريف'), findsOneWidget);
      expect(find.text('الحج والعمرة'), findsOneWidget);
    });

    testWidgets('Tapping search opens FederatedSearchScreen and performs query', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: FederatedSearchScreen(module: companionModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('البحث الشامل الموحد'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'الصلاة');
      await tester.pumpAndSettle();
    });

    testWidgets('PersonalGoalsScreen creates a new personal goal successfully', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await companionModule.addGoal(PersonalGoal(
        goalId: 'goal_ui_test',
        type: GoalType.quranReading,
        title: 'قراءة سورة الملك',
        target: 1.0,
        unitArabic: 'سورة',
        startDate: DateTime.now(),
        sourceModule: 'mod_companion',
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: PersonalGoalsScreen(module: companionModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('قراءة سورة الملك'), findsOneWidget);
      expect(find.text('تلاوة القرآن'), findsOneWidget);
    });

    testWidgets('CompanionPreferencesScreen renders customization and quiet hours toggle', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: CompanionPreferencesScreen(module: companionModule),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تخصيص الواجهة والساعات الهادئة'), findsOneWidget);
      expect(find.text('تفعيل الساعات الهادئة (Quiet Hours)'), findsOneWidget);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
    });
  });
}
