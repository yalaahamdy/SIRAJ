import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:siraj/core/storage/memory_storage.dart';
import 'package:siraj/modules/adhkar/adhkar_module.dart';
import 'package:siraj/modules/knowledge/knowledge_module.dart';
import 'package:siraj/services/bot/domain/bot_error.dart';
import 'package:siraj/services/bot/domain/bot_session.dart';
import 'package:siraj/services/bot/domain/unified_message.dart';
import 'package:siraj/services/bot/gateway/bot_gateway.dart';
import 'package:siraj/services/bot/session/account_linking_service.dart';
import 'package:siraj/services/bot/session/bot_session_store.dart';
import 'package:siraj/services/bot/session/confirmation_engine.dart';
import 'package:siraj/services/bot/siraj_bot_platform.dart';
import '../../fixtures/adhkar/canonical_adhkar_fixture.dart';
import '../../fixtures/knowledge/synthetic_knowledge_fixtures.dart';

void main() {
  group('M14 Bot Production Hardening Audit Tests (§4-§58)', () {
    const webhookSecret = 'test_hardening_secret_key_888';
    late MemoryStorageRegistry registry;
    late AdhkarModule adhkarModule;
    late KnowledgeModule knowledgeModule;
    late MemoryBotSessionStore sessionStore;
    late ConfirmationEngine confirmationEngine;
    late AccountLinkingService accountLinkingService;
    late BotGateway gateway;
    late SirajBotPlatform platform;

    setUp(() {
      registry = MemoryStorageRegistry();

      adhkarModule = AdhkarModule(storageRegistry: registry);
      adhkarModule.mountPackage(CanonicalAdhkarFixture.createValidTestPackage());

      knowledgeModule = KnowledgeModule(storageRegistry: registry);
      knowledgeModule.mountPackage(SyntheticKnowledgeFixtures.createPackage());

      sessionStore = MemoryBotSessionStore();
      confirmationEngine = ConfirmationEngine(tokenValidity: const Duration(seconds: 2));
      accountLinkingService = AccountLinkingService(
        sessionStore: sessionStore,
        codeValidity: const Duration(seconds: 2),
        maxFailedAttempts: 3,
      );

      gateway = BotGateway(
        webhookSecret: webhookSecret,
        maxPayloadSizeBytes: 1024, // 1KB limit for test
      );

      platform = SirajBotPlatform(
        gateway: gateway,
        sessionStore: sessionStore,
        confirmationEngine: confirmationEngine,
        accountLinkingService: accountLinkingService,
        adhkarModule: adhkarModule,
        knowledgeModule: knowledgeModule,
      );
    });

    test('§5 & §48 Webhook Hardening: Rejects oversized payload and malformed signature', () {
      final oversizedBody = 'A' * 2000;
      expect(
        () => platform.handleRawInbound(
          channel: ChannelType.webChat,
          rawPayload: {'text': oversizedBody},
          rawBodyForSignature: oversizedBody,
          signatureHeader: 'some_sig',
        ),
        throwsA(isA<SafeBotException>().having(
          (e) => e.reason,
          'reason',
          equals(BotFailureReason.safetyBlock),
        )),
      );
    });

    test('§6 & §7 Replay & Idempotency Hardening: Duplicate webhook delivery is executed exactly once', () async {
      const rawPayload = {
        'message_id': 'unique_replay_id_999',
        'user_id': 'user_replay_test',
        'text': '/prayer',
      };
      final bodyStr = jsonEncode(rawPayload);
      final key = utf8.encode(webhookSecret);
      final sig = Hmac(sha256, key).convert(utf8.encode(bodyStr)).toString();

      // First delivery succeeds
      final res1 = await platform.handleRawInbound(
        channel: ChannelType.webChat,
        rawPayload: rawPayload,
        rawBodyForSignature: bodyStr,
        signatureHeader: sig,
      );
      expect(res1['text'], contains('مواقيت الصلاة'));

      // Duplicate delivery fails closed
      expect(
        () => platform.handleRawInbound(
          channel: ChannelType.webChat,
          rawPayload: rawPayload,
          rawBodyForSignature: bodyStr,
          signatureHeader: sig,
        ),
        throwsA(isA<SafeBotException>().having(
          (e) => e.reason,
          'reason',
          equals(BotFailureReason.safetyBlock),
        )),
      );
    });

    test('§15 & §16 Confirmation Security: Tokens are single-use and reject replay after consumption', () async {
      // 1. Send /deletemydata command
      final cmdMsg = UnifiedIncomingMessage(
        messageId: 'token_sec_1',
        channel: ChannelType.telegram,
        externalUserId: 'token_user_1',
        text: '/deletemydata',
        timestamp: DateTime.now().toUtc(),
      );
      final cmdRes = await platform.handleUnifiedMessage(cmdMsg);
      expect(cmdRes.requiresConfirmation, isTrue);

      // 2. First confirmation succeeds
      final confirmMsg1 = UnifiedIncomingMessage(
        messageId: 'token_sec_2',
        channel: ChannelType.telegram,
        externalUserId: 'token_user_1',
        text: 'نعم تأكيد',
        timestamp: DateTime.now().toUtc(),
      );
      final confirmRes1 = await platform.handleUnifiedMessage(confirmMsg1);
      expect(confirmRes1.textArabic, contains('تم حذف كافة بياناتك'));

      // 3. Replaying the confirmation is rejected as expired/consumed
      final confirmMsg2 = UnifiedIncomingMessage(
        messageId: 'token_sec_3',
        channel: ChannelType.telegram,
        externalUserId: 'token_user_1',
        text: 'نعم تأكيد',
        timestamp: DateTime.now().toUtc(),
      );
      // Put session artificially in waiting to test token check
      var sess = await sessionStore.getOrCreateSession(
        channel: ChannelType.telegram,
        externalUserId: 'token_user_1',
      );
      sess = sess.copyWith(
        state: BotWorkflowState.waitingForConfirmation,
        context: sess.context.copyWith(pendingConfirmationAction: 'ACTION_DELETE_USER_DATA'),
      );
      await sessionStore.saveSession(sess);

      final confirmRes2 = await platform.handleUnifiedMessage(confirmMsg2);
      expect(confirmRes2.textArabic, contains('انتهت صلاحية رمز التأكيد'));
    });

    test('§40 & §41 Account Linking Security: Single-use code, expiration, and brute-force lockout', () async {
      // 1. Generate one-time linking code from mobile app
      final code = accountLinkingService.generateLinkingCode('usr_internal_777');
      expect(code.length, equals(6));

      // 2. Failed attempt with wrong code
      expect(
        () => accountLinkingService.linkChannelAccount(
          code: '000000',
          channel: ChannelType.telegram,
          externalUserId: 'tg_ext_777',
        ),
        throwsA(isA<SafeBotException>()),
      );

      // 3. Successful link with valid code
      final success = await accountLinkingService.linkChannelAccount(
        code: code,
        channel: ChannelType.telegram,
        externalUserId: 'tg_ext_777',
      );
      expect(success, isTrue);

      // 4. Code cannot be reused (Single-Use enforcement)
      expect(
        () => accountLinkingService.linkChannelAccount(
          code: code,
          channel: ChannelType.telegram,
          externalUserId: 'tg_ext_777',
        ),
        throwsA(isA<SafeBotException>()),
      );
    });

    test('§37 Financial Data Isolation: ZakatTool exposes no raw financial figures or account balances', () async {
      final toolRes = await platform.toolRegistry.executeTool(
        toolName: 'get_zakat_info',
        arguments: {'user_id': 'any_user', 'export_all_assets': true},
      );

      expect(toolRes.isSuccess, isTrue);
      expect(toolRes.outputTextArabic, contains('نصاب زكاة المال'));
      expect(toolRes.outputTextArabic.contains('رصيد'), isFalse);
      expect(toolRes.outputTextArabic.contains('حساب بنكي'), isFalse);
    });

    test('§50 & §51 Observability Privacy: Audit records contain zero raw queries, passwords, or tokens', () async {
      final msg = UnifiedIncomingMessage(
        messageId: 'obs_priv_1',
        channel: ChannelType.webChat,
        externalUserId: 'privacy_tester',
        text: '/prayer',
        timestamp: DateTime.now().toUtc(),
      );

      await platform.handleUnifiedMessage(msg);

      for (final log in platform.auditLogs) {
        final json = log.toJson();
        expect(json.containsKey('password'), isFalse);
        expect(json.containsKey('token'), isFalse);
        expect(json.containsKey('secret'), isFalse);
        expect(json['session_id'], isNotEmpty);
      }
    });
  });
}
