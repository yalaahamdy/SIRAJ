import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/gateway/bot_gateway.dart';
import 'package:siraj/services/bot/gateway/bot_quota_service.dart';
import 'package:siraj/services/bot/session/bot_session_store.dart';
import 'package:siraj/services/bot/siraj_bot_platform.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M14 Bot Concurrency, Load & Chaos Benchmark Tests (§60, §61, §62)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late MemoryBotSessionStore sessionStore;
    late BotGateway gateway;
    late SirajBotPlatform platform;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      sessionStore = MemoryBotSessionStore();
      gateway = BotGateway(
        quotaService: BotQuotaService(
          maxRequestsPerMinutePerUser: 1000,
          maxRequestsPerMinutePerChannel: 5000,
        ),
      );

      platform = SirajBotPlatform(
        gateway: gateway,
        sessionStore: sessionStore,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    test('§61 Load Benchmark: 100 concurrent sessions execute commands without race conditions', () async {
      final futures = <Future<UnifiedBotResponse>>[];

      for (int i = 0; i < 100; i++) {
        final msg = UnifiedIncomingMessage(
          messageId: 'concurrent_msg_$i',
          channel: ChannelType.telegram,
          externalUserId: 'load_user_$i',
          text: '/prayer',
          timestamp: DateTime.now().toUtc(),
        );
        futures.add(platform.handleUnifiedMessage(msg));
      }

      final results = await Future.wait(futures);
      expect(results.length, equals(100));
      for (final res in results) {
        expect(res.textArabic, contains('مواقيت الصلاة'));
      }
    });

    test('§61 Burst Throughput: 500 messages are handled safely without resource exhaustion', () async {
      int successCount = 0;
      for (int i = 0; i < 500; i++) {
        final msg = UnifiedIncomingMessage(
          messageId: 'burst_msg_$i',
          channel: ChannelType.api,
          externalUserId: 'api_client_${i % 10}',
          text: '/help',
          timestamp: DateTime.now().toUtc(),
        );
        final res = await platform.handleUnifiedMessage(msg);
        if (res.textArabic.contains('دليل أوامر سِراج')) {
          successCount++;
        }
      }

      expect(successCount, equals(500));
    });

    test('§62 Chaos Simulation: Partial tool failure does not crash the bot and degrades safely', () async {
      // 1. Valid tool execution works
      final resValid = await platform.toolRegistry.executeTool(
        toolName: 'get_prayer_schedule',
        arguments: {},
      );
      expect(resValid.isSuccess, isTrue);

      // 2. Faulty / non-existent tool execution degrades safely
      final resFaulty = await platform.toolRegistry.executeTool(
        toolName: 'non_existent_chaos_tool',
        arguments: {},
      );
      expect(resFaulty.isSuccess, isFalse);
      expect(resFaulty.errorMessageArabic, isNotNull);
    });
  });
}
