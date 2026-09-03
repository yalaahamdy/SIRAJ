import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/domain/bot_error.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/ops/bot_operations_platform.dart';
import 'package:siraj/services/bot/ops/security/staging_allowlist.dart';
import 'package:siraj/services/bot/runtime/bot_runtime_engine.dart';
import '../../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M16 Bot Staging Adversarial & Control Suite (§64)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late StagingAllowlist allowlist;
    late BotOperationsPlatform opsPlatform;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      final runtime = BotRuntimeEngine.bootstrap(
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );

      allowlist = StagingAllowlist(
        enforceAllowlist: true,
        initialAllowedUsers: {'allowed_tester_1'},
      );

      opsPlatform = BotOperationsPlatform.bootstrap(
        runtimeEngine: runtime,
        stagingAllowlist: allowlist,
      );
    });

    test('Adversarial 1: Unauthorized Staging User is gated by Allowlist and logged', () async {
      final msg = UnifiedIncomingMessage(
        messageId: 'unauth_msg_1',
        channel: ChannelType.telegram,
        externalUserId: 'unauthorized_random_user',
        text: '/prayer',
        timestamp: DateTime.now().toUtc(),
      );

      final res = await opsPlatform.processStagingMessage(msg);
      expect(res.isAbstained, isTrue);
      expect(res.textArabic, contains('بيئة الاختبار التجريبية'));
      expect(opsPlatform.securityLogger.events.isNotEmpty, isTrue);
    });

    test('Adversarial 2: Rapid Message Flooding triggers automatic user blocking', () async {
      const floodUser = 'allowed_tester_1';

      // Send 25 rapid messages (Threshold = 20)
      bool blocked = false;
      for (int i = 0; i < 25; i++) {
        final msg = UnifiedIncomingMessage(
          messageId: 'flood_msg_$i',
          channel: ChannelType.telegram,
          externalUserId: floodUser,
          text: '/prayer',
          timestamp: DateTime.now().toUtc(),
        );

        try {
          await opsPlatform.processStagingMessage(msg);
        } catch (e) {
          if (e is SafeBotException && e.reason == BotFailureReason.rateLimitExceeded) {
            blocked = true;
            break;
          }
        }
      }

      expect(blocked, isTrue);
      expect(opsPlatform.moderation.isUserBlocked(floodUser), isTrue);
    });

    test('Adversarial 3: Global Safety Kill Switch blocks conversational AI while preserving deterministic commands', () async {
      // 1. Trigger AI kill switch
      opsPlatform.killSwitch.killAi(reason: 'Emergency Safety Test');

      // 2. Conversational query is safely blocked
      final queryMsg = UnifiedIncomingMessage(
        messageId: 'query_killed_1',
        channel: ChannelType.telegram,
        externalUserId: 'allowed_tester_1',
        text: 'ما فضل صيام عاشوراء؟',
        timestamp: DateTime.now().toUtc(),
      );
      final queryRes = await opsPlatform.processStagingMessage(queryMsg);
      expect(queryRes.isAbstained, isTrue);
      expect(queryRes.textArabic, contains('الأوامر الحتمية'));

      // 3. Deterministic command still works
      final cmdMsg = UnifiedIncomingMessage(
        messageId: 'cmd_live_1',
        channel: ChannelType.telegram,
        externalUserId: 'allowed_tester_1',
        text: '/prayer',
        timestamp: DateTime.now().toUtc(),
      );
      final cmdRes = await opsPlatform.processStagingMessage(cmdMsg);
      expect(cmdRes.isAbstained, isFalse);
      expect(cmdRes.textArabic, contains('مواقيت الصلاة'));
    });
  });
}
