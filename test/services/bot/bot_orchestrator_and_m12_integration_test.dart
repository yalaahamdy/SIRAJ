import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/ai/domain/grounding_status.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/siraj_bot_platform.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('L3 Bot Orchestrator & M12 AI Integration Tests (§26, §67, §68)', () {
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late SirajBotPlatform platform;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      platform = SirajBotPlatform(
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    test('End-to-end processing of informational query returns fully grounded response with citations', () async {
      final msg = UnifiedIncomingMessage(
        messageId: 'msg_info_1',
        channel: ChannelType.telegram,
        externalUserId: 'tg_usr_1',
        text: 'ما نص حديث النية؟',
        timestamp: DateTime.now().toUtc(),
      );

      final res = await platform.handleUnifiedMessage(msg);

      expect(res.isAbstained, isFalse);
      expect(res.groundingStatus, equals(GroundingStatus.fullyGrounded));
      expect(res.citations.isNotEmpty, isTrue);
      expect(res.textArabic, contains('النية'));
      expect(platform.auditLogs.isNotEmpty, isTrue);
    });

    test('End-to-end processing of personal fatwa query enforces abstention in Bot platform', () async {
      final msg = UnifiedIncomingMessage(
        messageId: 'msg_fatwa_1',
        channel: ChannelType.whatsapp,
        externalUserId: 'wa_usr_1',
        text: 'افتني في مسألة طرأت لي',
        timestamp: DateTime.now().toUtc(),
      );

      final res = await platform.handleUnifiedMessage(msg);

      expect(res.isAbstained, isTrue);
      expect(res.groundingStatus, equals(GroundingStatus.abstained));
      expect(res.abstentionReasonArabic, contains('ليست هيئة إفتاء'));
    });

    test('Raw inbound webhook processing through Gateway and Adapters', () async {
      final rawTelegram = {
        'message': {
          'message_id': 555,
          'from': {'id': 777888},
          'text': '/start',
        },
      };

      final formattedOutbound = await platform.handleRawInbound(
        channel: ChannelType.telegram,
        rawPayload: rawTelegram,
      );

      expect(formattedOutbound['text'], contains('مرحباً بك في سِراج'));
      expect(formattedOutbound['reply_markup'], isNotNull);
    });
  });
}
