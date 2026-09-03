import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/tools/siraj_tools.dart';
import 'package:siraj/services/bot/tools/tool_definition.dart';
import 'package:siraj/services/bot/tools/tool_registry.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

class AdminTestTool extends BotToolDefinition {
  @override
  String get name => 'admin_reset_system';
  @override
  String get descriptionArabic => 'أداة إدارية حساسة';
  @override
  ToolPermissionLevel get permissionLevel => ToolPermissionLevel.adminOnly;

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    return ToolResult.success('RESET_OK');
  }
}

void main() {
  group('L3 Bot Tools & Permissions Tests (§18, §25, §73-§82)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late BotToolRegistry toolRegistry;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      toolRegistry = BotToolRegistry(tools: [
        PrayerTool(),
        QuranTool(),
        MemorizationTool(),
        AdhkarTool(adhkarModule),
        ZakatTool(),
        FastingTool(),
        KnowledgeTool(knowledgeModule),
        LearningTool(),
        SeerahTool(),
        HajjTool(),
        AdminTestTool(),
      ]);
    });

    test('Executes public verified read tools safely', () async {
      final prayerRes = await toolRegistry.executeTool(
        toolName: 'get_prayer_schedule',
        arguments: {},
      );
      expect(prayerRes.isSuccess, isTrue);
      expect(prayerRes.outputTextArabic, contains('مواقيت الصلاة'));

      final adhkarRes = await toolRegistry.executeTool(
        toolName: 'get_adhkar',
        arguments: {'query': 'صباح'},
      );
      expect(adhkarRes.isSuccess, isTrue);
      expect(adhkarRes.outputTextArabic, contains('أَصْبَحْنَا'));

      final hadithRes = await toolRegistry.executeTool(
        toolName: 'search_hadith_knowledge',
        arguments: {'query': 'النية'},
      );
      expect(hadithRes.isSuccess, isTrue);
      expect(hadithRes.outputTextArabic, contains('النية'));
    });

    test('Rejects admin-only tool execution from non-admin caller', () async {
      final adminRes = await toolRegistry.executeTool(
        toolName: 'admin_reset_system',
        arguments: {},
        isAdmin: false,
      );

      expect(adminRes.isSuccess, isFalse);
      expect(adminRes.errorMessageArabic, contains('هذه الأداة مخصصة للإدارة فقط'));
    });
  });
}
